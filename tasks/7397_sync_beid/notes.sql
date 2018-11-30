-- Task #7397 - Notes:


-- ATM Aficionado Sprint range is actually has "CCT-QA" set as the BEID. Could you update all 
-- BEID that are associated to "SERVICE-atmaficionado" in the groupname in the static IP pool 
-- table to have "ATM Aficionado" as the BEID? This should keep us from incurring 
-- provisioning errors in the future.


select b.billing_entity_id
      ,g.groupname
      ,b.name 
  from billing_entity b 
  join groupname_default g on g.billing_entity_id = b.billing_entity_id
 where b.billing_entity_id = 116;
 billing_entity_id |        groupname         |      name      
-------------------+--------------------------+----------------
               116 | SERVICE-atmaficionado    | ATM Aficionado
               116 | SERVICE-vzwwholesale     | ATM Aficionado
               116 | SERVICE-atmaficionado    | ATM Aficionado
               116 | SERVICE-vzwretail_cnione | ATM Aficionado
(4 rows)

select count(*) from (
select * 
  from static_ip_pool 
 where billing_entity_id = 116) as total;
 count 
-------
  2032
(1 row)

select l.line_id
      ,l.billing_entity_id
      ,sip.groupname
  from line l 
  join static_ip_pool sip on sip.line_id = l.line_id
 where l.billing_entity_id = 116;
 line_id | billing_entity_id |        groupname         
---------+-------------------+--------------------------
   46590 |               116 | SERVICE-vzwretail_cnione
   39537 |               116 | SERVICE-vzwretail_cnione
   42225 |               116 | SERVICE-vzwretail_cnione
   39536 |               116 | SERVICE-vzwretail_cnione
   41597 |               116 | SERVICE-vzwretail_cnione
   41599 |               116 | SERVICE-vzwretail_cnione
   41601 |               116 | SERVICE-vzwretail_cnione
   41602 |               116 | SERVICE-vzwretail_cnione
   41603 |               116 | SERVICE-vzwretail_cnione
   41605 |               116 | SERVICE-vzwretail_cnione
.
.
.


select distinct sip.groupname
  from line l 
  join static_ip_pool sip on sip.line_id = l.line_id
 where l.billing_entity_id = 116;
        groupname         
--------------------------
 SERVICE-atmaficionado
 SERVICE-vzwretail_cnione
(2 rows)


select l.line_id
      ,l.billing_entity_id
      ,sip.groupname
      ,sip.carrier_id
  from line l 
  join static_ip_pool sip on sip.line_id = l.line_id
 where l.billing_entity_id = 116
   and sip.carrier_id NOT like '%vzw%';
 line_id | billing_entity_id |        groupname         | carrier_id 
---------+-------------------+--------------------------+------------
   46590 |               116 | SERVICE-vzwretail_cnione |          3
   39537 |               116 | SERVICE-vzwretail_cnione |          3
   42225 |               116 | SERVICE-vzwretail_cnione |          3
   39536 |               116 | SERVICE-vzwretail_cnione |          3
   41597 |               116 | SERVICE-vzwretail_cnione |          3
   41599 |               116 | SERVICE-vzwretail_cnione |          3
.
.
.

select count(*) from (
select l.line_id
      ,l.billing_entity_id
      ,sip.groupname
      ,sip.carrier_id
  from line l                                       
  join static_ip_pool sip on sip.line_id = l.line_id
 where l.billing_entity_id = 116
   and sip.carrier_id NOT like '%vzw%') as total;
 count 
-------
   345
(1 row)


select sip.static_ip
      ,sip.groupname
      ,sip.is_assigned
      ,be.billing_entity_id
      ,be.name
  from static_ip_pool sip
  join billing_entity be on be.billing_entity_id = sip.billing_entity_id
 where sip.static_ip > '10.56.92.0'
   and sip.static_ip < '10.56.94.255';

  static_ip   |       groupname       | billing_entity_id |  name  
--------------+-----------------------+-------------------+--------
 10.56.92.10  | SERVICE-atmaficionado |               703 | CCT-QA
 10.56.92.100 | SERVICE-atmaficionado |               703 | CCT-QA
 10.56.92.101 | SERVICE-atmaficionado |               703 | CCT-QA
 10.56.92.102 | SERVICE-atmaficionado |               703 | CCT-QA
.
.
.
 10.56.92.252 | SERVICE-atmaficionado |               703 | CCT-QA
 10.56.92.253 | SERVICE-atmaficionado |               703 | CCT-QA
 10.56.92.254 | SERVICE-atmaficionado |               703 | CCT-QA
(172 rows)


select sip.static_ip
      ,sip.groupname
      ,be.billing_entity_id 
      ,be.name
  from static_ip_pool sip
  join billing_entity be on be.billing_entity_id = sip.billing_entity_id
 where sip.static_ip > '10.60.92.1'
   and sip.static_ip < '10.60.92.255';

  static_ip   |       groupname       | billing_entity_id |  name  
--------------+-----------------------+-------------------+--------
 10.60.92.10  | SERVICE-atmaficionado |               703 | CCT-QA
 10.60.92.100 | SERVICE-atmaficionado |               703 | CCT-QA
 10.60.92.101 | SERVICE-atmaficionado |               703 | CCT-QA
.
.
.
 10.60.92.251 | SERVICE-atmaficionado |               703 | CCT-QA
 10.60.92.252 | SERVICE-atmaficionado |               703 | CCT-QA
 10.60.92.253 | SERVICE-atmaficionado |               703 | CCT-QA
 10.60.92.254 | SERVICE-atmaficionado |               703 | CCT-QA
(172 rows)


BEGIN;

select public.set_change_log_staff_id(3);

UPDATE static_ip_pool
   SET billing_entity_id = 116
 WHERE static_ip > '10.60.92.0'
   and static_ip < '10.60.94.255';

COMMIT;




UPDATE static_ip_pool
   SET groupname = 'SERVICE-atmaficionado'
 WHERE static_ip > '10.60.92.0'
   and static_ip < '10.60.94.255'
   AND groupname = 'SERVICE-atmconcepts';
