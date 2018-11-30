# !/bin/bash
#
set -x
#
source /home/postgres/.bash_profile

YEARM1M=`date --date='1 months ago' +%Y`
MONTHM1M=`date --date='1 months ago' +%m`
thisDate=`date +%Y%m%d%H%M%S`
calcDate=${YEARM1M}-${MONTHM1M}
emailRecipTest="dolson@cctus.com"
emailRecip="dba@cctus.com,nyoda@cctus.com,csharkey@j-com.co.jp,mzwecker@contournetworks.com"
reportOnly="N"
tset="N"

BASEDIR=/home/postgres/dba/special/rating_engine
LOGFILE=$BASEDIR/logs/rating_engine_calc.`date +%Y%m%d`
TEMPFILE=$BASEDIR/logs/rating_engine_calc.temp
ERRFILE=$BASEDIR/logs/rating_engine_calc.err
LOCK=$BASEDIR/jobs/`basename $0`.lock

usageHeader="jbilling_id,beid,be_name,old_product_code,otaps_product_code,carrier_product_code,carrier,rectype,line_id,usage_date,base_mb,line_cnt,tot_thshld,in_octets,out_octets,tot_usage,over,usage_fee_text,source"
overageHeader="jbillid,otaps_product_code,usage_fee_text,usage_date,line_cnt,overage"
overageTemp=$BASEDIR/exports/overage.csv
usageTemp=$BASEDIR/exports/usage.csv
FILE1=$BASEDIR/exports/OPENTAPS_overage_usage_records_$calcDate.csv
FILE2=$BASEDIR/exports/OPENTAPS_carrier_usage_records_$calcDate.csv
SUBJECT="Rating Engine Calculation Usage Files"
MUTT=/usr/bin/mutt
Usage ()
{
  echo "Usage: rating_engine_calc.sh  -t -r "                                             |tee    $ERRFILE
  echo "   ------------------------------------------------------------------------"    |tee -a $ERRFILE
  echo "      t= (optional) t = test run;  all emails sent to dba team only"            |tee -a $ERRFILE
  echo "   ------------------------------------------------------------------------"    |tee -a $ERRFILE
  echo "   Job submitted as :   $SCRIPTDIR/rating_engine_calc.sh  $options"               |tee -a $ERRFILE
  cat $ERRFILE | mail -s "ERROR: Rating Engine Calculation on `hostname`)" $mailRecip
  exit 1
}


# this is the actual sql job
echo "-----------------------------Start of  Rating Engine Calculation------------------------------" |tee    $LOGFILE
echo ""                                                                                               |tee -a $LOGFILE
while getopts tr params
   do
     case $params in
        t) test="Y"
           emailRecip=$emailRecipTest
           options="$options -t"
           ;;
        r) reportOnly="Y"
           ;;
        *) Usage
           ;;                     # display usage and exit
     esac
   done

echo "BEG: `date '+%Y%m%d_%H:%M:%S'`"  |tee -a $LOGFILE
if [ $reportOnly = "Y" ];then
     echo "New Calculation not executed- Report Generation Only "                                       |tee -a $LOGFILE
else
    echo "Starting otaps_monthly_usage_summary_func"                                                     |tee -a $LOGFILE
    psql -U slony -d csctoss   -c "select * from csctoss.otaps_monthly_usage_summary_func('$calcDate')" |tee     $TEMPFILE
    result=$?
    if [ $result -ne 0 ]; then
        echo "Rating Engine Calculation Failure"
        cat $TEMPFILE | mailx -s "Rating Engine Calculation for `hostname` Failure" $emailRecip 
    fi
    check output for SUCCESS, if not job failed and send email
    if [ `grep "ERROR" $TEMPFILE | wc -l` -ne 0 ]; then
        cat $TEMPFILE | mail -s "Rating Engine Calculation for `hostname` Failure" $emailRecip 
    fi
     echo "otaps_monthly_usage_summary_func has completed" |tee -a $LOGFILE
fi
#
echo ""                                                                                               |tee -a $LOGFILE
echo "Creating usage overage csv file" |tee -a $LOGFILE
psql  -U slony -d csctoss -q -t --no-align -F , -o $overageTemp << EOF
select
  jbilling_id as jbillid
, otaps_product_code
, usage_fee_text
, usage_date
, num_of_lines_in_pool  as line_cnt
, usage_overage   as overage
from csctoss.otaps_monthly_usage_summary
where 1=1
  and not archived
  and usage_date='$calcDate'
  and usage_overage > 0
order by jbilling_id,otaps_product_code,line_id, usage_date;
EOF
 result=$?
 if [ $result -ne 0 ]; then
      echo "Rating Engine Calculation for `hostname` Failure"                                      |tee -a $LOGFILE
      cat $LOGFILE | mail -s "Rating Engine Calculation for `hostname` Failure" $emailRecip 
fi
#
echo "Creating carrier usage csv file" |tee -a $LOGFILE
psql  -U slony -d csctoss -q -t --no-align -F , -o $usageTemp << EOF
select
  jbilling_id
, billing_entity_id 
,'"'|| billing_entity_name ||'"'
, old_product_code
, otaps_product_code
, carrier_product_code
, carrier
, record_type 
, line_id
, usage_date
, base_mb
, num_of_lines_in_pool  
, total_threshold  
, acctinputoctets  
, acctoutputoctets 
, total_usage   
, usage_overage   
, usage_fee_text
, usage_source 
from csctoss.otaps_monthly_usage_summary
where 1=1
  and not archived
  and usage_date='$calcDate'
order by jbilling_id,usage_date, old_product_code,line_id,record_type;
EOF
if [ $result -ne 0 ]; then
      echo "Rating Engine Calculation for `hostname` Failure"                                      |tee -a $LOGFILE
      cat $LOGFILE | mail -s "Rating Engine Calculation for `hostname` Failure" $emailRecip 
fi
echo "Started adding column headers to csv files"                                                           |tee -a $LOGFILE
echo "$overageHeader"  >  $FILE1
cat $overageTemp    >> $FILE1
echo "$usageHeader"    >  $FILE2
cat $usageTemp      >> $FILE2
echo "Completed adding column headers to csv files"                                                           |tee -a $LOGFILE
echo "End of csv file generation" |tee -a $LOGFILE
echo ""                                                                                               |tee -a $LOGFILE

# log results and cleanup
echo "Begin SQL output"                                                                                    |tee -a $LOGFILE
cat $TEMPFILE                                                                                        |tee -a $LOGFILE
echo ""                                                                                               |tee -a $LOGFILE
echo "End SQL output"                                                                                    |tee -a $LOGFILE
echo "END: `date '+%Y%m%d_%H:%M:%S'`" |tee -a $LOGFILE
echo "------------------------------End of Rating Engine Calculation------------------------------" |tee -a $LOGFILE
$MUTT -i $LOGFILE -a $FILE1 -a $FILE2 -s "$SUBJECT" $emailRecip < /dev/null
# $MUTT -i $LOGFILE -a $FILE2 -s "$SUBJECT" $emailRecip < /dev/null

exit 0
