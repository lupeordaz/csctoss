#!/bin/bash
#
set -x
# Simple weekly report to show mb used for all lines by week.
#
source /home/postgres/.bash_profile

START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"
USGFILE=/home/postgres/dba/logs/mb_usage_weekly.csv
LOGFILE=/home/postgres/dba/logs/mb_usage_weekly.log

# drop jbilling table, recreate, add index
#qry=`psql -U slony << EOF
psql -U slony -q  -c " 
CREATE TABLE csctoss.jb_line_info AS
SELECT id, line_id, serial_number, plan, allowmon_kb, usagemon_kb, usage30_kb
  FROM public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
                     'select summ.id
                            ,summ.line_id
                            ,summ.serial_number
                            ,summ.plan
                            ,usag.allowmon_kb
                            ,usag.usagemon_kb
                            ,usag.usage30_kb
                        from portal.line_summary summ
                        join portal.usage_summary usag using (id)')
    as rec_type(id             integer
               ,line_id        integer
               ,serial_number  varchar
               ,plan           varchar
               ,allowmon_kb    integer
               ,usagemon_kb    integer
               ,usage30_kb     integer)
ORDER BY line_id;

CREATE INDEX jb_line_info_line_id_idx ON csctoss.jb_line_info (line_id);
"

# columns and query
echo "LINE ID,RADIUS USERNAME,BENT ID,BENT NAME,ESN HEX,SERIAL NUMBER,MB MON ALLOW,MB CURR MON,MB LAST 7 DAYS" > $USGFILE
psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
 "SELECT   line.line_id
          ,line.radius_username
          ,line.billing_entity_id
          ,replace(bent.name,',','') as bent_name
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id 
                        and unique_identifier_type = 'ESN HEX'),'NONE') as esn_hex
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id 
                        and unique_identifier_type = 'SERIAL NUMBER'),'NONE') as serial_number
          ,coalesce(jbli.allowmon_kb/1024,0) as mb_mon_allow
          ,(select coalesce(round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2),0)
              from csctoss.line_usage_day
             where line_id = line.line_id
               and usage_date >= date_trunc('month',current_date)) as mb_curr_month
          ,round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2) as mb_last_7_days
FROM     csctoss.line
JOIN     csctoss.line_equipment lieq on (line.line_id = lieq.line_id and lieq.end_date is null)
JOIN     csctoss.billing_entity bent using (billing_entity_id)
JOIN     csctoss.line_usage_day liud on (line.line_id = liud.line_id)
LEFT     OUTER JOIN csctoss.jb_line_info jbli on (line.line_id = jbli.line_id)
WHERE    liud.usage_date >= (current_date - 7)
GROUP BY 1,2,3,4,5,6,7
ORDER BY 8 DESC
        ,4" >> $USGFILE

# drop the temp table
psql -q -t -U slony -c "DROP TABLE csctoss.jb_line_info" < /dev/null

# logging
echo "MB Usage Weekly Report for: $START"                    > $LOGFILE
echo "---------------------------------------------------"  >> $LOGFILE
echo "$START"                                               >> $LOGFILE
echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"       >> $LOGFILE

# email the report
# mutt -i $LOGFILE -a $USGFILE -s "MB Usage Weekly Report for: `date +%Y%m%d`" dba@cctus.com < /dev/null

#for NAME in {"dba@cctus.com","jprouty@contournetworks.com","jobrey@contournetworks.com","bkrewson@cctus.com","support@contournetworks.com"}; do
#  mutt -i $LOGFILE -a $USGFILE -s "MB Usage Weekly Report for: `date +%Y%m%d`" $NAME < /dev/null
#done
/usr/bin/mutt -i $LOGFILE -a $USGFILE -s "MB Usage Weekly Report for: `date +%Y%m%d`" dba@cctus.com < /dev/null

exit 0

