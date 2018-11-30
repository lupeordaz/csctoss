#!/bin/bash
#
# Month end usage report for USCC.
#
source /home/postgres/.bash_profile

START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"

USGFILE=/home/postgres/dba/logs/.csv
LOGFILE=/home/postgres/dba/logs/mb_usage_weekly.log

# columns and query
echo "LINE ID,RADIUS USERNAME,BENT ID,BENT NAME,ESN HEX,SERIAL NUMBER,MB LAST WEEK" > $USGFILE
psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
 "select   line.line_id
          ,line.radius_username
          ,line.billing_entity_id
          ,replace(bent.name,',','') as bent_name
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id 
                        and unique_identifier_type = 'ESN HEX'),'NONE') as esn_hex
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id 
                        and unique_identifier_type = 'SERIAL NUMBER'),'NONE') as serial_number
          ,round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2) as mb_last_week
from     csctoss.line
join     csctoss.line_equipment lieq on (line.line_id = lieq.line_id and lieq.end_date is null)
join     csctoss.billing_entity bent using (billing_entity_id)
join     csctoss.line_usage_day liud on (line.line_id = liud.line_id)
where    liud.usage_date >= (current_date - 7)
group by 1,2,3,4,5,6
order by 7 desc
        ,4" >> $USGFILE

# logging
echo "MB Usage Weekly Report for: $START"                    > $LOGFILE
echo "---------------------------------------------------"  >> $LOGFILE
echo "$START"                                               >> $LOGFILE
echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"       >> $LOGFILE

# email the report
# mutt -i $LOGFILE -a $USGFILE -s "MB Usage Weekly Report for: `date +%Y%m%d`" dba@cctus.com < /dev/null

for NAME in {"dba@cctus.com","jprouty@contournetworks.com","jobrey@contournetworks.com"}; do
  mutt -i $LOGFILE -a $USGFILE -s "MB Usage Weekly Report for: `date +%Y%m%d`" $NAME < /dev/null
done

exit 0

