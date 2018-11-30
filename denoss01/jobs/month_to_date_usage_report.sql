
select   line.line_id
          ,line.radius_username
--          ,line.billing_entity_id
          ,substr(replace(bent.name,',',''),1,30) as bent_name
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id
                        and unique_identifier_type = 'ESN HEX'),'NONE') as esn_hex
          ,coalesce((select value from unique_identifier where equipment_id = lieq.equipment_id
                        and unique_identifier_type = 'SERIAL NUMBER'),'NONE') as "S/N"
          ,jbli.plan  as "Plan"
          ,coalesce(jbli.allowmon_kb/1024,0) as "Allow(MB)" -- mb_mon_allow
          ,round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2) as "Cur Mon Usg"  --mb_mon_to_date_usage
   ,round(100 *  (round(((sum(liud.acctinputoctets_utc) + sum(acctoutputoctets_utc))/1048576),2)/coalesce(jbli.allowmon_kb/1024,0)),0) as "% used"
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
order by 9  desc
;

