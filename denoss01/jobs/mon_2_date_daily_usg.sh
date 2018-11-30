#!/bin/bash
#
#  Daily usage report to show mb used for all lines for the current month only.
#
source /home/postgres/.bash_profile

START="START TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"
USGFILE=/home/postgres/dba/logs/mon_2_date_usage.csv
LOGFILE=/home/postgres/dba/logs/mon_2_date_usage.log
#RECIP="dba@cctus.com,jprouty@contournetworks.com,jobrey@contournetworks.com,bkrewson@cctus.com,jreed@cctus.com"
#RECIP="dolson@cctus.com,jprouty@contournetworks.com,mwinn@contournetworks.com"
#RECIP="dolson@cctus.com,jprouty@contournetworks.com,mzwecker@contournetworks.com,mwinn@contournetworks.com,jlyon@contournetworks.com,gdeickman@cctus.com,jprouty@cctus.com,bkrewson@cctus.com,support@contournetworks.com,yshibuya@cctus.com,csharkey@j-com.co.jp"
RECIP="jprouty@contournetworks.com,mzwecker@contournetworks.com,jlyon@contournetworks.com,gdeickman@cctus.com,jprouty@cctus.com,support@contournetworks.com,yshibuya@cctus.com,csharkey@j-com.co.jp,tstovicek@cctus.com"
#--
MUTT=/usr/bin/mutt

# columns and query
echo "LINE ID,RADIUS USERNAME,BENT NAME,ESN HEX,S/N,Plan NAME,ALLOW(MB),CURR MON USG,PCT USED" > $USGFILE
psql -q -t -A -F "," -h 127.0.0.1 -p 5450 -d csctoss -U slony -c \
" select   line.line_id
          ,line.radius_username
--          ,line.billing_entity_id
          ,substr(replace(bent.name,',',''),1,30) as bent_name
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id
                        and unique_identifier_type = 'ESN HEX'),'NONE') as esn_hex
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id
                        and unique_identifier_type = 'SERIAL NUMBER'),'NONE') 
          ,jbli.plan  
          ,coalesce(jbli.allowmon_kb/1024,0) 
          ,round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2) 
   ,round(100 *  (round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2)/coalesce(jbli.allowmon_kb/1024,0)),0) 
from
         (select id, line_id, serial_number, plan, allowmon_kb, usagemon_kb, usage30_kb
          from public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
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
          ) jbli,
csctoss.line line
join     csctoss.line_equipment lieq on (line.line_id = lieq.line_id and lieq.end_date is null)
join     csctoss.billing_entity bent using (billing_entity_id)
join     csctoss.line_usage_day liud on (line.line_id = liud.line_id)
--left     outer join jbli  on (line.line_id = jbli.line_id)
where    1=1
--         and liud.usage_date >= (current_date - 7)
         and to_char(liud.usage_date,'yyyymm') = (to_char(current_date,'yyyymm'))
         and line.line_id = jbli.line_id
--group by 1,2,3,4,5,6,7
group by 1,2,3,4,5,6,7
order by 9 desc, 4 " >> $USGFILE

# logging
echo "Month to Date Daily Usage Report for: $START"                    > $LOGFILE
echo "---------------------------------------------------"  >> $LOGFILE
echo "$START"                                               >> $LOGFILE

echo "END   TIMESTAMP: `date +%Y%m%d`.`date +%H%M%S`"       >> $LOGFILE
# email the report

${MUTT} -i $LOGFILE -a $USGFILE -s "Month to Date Daily Usage Report for: `date +%Y%m%d`" ${RECIP} < /dev/null

exit 0

