#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

DATE=`date --date='yesterday' +%Y%m%d`
DATE_TODAY=`date +%Y%m%d`
SUBJECT="Termination Request By Hour Report for $DATE (UTC)"
SUBJECT_TODAY="Termination Request By Hour Report for $DATE_TODAY: midnight to current hour (UTC)"
BASEDIR=/home/postgres/dba
LOGFILE_HDR=$BASEDIR/logs/hdr.out
LOGFILE_BODY=$BASEDIR/logs/body.out
LOGFILE=$BASEDIR/logs/term_request_by_hour_report_$DATE.txt
LOGFILE_HDR2=$BASEDIR/logs/heading.out
testOutput=$BASEDIR/jobs/testOutput_this_1.out
mutt=/usr/local/bin/mutt

rptHour="false"
SQL_FILE=/home/postgres/dba/jobs/hourly_report_function_call.sql
exceedsThresh="false"

RECIP1="dolson@cctus.com,btekeste@cctus.com"
#RECIP2="gdeickman@cctus.com,nyoda@cctus.com,yshibuya@j-com.co.jp,jprouty@cctus.com,ktaylor@cctus.com,dolson@cctus.com,btekeste@cctus.com"
#final list for recip2 in prod
RECIP2="dba@cctus.com,jprouty@cctus.com,jobrey@cctus.com,gdeickman@cctus.com,mwinn@contournetworks.com,bkrewson@cctus.com,jreed@cctus.com,nyoda@cctus.com"
RECIP3="gdeickman@cctus.com"
RECIP4="gdeickman@cctus.com,jprouty@cctus.com,jobrey@cctus.com,btekeste@cctus.com"
toMe="btekeste@cctus.com,bentekeste@gmail.com"

THIS_HR=`date +%k`
MAIL_SW="on"
#myHour=07
#myThresh=10000
myTest="false"
mySpec="false"
checkTotals="off"
curr_hour=`date +%k`
checkTotals="off"
check_these="off"


Usage()
{
    echo "usage: term_request_by_hour_report_new.sh -h -t -s -x  "
    echo "    -h : hour of day in which email of hourly report is always sent"
    echo "    -t : error threshold.  when this number is exceeded an email will be sent regardless of the hour of day"
    echo "    -s : special report.  used to indicate a special run again current day instead of the previous day"
    echo "    -x : testing- only email to dev team"

    exit 1
}

while getopts h:t:sx myOpt
   do
     case $myOpt in
        h) myHour="$OPTARG" ;;        
        t) myThresh="$OPTARG" ;;     
        s) mySpec="true" ;;     
        x) myTest="true" ;;     
        *) Usage ;;           #display usage and exit  
esac
   done 

echo "select CASE WHEN hour='Totals: ' " > $SQL_FILE
echo 'THEN hour ELSE lpad(hour,2,'0') END as "Hr",' >> $SQL_FILE
echo 'ar_count_spr as "Admin Reset", ne_count_spr as "NAS Error", ' >> $SQL_FILE
echo 'ss_count_spr as "Short Session",this_space as "--",'>> $SQL_FILE
echo 'ar_count_usc as "Admin Reset", ne_count_usc as "NAS Error",'>> $SQL_FILE
echo 'ss_count_usc as "Short Session "'>> $SQL_FILE

echo "<b>"  > $LOGFILE_HDR

if [ $myHour -eq $THIS_HR ];then
        rptHour="true"
	echo "hour matches;sending mail"
fi

if [[ $mySpec = "true" || $rptHour != "true" && $myTest = "false" ]];then
        echo "$SUBJECT_TODAY" >> $LOGFILE_HDR
	echo "from csctoss.TERM_REQUEST_BY_HOUR_NEW(true);"  >> $SQL_FILE
else
	echo "$SUBJECT" >> $LOGFILE_HDR
        echo "from csctoss.TERM_REQUEST_BY_HOUR_NEW(false);" >> $SQL_FILE
fi

psql -H -o $LOGFILE_BODY -q  -f $SQL_FILE

# prettyize message, exec function, capture results
echo "<p>" >> $LOGFILE_HDR
echo "" >> $LOGFILE_HDR
#echo "-----------------------------------------------------" >> $LOGFILE_HDR
echo "<p>"  >> $LOGFILE_HDR
echo "" >> $LOGFILE_HDR
#
echo "</b>"  >> $LOGFILE_HDR

echo "&nbsp;  HR &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;SPRINT &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  USCC "  >> $LOGFILE_HDR
#echo " " > $testOutput


if [ $rptHour = "false" ];then

	IFS=$'\n'
 	for i in `cat $LOGFILE_BODY |grep "align"|grep -v "\<th>" `

	do
        	myRow=$i

      	        for j in `echo $myRow|grep -v "\--"|grep "<td"| awk -F\< {'print $2'}|awk  -F\> {'print $2'}|grep -v ";"|sed 's/^0*//'`

      		do
           		if [ $j = "Totals: " ];then
                		checkTotals="on"
           		fi

           		if [ $checkTotals = "off" ];then
                	     #let myNum=$j
                	     myNum=$j
                	     #echo "myNum:  $myNum"

                	     if [ $myNum = $curr_hour ];then
                                  check_these="on"
                	     fi

                	     if [ $check_these = "on" ];then
                     	          if [ $myNum -gt $myThresh ];then
                                       #echo "setting mail sw because a error count exceeded the threshold passed in the (-t) param"
                                       exceedsThresh="true"
                                  fi
                             fi

                        fi
                done


        done

fi


cat $LOGFILE_HDR $LOGFILE_BODY > $LOGFILE

# get ready to email the report by setting recipient list

if [ $myTest = "true" ];then
     RECIP=$RECIP1
     
else
    if [ $mySpec = "true" ];then
         RECIP=$RECIP3
    else
        if [ $rptHour = "true" ];then
             RECIP=$RECIP2
	else
	    if [ $exceedsThresh = "true" ];then
                 #different mail command for this occasion inorder to set subject line 
		 RECIP=$toMe
		 $mutt -e "set content_type= text/html" -s "Termination Request By Hour Report: HIGH COUNT ALERT" $RECIP4 < ${LOGFILE}
                 MAIL_SW="off" 
	    else
		 MAIL_SW="off"
	    fi
        fi
    fi
fi

if [ $MAIL_SW = "on" ];then       
	 #mutt -e "my_hdr Content-Type: text/html" -s "Termination Request By Hour Report" $RECIP < ${LOGFILE}
 	 $mutt -e "set content_type= text/html" -s "Termination Request By Hour Report" $RECIP < ${LOGFILE}
   
fi


#remove log files older than 7 days
find $BASEDIR/logs/term_request_by_hour_report_* -mtime +7 -exec rm -f {} \;
exit 0
