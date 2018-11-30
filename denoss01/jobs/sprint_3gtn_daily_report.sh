# !/bin/bash
# 
# 20110118 : created
#
# 3GTN daily summary report for the following statistics:
#   1) The number of new users per day
#   2) The number of valid service users per day
#   3) The number of expired service users per day
#   4) The number of users who filled Doccica up per day
#
# $Id: $
#

source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/sprint_3gtn_daily_report.out
TMPFILE=$BASEDIR/logs/sprint_3gtn_daily_report.tmp
YESTERDAY=`date --date='yesterday' +%Y-%m-%d`
TODAY=`date +%Y-%m-%d`
START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"

TEMPCSV=$BASEDIR/logs/3GTN_temp.csv
REFFILE=$BASEDIR/logs/3GTN_Refill_$YESTERDAY.csv
USGFILE=$BASEDIR/logs/3GTN_Summary_Usage_$YESTERDAY.csv
DETFILE=$BASEDIR/logs/3GTN_Detail_Usage_$YESTERDAY.csv

# message body header
echo "--------------------------------------------------"  > $LOGFILE
echo "SPRINT 3GTN User Statistics Report For: $YESTERDAY" >> $LOGFILE
echo "--------------------------------------------------" >> $LOGFILE
echo                                                      >> $LOGFILE

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
        and plan.service_set_id = 1188
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
        and plan.service_set_id = 1188
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
        and plan.service_set_id = 1188
        and cont.first_day - 1 + int4((select sum(length_days) 
                                         from radius.plan 
                                        where contract_id = cont.contract_id)) = '$YESTERDAY'"`

##################################################################
# 4) refilled users (csctoss)
##################################################################

REF=`psql -q -t -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
    "select count(*)
       from csctoss.purchase_log plog
       join csctoss.sprint_assignment sass on (plog.mdn = sass.mdn)
      where plog.transaction_result = 'SUCCESS'
        and sass.system = '3GTN'
        and plog.submission_date at time zone '$TZ'::date = '$YESTERDAY'"`

# blank out password
export PGPASSWORD=""

##################################################################
# 5) sales proceeds of direct charge (csctoss)
#   a) breakdown of sales by each service
##################################################################

echo "DETAILS,,,," > $REFFILE
echo "SER,EVALUATOR NAME,MDN,BILLING ENTITY,OPS_USER,PRODUCT CODE,PRODUCT PRICE" >> $REFFILE
qry=`psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -o "$TEMPCSV" << EOF
     select sass.ser
           ,sass.evaluator_name
           ,sass.mdn
           ,(select name from billing_entity where billing_entity_id = 
               (select billing_entity_id 
                  from username 
                 where substr(username,1,10) = sass.mdn
              order by start_date desc
                 limit 1))
           ,plog.sold_by
           ,plog.product_code
           ,prod.sales_price
       from csctoss.purchase_log plog
       join csctoss.sprint_assignment sass on (plog.mdn = sass.mdn)
       join csctoss.product prod using (product_code)
      where plog.transaction_result = 'SUCCESS'
        and sass.system = '3GTN'
        and plog.submission_date at time zone '$TZ'::date = '$YESTERDAY'
   order by sass.ser
           ,plog.product_code ;
\q`

cat $TEMPCSV >> $REFFILE

echo ",,,,,," >> $REFFILE
echo ",,,,,," >> $REFFILE
echo "SUMMARY,,,," >> $REFFILE

echo ",PRODUCT CODE,# REFILLS,PRODUCT PRICE,PRODUCT SALES" >> $REFFILE
qry=`psql -q -t -h 127.0.0.1 -p 5450 -d csctoss -U slony -o "$TEMPCSV" << EOF
     select ','||plog.product_code||','||count(*)||','||prod.sales_price||','||count(*) * prod.sales_price
       from csctoss.purchase_log plog
       join csctoss.sprint_assignment sass on (plog.mdn = sass.mdn)
       join csctoss.product prod using (product_code)
      where plog.transaction_result = 'SUCCESS'
        and sass.system = '3GTN'
        and plog.submission_date at time zone '$TZ'::date = '$YESTERDAY'
   group by plog.product_code
           ,prod.sales_price
   order by plog.product_code ;
\q`

cat $TEMPCSV >> $REFFILE

