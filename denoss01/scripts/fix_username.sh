#!/bin/bash
#
#  This script will change the username in the following tables.    Occasionaly, the username is
#  entered into the OSS database incorrectly.  This script allows the username to be corrrected.
#   1) username
#   2) radreply
#   3) radcheck
#   4) usergroup
#   5) line
#
#  The script is interactive.  The user will be expected to enter the incorrect username first.  Then the correct username.
# usage: fix_username.sh
#
usage()
{
   echo "usage: fix_username.sh <arg>"
   echo "   where arg1 is optional: values are: test"
   echo "   passing any arg will result in the script using a default username for all updates"
   echo "      ex: fix_username.sh test"
}
check_db_ret()
{
   db_return=$1
   if [ $db_return -ne 0 ];then
       echo "DB execution failed-  exiting" |tee -a $LOGFILE
       exit 1
   fi
   
}
continue()
{
    echo "Do you wish to continue?  [ y/n ] "
    read yn
    if [ $yn = "y" ];then
        echo "You entered '$yn' - Continuing" |tee -a $LOGFILE
    else
       echo "You entered '$yn' -  Exiting now"
       exit 2
   fi
}
source /home/postgres/.bash_profile

if [ $# -gt 0 ];then
   test=1
else
   test=0
fi


DATE=`date +%m%d_%H%M%S`

SUBJECT="Fix Username script has been executed on $DATE"
HEADING="    Username fix has started"  |tee -a $LOGFILE
BASEDIR=/home/postgres/dba/scripts
LOGFILE=$BASEDIR/logs/fix_username_$DATE.log
SQLOUT=$BASEDIR/logs/fix_username.out
status=0
status2=0
test=0
while getopts ":t" opt; do
  case $opt in
    t) test=1 ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
# prettyize message, exec function, capture results
clear

echo "$HEADING"                                              |tee $LOGFILE
echo "-----------------------------------------------------" |tee -a $LOGFILE

empid='dolson'

echo "Please enter the username you wish to change: " |tee -a $LOGFILE
read invalid_username

if  [ $test -eq 1 ];then
   echo "In TEST mode- using default usernames" |tee $LOGFILE
   invalid_username="6462410806@tsp17.sprintpcs.com"
fi

if [ "$invalid_username" = "" ];then
      echo "You entered an invalid username-  exiting" |tee -a $LOGFILE
      exit 4
fi
echo "" |tee -a $LOGFILE

echo "You entered: $invalid_username : Please double check this username before continuing"  |tee -a $LOGFILE
echo "" |tee -a $LOGFILE

continue

echo "" |tee -a $LOGFILE

psql -q -t -c "select 'username:'||count(*)  from csctoss.username    where username  = '$invalid_username'" > $SQLOUT
check_db_ret $?
username_cnt=`cat  $SQLOUT|grep "username:"|awk -F: {'print $2'}`
psql -q -t -c "select 'radreply:'||count(*)  from csctoss.radreply    where username  = '$invalid_username'" > $SQLOUT
check_db_ret $?
radreply_cnt=`cat  $SQLOUT|grep "radreply:"|awk -F: {'print $2'}`
psql -q -t -c "select 'radcheck:'||count(*)  from csctoss.radcheck    where username  = '$invalid_username'" > $SQLOUT
check_db_ret $?
radcheck_cnt=`cat  $SQLOUT|grep "radcheck:"|awk -F: {'print $2'}`
psql -q -t -c "select 'usergroup:'||count(*) from csctoss.usergroup   where username  = '$invalid_username'" > $SQLOUT
check_db_ret $?
usergroup_cnt=`cat  $SQLOUT|grep "usergroup:"|awk -F: {'print $2'}`
psql -q -t -c "select 'line:'||count(*)      from csctoss.line where  radius_username = '$invalid_username'" > $SQLOUT
check_db_ret $?
line_cnt=`cat  $SQLOUT|grep "line:"|awk -F: {'print $2'}`

