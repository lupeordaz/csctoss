--Notes

select * 
  from radreply 
 where attribute = 'Class' 
   and value = '44361';
  id   |       username       | attribute | op | value | priority 
-------+----------------------+-----------+----+-------+----------
 77327 | 3472630942@vzw3g.com | Class     | =  | 44361 |       10
(1 row)


select billing_entity_id
      ,radius_username 
  from line 
 where line_id = 44361;
 billing_entity_id |   radius_username    
-------------------+----------------------
               577 | 3472630942@vzw3g.com
(1 row)


select username, billing_entity_id 
  from username 
 where username = '3472630942@vzw3g.com';
       username       | billing_entity_id 
----------------------+-------------------
 3472630942@vzw3g.com |               577
(1 row)

select line_id, billing_entity_id
      ,radius_username 
  from line 
 where line_id = 44361;
 line_id | billing_entity_id |   radius_username    
---------+-------------------+----------------------
   44361 |               577 | 3472630942@vzw3g.com


select username
      ,billing_entity_id 
  from username 
 where username = '3472630942@vzw3g.com';
       username       | billing_entity_id 
----------------------+-------------------
 3472630942@vzw3g.com |               577



select l.line_id
      ,em.carrier
      ,l.billing_entity_id as line_billilng_entity
      ,sip.billing_entity_id as sip_billing_entity_id
  from line l
  join line_equipment le on le.line_id = l.line_id
  join equipment e on e.equipment_id = le.equipment_id
  join equipment_model em on em.equipment_model_id = e.equipment_model_id
  join static_ip_pool sip on sip.line_id = l.line_id
 where l.end_date is null
   and l.billing_entity_id <> sip.billing_entity_id
 order by 1;


select l.line_id
      ,l.billing_entity_id as line_billilng_entity
      ,u.billing_entity_id as user_billing_entity_id
  from line l
  join username u on u.username = l.radius_username
 where l.end_date is null
   and l.billing_entity_id <> u.billing_entity_id
 order by 1;


 line_id | line_billilng_entity | user_billing_entity_id 
---------+----------------------+------------------------
      86 |                   11 |                      1
    1553 |                   47 |                      1
    2683 |                  101 |                      1
    3391 |                   65 |                      1
    3436 |                  135 |                      1
    3454 |                  116 |                      1
    3763 |                   65 |                      1
    3783 |                   99 |                      1
    4056 |                   99 |                      1
    4177 |                   69 |                      1
    4549 |                  101 |                      1
    4787 |                  101 |                      1
    4801 |                  101 |                      1
    4928 |                   65 |                      1
.
.
.
   40109 |                  717 |                    340
   40110 |                  717 |                    340
   40111 |                  717 |                    340
   40366 |                  416 |                    473
   40982 |                   47 |                     42
   42324 |                  749 |                    221
   42332 |                  749 |                    221
   42346 |                  748 |                    112
   42399 |                  748 |                    112
   43071 |                  755 |                      1
   43510 |                  760 |                    460
   43627 |                  239 |                      2
(556 rows)


update username
   set billing_entity_id = 






SELECT mr.master_radacctid
      ,mr.source_hostname
.
.
.
      ,mr.acctstarttime
      ,mr.acctstoptime
.
.
.
  FROM master_radacct mr
 INNER JOIN
      (select username, max(acctstarttime) as acctstarttime
         from master_radacct
        group by username
        order by username) mr2        on mr.username = mr2.username
   and mr.acctstarttime = mr2.acctstarttime ;" > ${TMPFILE}





