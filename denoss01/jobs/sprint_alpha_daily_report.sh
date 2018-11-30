# !/bin/bash
#
# ALPHA daily summary report for the following statistics:
#   1) The number of new users per day
#   2) The number of valid service users per day
#   3) The number of expired service users per day
#   4) The number of users who filled Doccica up per day
#

source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/sprint_alpha_daily_report.out
TMPFILE=$BASEDIR/logs/sprint_alpha_daily_report.tmp
YESTERDAY=`date --date='yesterday' +%Y-%m-%d`
TODAY=`date +%Y-%m-%d`
START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"

TEMPCSV=$BASEDIR/logs/temp.csv
REFFILE=$BASEDIR/logs/Doccica_Refill_$YESTERDAY.csv
USGFILE=$BASEDIR/logs/Doccica_Summary_Usage_$YESTERDAY.csv
DETFILE=$BASEDIR/logs/Doccica_Detail_Usage_$YESTERDAY.csv

# message body header
echo "---------------------------------------------------"  > $LOGFILE
echo "SPRINT ALPHA User Statistics Report For: $YESTERDAY" >> $LOGFILE
echo "---------------------------------------------------" >> $LOGFILE
echo                                                       >> $LOGFILE

# get the radius database connect info and store in vars
psql -q -t -U postgres -c \
  "select * 
     from csctoss.system_parameter
    where hostname = 'denrad08'" > $TMPFILE

sed "s/[ \t][ \t]*//g" $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

RADHOST=`cut -d '|' -f 1 $TMPFILE`
RADPORT=`cut -d '|' -f 3 $TMPFILE`
RADDATA=`cut -d '|' -f 4 $TMPFILE`
RADUSER=`cut -d '|' -f 5 $TMPFILE`
export PGPASSWORD=`cut -d '|' -f 6 $TMPFILE`

# get radius timezone
TZ=`psql -q -t -h $RADHOST -p $RADPORT -d $RADDATA -U $RADUSER -c \
  "select upper(local_timezone) from radius.local_timezone"`
TZ=`echo $TZ|tr -s " "`

##################################################################
# 1) new daily users (radius)
##################################################################

NEW=`psql -q -t -h $RADHOST -p $RADPORT -d $RADDATA -U $RADUSER -c \
    "select count(distinct(cont.contract_id)) as new_user
       from radius.contract cont
       join radius.plan using (contract_id)
      where plan.plan_type_id = 8
        and plan.service_set_id = 1104
        and not cont.dormant
        and cont.first_day at time zone '$TZ' = '$YESTERDAY'"`

##################################################################
# 2) all valid users (radius)
##################################################################

ALL=`psql -q -t -h $RADHOST -p $RADPORT -d $RADDATA -U $RADUSER -c \
    "select count(cont.contract_id) as valid_user
       from radius.contract cont
       join radius.plan on (plan.plan_id = cont.current_plan_id)
       join radius.prepaid_time pptm on (cont.contract_id = pptm.contract_id)
      where plan.plan_type_id = 8
        and plan.service_set_id = 1104
        and cont.first_day is not null
        and not cont.dormant
        and coalesce(pptm.time_remaining,0) > 0"`

##################################################################
# 3) expired users (radius)
##################################################################

EXP=`psql -q -t -h $RADHOST -p $RADPORT -d $RADDATA -U $RADUSER -c \
    "select count(distinct cont.contract_id)
       from radius.contract cont
       join radius.plan using (contract_id)
      where cont.first_day is not null
      --and not cont.dormant
        and plan.plan_type_id = 8
        and plan.service_set_id = 1104
        and cont.first_day - 1 + int4((select sum(length_days) 
                                         from radius.plan 
                                        where contract_id = cont.contract_id)) = '$YESTERDAY'"`

##################################################################
# 4) refilled users (csctoss)
##################################################################

REF=`psql -q -t -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
    "select count(*)
       from csctoss.cc_auth_log ccal
       join csctoss.sprint_assignment sass on (ltrim(ccal.phone_number,'0') = sass.mdn)
      where ccal.transaction_success
        and sass.system = 'ALPHA'
        and ccal.transaction_time at time zone '$TZ'::date = '$YESTERDAY'"`

# blank out password
export PGPASSWORD=""

##################################################################
# 5) sales proceeds of direct charge (csctoss)
#   a) breakdown of sales by each service
##################################################################

echo "DETAILS,,,," > $REFFILE
echo "SER,EVALUATOR NAME,MDN,PRODUCT CODE,PRODUCT PRICE" >> $REFFILE
atllog01
echo "USERNAME,MDN,BILLING ENTITY,OPS USER,SER,EVALUATOR NAME,IN OCTETS,OUT OCTETS,TOTAL OCTETS,TIME CONN (H:M:S)" > $USGFILE
qry=`psql -q -t -h atllog01 -p 5450 -d csctlog -U csctlog_repl -o "$TEMPCSV" << EOF
  select * from csctlog.report_sprint_summary_usage('$YESTERDAY','$TODAY','$TZ','ALPHA') ;
\q`
cat $TEMPCSV >> $USGFILE

##################################################################
# 8) detailed usage all users per day (csctlog)
##################################################################

# call the report_sprint_detail_usage function on atllog01
echo "USERNAME,MDN,BILLING ENTITY,OPS USER,SER,EVALUATOR NAME,IN OCTETS,OUT OCTETS,TOTAL OCTETS,ACCT START,ACCT STOP,TIME CONN (H:M:S),FRAMED IP,NAS IDENTIFIER" > $DETFILE
qry=`psql -q -t -h atllog01 -p 5450 -d csctlog -U csctlog_repl -o "$TEMPCSV" << EOF
  select * from csctlog.report_sprint_detail_usage('$YESTERDAY','$TODAY','$TZ','ALPHA') ;
\q`
cat $TEMPCSV >> $DETFILE

##################################################################
# EMAIL REPORT
##################################################################

echo "New Users            : `echo "$NEW"|tr -s " "`" >> $LOGFILE
echo "Valid Users          : `echo "$ALL"|tr -s " "`" >> $LOGFILE
echo "Expired Users        : `echo "$EXP"|tr -s " "`" >> $LOGFILE
echo "Refill Users         : `echo "$REF"|tr -s " "`" >> $LOGFILE

echo                                                        >> $LOGFILE
echo "---------------------------------------------------"  >> $LOGFILE
echo "$START"                                               >> $LOGFILE
echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"       >> $LOGFILE

# email the report
#mutt -i $LOGFILE -a $REFFILE -a $USGFILE -a $DETFILE -s "SPRINT ALPHA User Statistics Report For: $YESTERDAY" "dba@cctus.com" < /dev/null

for NAME in {"gdeickman@contournetworks.com","jprouty@contournetworks.com","cwalbert@contournetworks.com","nyoda@contournetworks.com","ykudo@j-com.co.jp"}; do
  mutt -i $LOGFILE -a $REFFILE -a $USGFILE -a $DETFILE -s "SPRINT ALPHA User Statistics Report For: $YESTERDAY" $NAME < /dev/null
done

rm -f $TEMPCSV $REFFILE $USGFILE $DETFILE $TMPFILE
exit 0
