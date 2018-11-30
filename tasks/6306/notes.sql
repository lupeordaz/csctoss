
-- billing_entity.name
-- line.line_id
-- serial number
-- ESN HEX
-- line.start_date
-- line.end_date
-- last connection timestamp

-- Active lines with no access for last 6 months

select
  be.name AS billing_entity_name,
  line.line_id AS line_id,
  (select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn,
  (select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn,
  line.start_date,
  line.end_date
from billing_entity be
join line on (be.billing_entity_id = line.billing_entity_id)
join line_equipment le on (line.line_id = le.line_id)
left outer join dblink((select * from fetch_csctlog_conn()),
  'SELECT username
  FROM master_radacct
  WHERE 1 = 1
  AND username ~ ''@uscc.net''
  AND acctstarttime >= (now() - ''6 months''::INTERVAL)
  GROUP BY username
  ') AS mrac (username text)
  ON (line.radius_username = mrac.username)
where 1 = 1
and le.end_date is null
and mrac.username is null
;

--  Outer query

select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN') AS mdn
      ,line.start_date
      ,line.end_date
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
  join line_equipment le on (line.line_id = le.line_id)
 where 1 = 1
   and le.end_date >= (now() - '6 months'::INTERVAL);




select be.name AS billing_entity_name
      ,case
         when gd.carrier ~ 'VZW' 
              then (select value||'@vzw3g.com' from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN')
         when gd.carrier = 'SPRINT' 
              then (select value||'@tsp17.sprintpcs.com' from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN')
         when gd.carrier = 'USCC' 
              then (select value||'@uscc.net' from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN')
       end as old_username
      ,line.line_id AS line_id
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN') AS mdn
      ,line.start_date
      ,line.end_date
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
  join line_equipment le on (line.line_id = le.line_id)
  join groupname_default gd on be.billing_entity_id = gd.billing_entity_id
 where 1 = 1
   and le.end_date >= (now() - '6 months'::INTERVAL);






---


select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn
      ,line.start_date
      ,line.end_date
      ,p.acctstarttime
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
  join line_equipment le on (line.line_id = le.line_id)
  left outer join public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT acctstarttime
          FROM master_radacct 
         WHERE 1 = 1
           AND acctstarttime >= (now() - ''6 months''::INTERVAL) 
         GROUP BY username' as p( acctstarttime text)
        ON (line.radius_username = p.username)
 where 1 = 1
   and le.end_date >= (now() - '6 months'::INTERVAL);


psql -P format=unaligned -P tuples_only -P fieldsep=\, -f last_cancel_access.sql > last_cancel_access.csv

Problem is that when a line is cancelled, the username is cleared; username is how we connect to log files.  


select * from public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT acctstarttime
          FROM master_radacct 
         WHERE 1 = 1
           AND username = '3123884457@uscc.net'
           AND acctstarttime >= (now() - ''6 months''::INTERVAL) 
         GROUP BY username';) as p( acctstarttime text)


select * from public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT acctstarttime
          FROM master_radacct 
         WHERE 1 = 1
           AND username = ''3123884457@uscc.net''
           AND acctstarttime >= (now() - ''6 months''::INTERVAL) 
         GROUP BY username');


---

select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'MDN') AS mdn
      ,line.start_date
      ,line.end_date
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
  join line_equipment le on (line.line_id = le.line_id)
  join groupname_default gd on be.billing_entity_id = gd.billing_entity_id
  left outer join public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT acctstarttime
          FROM master_radacct 
         WHERE 1 = 1
           AND acctstarttime >= (now() - ''6 months''::INTERVAL) 
         GROUP BY username, acctstarttime') as p( username text, acctstarttime text)
        ON (old_username = p.username) where 1 = 1
   and le.end_date >= (now() - '6 months'::INTERVAL);

ERROR:  column "old_username" does not exist
csctoss=# 

---



SELECT
  be.billing_entity_id AS billing_entity_id,
  be.name AS billing_entity_name,
  line.line_id AS line_id,
  line.radius_username AS radius_username,
  line.start_date::date AS line_start_date,
  line.end_date::date AS line_end_date,
  le.equipment_id AS equipment_id,
  le.start_date AS equip_start_date,
  le.end_date AS equip_end_date,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'SERIAL NUMBER') AS sn,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'MDN') AS mdn,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'MIN') AS min,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'ESN HEX') AS esn_hex,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'ESN DEC') AS esn_dec,
  em.model_number1 AS equipment_model,
  em.model_note AS model_note,
  em.vendor AS vendor,
  loc.id AS location_id,
  loc.owner AS location_owner,
  loc.name AS location_name,
  loc.address AS location_address,
  loc.processor AS location_processor,
  ARRAY(SELECT groupname FROM usergroup WHERE username = line.radius_username) AS groupname,
  (SELECT value FROM radreply WHERE username = line.radius_username AND attribute = 'Framed-IP-Address') AS static_ip_address,
  mrad.last_connected_timestamp_for_last30_days_est AS last_connected_timestamp_for_last30_days_est,
  mrad.usage_mb_for_last30_days AS usage_mb_for_last30_days