echo ",,,," >> $REFFILE
echo ",,,," >> $REFFILE

SUM=`psql -q -t -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
    "select sum(prod.sales_price)
       from csctoss.purchase_log plog
       join csctoss.sprint_assignment sass on (plog.mdn = sass.mdn)
       join csctoss.product prod using (product_code)
      where plog.transaction_result = 'SUCCESS'
        and sass.system = '3GTN'
        and plog.submission_date at time zone '$TZ'::date = '$YESTERDAY'"`

echo "TOTAL SALES,,$REF,,$SUM" >> $REFFILE

##################################################################
# 6) connect time of each user per day (csctlog)
##################################################################

# this included in section 7) below

##################################################################
# 7) input / output packets of each user per day (csctlog)
##################################################################

#
# NEW -> pass the TZ and SYSTEM timezone variable to usage function
#

# various updates to sprint_assignment table
qry=`psql -q -t -h 127.0.0.1 -p 5450 -d csctoss -U slony << EOF

update sprint_assignment
set billing_entity_id = username.billing_entity_id
from username
where sprint_assignment.username = username.username ;

update sprint_assignment
set billing_entity_name = billing_entity.name
from billing_entity
where sprint_assignment.billing_entity_id = billing_entity.billing_entity_id ;

update sprint_assignment
set equipment_id = unique_identifier.equipment_id
from unique_identifier 
where sprint_assignment.mdn = unique_identifier.value
and unique_identifier.unique_identifier_type = 'MDN' ;

\q`

# call the report_sprint_summary_usage function on atllog01
echo "USERNAME,MDN,BILLING ENTITY,OPS USER,SER,EVALUATOR NAME,IN OCTETS,OUT OCTETS,TOTAL OCTETS,TIME CONN (H:M:S)" > $USGFILE
qry=`psql -q -t -h atllog01 -p 5450 -d csctlog -U csctlog_repl -o "$TEMPCSV" << EOF
  select * from csctlog.report_sprint_summary_usage('$YESTERDAY','$TODAY','$TZ','3GTN') ;
\q`
cat $TEMPCSV >> $USGFILE

##################################################################
# 8) detailed usage all users per day (csctoss)
##################################################################

# call the report_sprint_detail_usage function on atllog01
echo "USERNAME,MDN,BILLING ENTITY,OPS USER,SER,EVALUATOR NAME,IN OCTETS,OUT OCTETS,TOTAL OCTETS,ACCT START,ACCT STOP,TIME CONN (H:M:S),FRAMED IP,NAS IDENTIFIER" > $DETFILE
qry=`psql -q -t -h atllog01 -p 5450 -d csctlog -U csctlog_repl -o "$TEMPCSV" << EOF
  select * from csctlog.report_sprint_detail_usage('$YESTERDAY','$TODAY','$TZ','3GTN') ;
\q`
cat $TEMPCSV >> $DETFILE

##################################################################
# EMAIL REPORT
##################################################################

echo "New Users            : `echo "$NEW"|tr -s " "`" >> $LOGFILE
echo "Valid Users          : `echo "$ALL"|tr -s " "`" >> $LOGFILE
echo "Expired Users        : `echo "$EXP"|tr -s " "`" >> $LOGFILE
echo "Refill Users         : `echo "$REF"|tr -s " "`" >> $LOGFILE

echo                                                       >> $LOGFILE
echo "--------------------------------------------------"  >> $LOGFILE
echo "$START"                                              >> $LOGFILE
echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"      >> $LOGFILE

# email the report
#mutt -i $LOGFILE -a $REFFILE -a $USGFILE -a $DETFILE -s "SPRINT 3GTN User Statistics Report For: $YESTERDAY" "dba@cctus.com" < /dev/null

for NAME in {"gdeickman@contournetworks.com","jprouty@contournetworks.com","cwalbert@contournetworks.com","nyoda@contournetworks.com","ykudo@j-com.co.jp"}; do
  mutt -i $LOGFILE -a $REFFILE -a $USGFILE -a $DETFILE -s "SPRINT 3GTN User Statistics Report For: $YESTERDAY" $NAME < /dev/null
done

rm -f $TEMPCSV $REFFILE $USGFILE $DETFILE $TMPFILE

exit 0

