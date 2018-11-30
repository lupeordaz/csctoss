Static Pool table shows line is active but no entry in Radreply.


select a.static_ip as sip_static_ip
      ,a.groupname
      ,c.carrier
      ,b.line_id as line_line_id
      ,d.name as Billilng_Entity_Name
  from static_ip_pool a
  left outer join line b ON (a.line_id = b.line_id)
  join static_ip_carrier_def c ON a.carrier_id = c.carrier_def_id
  left outer join billing_entity d ON a.billing_entity_id = d.billing_entity_id
 where a.is_assigned = TRUE
   and a.line_id = b.line_id
   and a.static_ip NOT IN (select value from radreply);

 sip_static_ip |        groupname         | carrier | line_line_id | billilng_entity_name 
---------------+--------------------------+---------+--------------+----------------------
 10.81.144.152 | SERVICE-vzwretail_cnione | VZW     |        46631 | Contour Demo
(1 row)


select * from static_ip_pool where static_ip = '10.81.144.152';
   id   |   static_ip   |        groupname         | is_assigned | line_id | carrier_id | billing_entity_id 
--------+---------------+--------------------------+-------------+---------+------------+-------------------
 297173 | 10.81.144.152 | SERVICE-vzwretail_cnione | t           |   46631 |          3 |               112
(1 row)

select * from radreply where value = '46631';
  id   |               username               | attribute | op | value | priority 
-------+--------------------------------------+-----------+----+-------+----------
 81630 | 882393256289292@m2m01.contournet.net | Class     | =  | 46631 |       10
(1 row)

select * from radreply where username = '882393256289292@m2m01.contournet.net';
  id   |               username               |     attribute     | op |    value    | priority 
-------+--------------------------------------+-------------------+----+-------------+----------
 81630 | 882393256289292@m2m01.contournet.net | Class             | =  | 46631       |       10
 81631 | 882393256289292@m2m01.contournet.net | Framed-IP-Address | =  | 10.68.8.252 |       10
(2 rows)

select * from static_ip_pool where static_ip in ( '10.68.8.252', '10.81.144.152');
   id   |   static_ip   |        groupname         | is_assigned | line_id | carrier_id | billing_entity_id 
--------+---------------+--------------------------+-------------+---------+------------+-------------------
 297175 | 10.68.8.252   | SERVICE-vodafone         | t           |   46631 |          8 |               112
 297173 | 10.81.144.152 | SERVICE-vzwretail_cnione | t           |   46631 |          3 |               112
(2 rows)

select * from billing_entity where billing_entity_id = 112;
 billing_entity_id | parent_billing_entity_id |     name     | phone_number1 | phone_number2 | fax_number1 | fax_number2 | url | preferred_timezone | billing_entity_type | opt_in_flag 
-------------------+--------------------------+--------------+---------------+---------------+-------------+-------------+-----+--------------------+---------------------+-------------
               112 |                        1 | Contour Demo | 404-347-8350  |               |             |             |     | EDT                | INTERNAL            | f
(1 row)

select a.billing_entity_id
      ,a.parent_billing_entity_id
      ,a.name
      ,b.groupname
      ,a.phone_number1
      ,a.billing_entity_type
      ,a.opt_in_flag 
  from billing_entity a
  left outer join groupname_default b on a.billing_entity_id = b.billing_entity_id
 where a.billing_entity_id = 112;

  billing_entity_id | parent_billing_entity_id |     name     | groupname | phone_number1 | billing_entity_type | opt_in_flag 
-------------------+--------------------------+--------------+-----------+---------------+---------------------+-------------
               112 |                        1 | Contour Demo |           | 404-347-8350  | INTERNAL            | f
(1 row)


--

Corrected via 