#  clear the SQLOUT file so that it can be clean for function 
cat /dev/null > $SQLOUT
#
echo "Please review row counts before continuing with username modification" |tee -a $LOGFILE 
echo "" |tee -a $LOGFILE
echo "Table:    username     radreply  radcheck  usergroup    line" |tee -a $LOGFILE
echo "------   ----------    --------  --------  ---------    ----" |tee -a $LOGFILE
echo -n "Row Cnt      " |tee -a $LOGFILE
echo -n "$username_cnt" |tee -a $LOGFILE 
echo -n "            "  |tee -a $LOGFILE
echo -n "$radreply_cnt" |tee -a $LOGFILE 
echo -n "          "    |tee -a $LOGFILE
echo -n "$radcheck_cnt" |tee -a $LOGFILE 
echo -n "         "     |tee -a $LOGFILE
echo -n "$usergroup_cnt"|tee -a $LOGFILE 
echo -n "         "     |tee -a $LOGFILE
echo    "$line_cnt"     |tee -a $LOGFILE

echo "" |tee -a $LOGFILE
echo "" |tee -a $LOGFILE
if [ $username_cnt -eq 0 ]; then
   echo "There are no rows containing this username in the username table" |tee -a $LOGFILE
   echo "" |tee -a $LOGFILE
fi
continue

echo "" |tee -a $LOGFILE
echo "Please enter the new username : " |tee -a $LOGFILE
read new_username

echo "" |tee -a $LOGFILE

if  [ $test -eq 1 ];then
   echo "In TEST mode- using default usernames" |tee $LOGFILE
   new_username="6462410806@tsp17.sprintpcs.com"
fi

echo "" |tee -a $LOGFILE

if [ "$new_username" = "" ];then
      echo "You entered an invalid username-  exiting" |tee -a $LOGFILE
      exit 4
fi

echo "You entered: $new_username : Please double check this username before continuing"  |tee -a $LOGFILE
echo "" |tee -a $LOGFILE
continue

echo "" |tee -a $LOGFILE

#psql -q -t -c "select * from fix_username_func('6462410806@tsp17.sprintpcs.com','6462410806@tsp99.sprintpcs.com','dolson')" > $SQLOUT
#psql  -c "select * from fix_username_func('6462410806@tsp17.sprintpcs.com','6462410806@tsp99.sprintpcs.com','dolson')" |tee -a $SQLOUT
#psql -q -t -c "select * from fix_username_func('$invalid_username','$new_username','$empid',$username_cnt,$radcheck_cnt,$radreply_cnt,$usergroup_cnt,$line_cnt)" |tee  $SQLOUT

echo "" |tee -a $LOGFILE
echo "Calling DB function to perform updates" | tee $SQLOUT
echo "" |tee -a $LOGFILE
psql -q -t -c "select * from fix_username_func('$invalid_username','$new_username','$empid',$username_cnt,$radcheck_cnt,$radreply_cnt,$usergroup_cnt,$line_cnt)"  2>&1 | tee $SQLOUT

cat $SQLOUT >> $LOGFILE
echo "" |tee -a $LOGFILE
let status=`cat $LOGFILE|grep "failed"|wc -l`
let status2=`cat $LOGFILE|grep "psql:"|wc -l`

if [ $status -ne 0 ];then
       echo "The username update was not successful" |tee -a $LOGFILE
       echo "exiting script" |tee -a $LOGFILE
       exit 1
elif [ $status2 -ne 0 ];then
       echo "The username update was not successful" |tee -a $LOGFILE
       echo "exiting script" |tee -a $LOGFILE
       exit 1
else
       echo "The username update completed successfully" |tee -a $LOGFILE
       echo "Please review to ensure all updates are correct" |tee -a $LOGFILE
       echo "exiting script" |tee -a $LOGFILE
       
   fi

echo "" |tee -a $LOGFILE
echo "LOGFILE Location is: $LOGFILE"
echo "-----------------------------------------------------------------------------------------------" |tee -a $LOGFILE
# email the report



RECIP1="dolson@cctus.com"



#  mutt -s "SPRINT & USCC TOP 20 Consolidated Report for $DATE" -a $LOGFILE $NAME < ${LOGFILE}
exit 0

