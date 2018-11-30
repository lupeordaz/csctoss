#!/bin/bash -xv
#
# Usage overage report.
#
source /home/postgres/.bash_profile

START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"
USGFILE=/home/postgres/dba/logs/usage_overage_report.csv
OUTFILE=/home/postgres/dba/logs/usage_overage_report.out
LOGFILE=/home/postgres/dba/logs/usage_overage_report.log

# Calculate usage overage.
psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
  "SELECT * FROM usage_overage_detection(24, NULL)" > $OUTFILE

# columns and query
echo "line_id,billing_entity_name,username,product_code,alert_threshold_mb,acct_total_volume_mb,time_connected_utc,acctsessiontime_utc,acctinputoctets_utc,acctoutputoctets_utc,rowcount_utc" > $USGFILE
psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
  "SELECT line_id,
          billing_entity_name,
          username,
          product_code,
          alert_threshold_mb,
          time_connected_utc,
          acctsessiontime_utc,
          acctinputoctets_utc,
          acctoutputoctets_utc,
          rowcount_utc
   FROM line_usage_overage_calc
   WHERE usage_calc_end_timestamp = (SELECT MAX(usage_calc_end_timestamp) FROM line_usage_overage_calc)
   ORDER BY line_id" >> $USGFILE

# logging
echo "Usage Overage Report for: $START"                     > $LOGFILE
echo "---------------------------------------------------"  >> $LOGFILE
echo "$START"                                               >> $LOGFILE
echo ""                                                     >> $LOGFILE
cat $OUTFILE                                                >> $LOGFILE
echo ""                                                     >> $LOGFILE
echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"       >> $LOGFILE

# email the report
#mutt -s "Usage Overage Report for: `date +%Y%m%d`" yshibuya@j-com.co.jp -i $LOGFILE -a $USGFILE < /dev/null

#for NAME in {"mwinn@contournetworks.com","jlyon@contournetworks.com","ktaylor@cctus.com","jprouty@cctus.com","nyoda@cctus.com","yshibuya@cctus.com","csharkey@j-com.co.jp"}; do
#for NAME in {"jlyon@contournetworks.com","ktaylor@cctus.com","jprouty@cctus.com","nyoda@cctus.com","yshibuya@cctus.com","csharkey@j-com.co.jp","tstovicek@cctus.com"}; do
for NAME in {"jlyon@contournetworks.com","ktaylor@cctus.com","jprouty@cctus.com","yshibuya@cctus.com","csharkey@j-com.co.jp","tstovicek@cctus.com"}; do
  mutt -s "Usage Overage Report for: `date +%Y%m%d`" $NAME -i $LOGFILE -a $USGFILE < /dev/null
done

exit 0