FROM billing_entity be
JOIN line ON (be.billing_entity_id = line.billing_entity_id)
JOIN line_equipment le ON (line.line_id = le.line_id)
JOIN equipment eq ON (le.equipment_id = eq.equipment_id)
JOIN equipment_model em ON (eq.equipment_model_id = em.equipment_model_id)
LEFT OUTER JOIN location_labels loc ON (loc.line_id = line.line_id)
LEFT OUTER JOIN dblink((SELECT * FROM fetch_csctlog_conn()),
'
SET TimeZone TO EST5EDT;
SELECT
  username,
  MAX(acctstarttime::timestamp(0)) AS last_connected_timestamp_for_last30_days_est,
  TRUNC(SUM(acctinputoctets + acctoutputoctets) / 1024 / 1024, 2) AS usage_mb_for_last30_days
FROM csctlog.master_radacct mrad
WHERE 1 = 1
AND acctstarttime >= (now() - ''30 days''::INTERVAL)
GROUP BY username
') mrad(username text, last_connected_timestamp_for_last30_days_est timestamp with time zone, usage_mb_for_last30_days numeric)
ON (line.radius_username = mrad.username)

WHERE 1 = 1
AND be.billing_entity_id IN (789)
AND line.end_date IS NULL
AND le.end_date IS NULL
ORDER BY be.billing_entity_id, line.line_id, le.equipment_id
;




SET TimeZone TO EST5EDT;
SELECT
  be.name AS billing_entity_name,
  line.line_id AS line_id,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'SERIAL NUMBER') AS sn,
  (SELECT value FROM unique_identifier WHERE le.equipment_id = equipment_id AND unique_identifier_type = 'ESN HEX') AS esn_hex,
  line.start_date::date AS line_start_date,
  line.end_date::date AS line_end_date,
  mrad.last_connected_timestamp_for_last30_days_est AS last_connected_timestamp_for_last30_days_est,
FROM billing_entity be
JOIN line ON (be.billing_entity_id = line.billing_entity_id)
JOIN line_equipment le ON (line.line_id = le.line_id)
LEFT OUTER JOIN dblink((SELECT * FROM fetch_csctlog_conn()),
'
SET TimeZone TO EST5EDT;
SELECT
  username,
  MAX(acctstarttime::timestamp(0)) AS last_connected_timestamp_est,
  TRUNC(SUM(acctinputoctets + acctoutputoctets) / 1024 / 1024, 2) AS usage_mb_for_last30_days
FROM csctlog.master_radacct mrad
WHERE 1 = 1
AND acctstarttime >= (now() - ''6 months''::INTERVAL)
GROUP BY username
') mrad(username text, last_connected_timestamp_est timestamp with time zone, usage_mb_for_last30_days numeric)
ON (line.radius_username = mrad.username)

WHERE 1 = 1
AND line.end_date IS NOT NULL
--AND le.end_date IS NULL
ORDER BY be.billing_entity_id, line.line_id
;


----  Latest

select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER') AS sn
      ,(select value from unique_identifier WHERE equipment_id = le.equipment_id and unique_identifier_type = 'ESN HEX') AS esn
      ,line.start_date
      ,line.end_date
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
  join line_equipment le on (line.line_id = le.line_id)
  JOIN dblink((SELECT * FROM fetch_csctlog_conn()),
       '
       select class
             ,MAX(acctstarttime) AS last_connected_timestamp_est,
         from master_radacct
        group by class
       ') mrad(class text, last_connected_timestamp_est timestamp with time zone) as mrad 
    ON (line.line_id = mrad.class::INTEGER)
 where 1 = 1
   and le.end_date >= (now() - '6 months'::INTERVAL);


select line.line_id
      ,mrad.acctstarttime
  from line
 INNER JOIN (select mrad.class
                   ,mrad.acctstarttime 
               from public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT class
              ,MAX(acctstarttime)
          FROM master_radacct 
         WHERE 1 = 1
           AND class = line.line_id::text;') as mrad(class text, acctstarttime text)) 
    AS mrad
    ON line.line_id = mrad.class;


SELECT a.line_id 
      ,p.acctstarttime
  FROM line a
  INNER JOIN (SELECT p.class, p.acctstarttime FROM public.dblink((select * from csctoss.fetch_csctlog_conn())
                   ,'select p.class
                           ,p.acctstarttime
                       from master_radacct 
                      where 1 = 1
                        and p.class = a.line_id::text') as p( class text, acctstarttime text)) AS p ON a.line_id = p.class
 WHERE 1 = 1
   AND a.line_id = 29422;



select p.master_radacctid, p.acctstarttime from public.dblink((select * from csctoss.fetch_csctlog_conn())
      ,'SELECT master_radacctid, acctstarttime
          FROM master_radacct 
         WHERE 1 = 1
           AND class = ''29422'';') as p(master_radacctid int, acctstarttime text);


select class
      ,MAX(acctstarttime)
  from master_radacct
 where class = '29422'
 group by class;

---

select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,line.start_date
      ,line.end_date
  from billing_entity be
  join line on (be.billing_entity_id = line.billing_entity_id)
 where 1 = 1
   and line.end_date >= (now() - '6 months'::INTERVAL)
 order by 2, 3;


 -- sql file

 select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,line.start_date
      ,line.end_date
      ,(select * from get_last_connection_by_line_id(line.line_id)) as last_connection
  from line
  join billing_entity be on (be.billing_entity_id = line.billing_entity_id)
 where 1 = 1
   and line.end_date >= (now() - '6 months'::INTERVAL);




