

select * from unique_identifier where unique_identifier_type = 'SERIAL NUMBER' and value in ('621449','613912');

 equipment_id | unique_identifier_type | value  | notes | date_created | date_modified 
--------------+------------------------+--------+-------+--------------+---------------
        16343 | SERIAL NUMBER          | 621449 |       | 2011-03-16   | 
        12060 | SERIAL NUMBER          | 613912 |       | 2010-04-27   | 
(2 rows)

-- Retrieve line_id using equipment_id
select le.equipment_id, le.line_id, l.billing_entity_id, l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
 where equipment_id in (16343, 12060);

 equipment_id | line_id | billing_entity_id |   radius_username   
--------------+---------+-------------------+---------------------
        12060 |   10109 |               370 | 3124375332@uscc.net
        16343 |    4002 |               134 | 3124377384@uscc.net
        16343 |   18119 |               333 | 
(3 rows)


select username, attribute, value from radreply where username in ('3124375332@uscc.net','3124377384@uscc.net') 
   and attribute = 'Framed-IP-Address';

      username       |     attribute     |    value     
---------------------+-------------------+--------------
 3124377384@uscc.net | Framed-IP-Address | 10.56.66.220
(1 row)

select name from billing_entity where billing_entity_id in (134,370);

            name            
----------------------------
 Alpha-Omega Solutions, LLC
 Bank Express International
(2 rows)


select billing_entity_id, name from billing_entity where billing_entity_id in (134,370);

 billing_entity_id |            name            
-------------------+----------------------------
               134 | Alpha-Omega Solutions, LLC
               370 | Bank Express International
(2 rows)

csctoss=# select * from unique_identifier where equipment_id = 16343;
 equipment_id | unique_identifier_type |    value    | notes | date_created | date_modified 
--------------+------------------------+-------------+-------+--------------+---------------
        16343 | ESN DEC                | 24601502703 |       | 2010-04-28   | 
        16343 | ESN HEX                | F616EDEF    |       | 2010-04-28   | 
        16343 | MAC ADDRESS            | 0DF079      |       | 2011-03-16   | 
        16343 | MDN                    | 3124377384  |       | 2010-04-28   | 
        16343 | MIN                    | 3124377384  |       | 2010-04-28   | 
        16343 | SERIAL NUMBER          | 621449      |       | 2011-03-16   | 
(6 rows)

csctoss=# 


----


SELECT * FROM csctoss.ops_api_expire('F616EDEF')

SELECT equipment_id -- INTO var_equipment_id
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value = 'F616EDEF';


SELECT line_id -- INTO var_line_id
  FROM line_equipment
  WHERE equipment_id = 16343
  AND end_date IS NULL;

  line_id 
---------
    4002
(1 row)

SELECT radius_username -- INTO var_username 
  FROM line WHERE line_id = 4002; 

   radius_username   
---------------------
 3124377384@uscc.net
(1 row)

SELECT TRUE FROM radreply WHERE username LIKE '3124377384@uscc.net';

SELECT value --INTO var_static_ip
    FROM radreply
    WHERE username = '3124377384@uscc.net'
    AND attribute = 'Framed-IP-Address';

    value     
--------------
 10.56.66.220
(1 row)

SELECT TRUE FROM static_ip_pool WHERE static_ip = '10.56.66.220' AND line_id = 4002;

 bool 
------
 t
(1 row)


UPDATE static_ip_pool SET is_assigned = 'FALSE', line_id = NULL
      WHERE static_ip = '10.56.66.220' AND line_id = 4002;

select * from static_ip_pool WHERE static_ip = '10.56.66.220' AND line_id = 4002;

select * FROM radreply WHERE username = '3124377384@uscc.net';
  id   |      username       |     attribute     | op |    value     | priority 
-------+---------------------+-------------------+----+--------------+----------
 58120 | 3124377384@uscc.net | Class             | =  | 4002         |       10
 58121 | 3124377384@uscc.net | Framed-IP-Address | =  | 10.56.66.220 |       10
(2 rows)

csctoss=# 


SELECT TRUE FROM usergroup WHERE username LIKE '3124377384@uscc.net' AND groupname LIKE 'disconnected' AND priority = 1;
 bool 
------
(0 rows)

csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

csctoss=# INSERT INTO usergroup(username, groupname, priority)
csctoss-#         VALUES ('3124377384@uscc.net', 'disconnected', 1);
ERROR:  duplicate key violates unique constraint "usergroup_username_priority_uk"
csctoss=# rollback;
ROLLBACK
csctoss=#  

---- Logs after fix of ops_api_expire

2018-03-13 10:24:21 MDT 192.168.144.244(43968) postgres 22191 0LOG:  duration: 2.866 ms
2018-03-13 10:24:21 MDT 192.168.144.244(43968) postgres 22191 3697258LOG:  statement: SELECT * FROM usergroup WHERE username = '3124377384@uscc.net'
2018-03-13 10:24:21 MDT 192.168.144.244(43968) postgres 22191 0LOG:  duration: 0.337 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697259LOG:  statement: RESET ALL;
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 0LOG:  duration: 0.815 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697260LOG:  statement: SET datestyle='ISO'
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 0LOG:  duration: 0.309 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697261LOG:  statement: select version()
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 0LOG:  duration: 0.319 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697262LOG:  statement: select oid,typname from pg_type
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 0LOG:  duration: 1.863 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697263LOG:  statement: SET DATESTYLE TO ISO
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 0LOG:  duration: 0.091 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264LOG:  statement: begin 
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264LOG:  duration: 0.061 ms
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264LOG:  statement: SELECT * FROM csctoss.ops_api_expire('F616EDEF')
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264LOG:  statement: SELECT  * from ops_api_expire( $1 , true)
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264CONTEXT:  SQL statement "SELECT  * from ops_api_expire( $1 , true)"
  PL/pgSQL function "ops_api_expire" line 4 at select into variables



2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264CONTEXT:  SQL statement "SELECT  true"
  PL/pgSQL function "ops_api_expire" line 117 at assignment
  SQL statement "SELECT  * from ops_api_expire( $1 , true)"
  PL/pgSQL function "ops_api_expire" line 4 at select into variables
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264LOG:  statement: SELECT  'Line associated to the equipment is now expired'
2018-03-13 10:24:42 MDT 192.168.144.244(44034) postgres 22739 3697264CONTEXT:  SQL statement "SELECT  'Line associated to the equipment is now expired'"
  PL/pgSQL function "ops_api_expire" line 118 at assignment
  SQL statement "SELECT  * from ops_api_expire( $1 , true)"
  PL/pgSQL function "ops_api_expire" line 4 at select into variables


csctoss=#  select * from usergroup where username = '3124377384@uscc.net';
   id   |      username       |     groupname      | priority 
--------+---------------------+--------------------+----------
 107203 | 3124377384@uscc.net | userdisconnected   |        1
  51872 | 3124377384@uscc.net | SERVICE-alphaomega |    50000
(2 rows)

csctoss=# 


----

select * from unique_identifier where unique_identifier_type = 'SERIAL NUMBER' and value = '932337';

 equipment_id | unique_identifier_type | value  | notes | date_created | date_modified 
--------------+------------------------+--------+-------+--------------+---------------
        40970 | SERIAL NUMBER          | 932337 |       | 2015-10-23   | 
(1 row)

select le.equipment_id, le.line_id, l.billing_entity_id, l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
 where equipment_id = 40970;

 equipment_id | line_id | billing_entity_id |   radius_username    
--------------+---------+-------------------+----------------------
        40970 |   43041 |               577 | 4705530526@vzw3g.com
(1 row)

select username, attribute, value 
  from radreply 
 where username in (
'5774959816@tsp18.sprintpcs.com',
'4048592983@vzw3g.com',
'4049853228@vzw3g.com') 
   and attribute = 'Framed-IP-Address';


----

select * 
  from unique_identifier 
 where unique_identifier_type = 'SERIAL NUMBER' 
   and value in (
'675541',
'745038',
'890875',
'706015');

 equipment_id | unique_identifier_type | value  | notes | date_created | date_modified 
--------------+------------------------+--------+-------+--------------+---------------
        22877 | SERIAL NUMBER          | 675541 |       | 2011-04-28   | 
        39974 | SERIAL NUMBER          | 890875 |       | 2014-10-16   | 
        41654 | SERIAL NUMBER          | 706015 |       | 2016-07-01   | 
(3 rows)

-- Retrieve line_id using equipment_id
select le.equipment_id, le.line_id, l.billing_entity_id, l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
 where equipment_id in (22877, 39974, 41654);
 equipment_id | line_id | billing_entity_id |        radius_username         
--------------+---------+-------------------+--------------------------------
        22877 |   44397 |               577 | 5774959816@tsp18.sprintpcs.com
        41654 |   13629 |               293 | 4048592983@vzw3g.com
        22877 |   33352 |               577 | 
        39974 |   40460 |               577 | 4049853228@vzw3g.com
(4 rows)

select username, attribute, value 
  from radreply 
 where username in (
'5774959816@tsp18.sprintpcs.com',
'4048592983@vzw3g.com',
'4049853228@vzw3g.com') 
   and attribute = 'Framed-IP-Address';

----


select le.equipment_id                                     
      ,ui.value as SN
      ,le.line_id
      ,l.billing_entity_id
      ,l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier ui on (ui.equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER')
 where l.radius_username like '%prin%'
   and l.billing_entity_id = 577;

 equipment_id |     sn     | line_id | billing_entity_id |        radius_username         
--------------+------------+---------+-------------------+--------------------------------
        32984 | 760426     |   33208 |               577 | 5662081334@tsp17.sprintpcs.com
        34851 | 867844     |   33208 |               577 | 5662081334@tsp17.sprintpcs.com
        34958 | 777096     |   33208 |               577 | 5662081334@tsp17.sprintpcs.com
        29286 | 690831     |   32661 |               577 | 5662121590@tsp17.sprintpcs.com
        32597 | 730981     |   32661 |               577 | 5662121590@tsp17.sprintpcs.com
        35876 | 788559     |   38537 |               577 | 5662121536@tsp18.sprintpcs.com
        37283 | 866391     |   38537 |               577 | 5662121536@tsp18.sprintpcs.com
        40901 | 912377     |   42617 |               577 | 5002625238@tsp17.sprintpcs.com
        39138 | 879737     |   42226 |               577 | 5662070049@tsp17.sprintpcs.com
        40037 | 777305     |   42067 |               577 | 5775067315@tsp17.sprintpcs.com
.
.
.

SN 788559

select * from unique_identifier where unique_identifier_type = 'ESN HEX' and value = 'A10000157EBC0D';
 equipment_id | unique_identifier_type |     value      | notes | date_created | date_modified 
--------------+------------------------+----------------+-------+--------------+---------------
        35876 | ESN HEX                | A10000157EBC0D |       | 2013-08-16   | 
(1 row)

select * from unique_identifier where equipment_id = 35876;
 equipment_id | unique_identifier_type |       value        | notes | date_created | date_modified 
--------------+------------------------+--------------------+-------+--------------+---------------
        35876 | ESN DEC                | 270113179708305677 |       | 2013-08-16   | 
        35876 | ESN HEX                | A10000157EBC0D     |       | 2013-08-16   | 
        35876 | MAC ADDRESS            | 10A8E7             |       | 2013-08-16   | 
        35876 | MDN                    | 5662121536         |       | 2013-08-16   | 
        35876 | MIN                    | 000004232020373    |       | 2013-08-16   | 
        35876 | SERIAL NUMBER          | 788559             |       | 2013-08-16   | 
(6 rows)


select le.equipment_id, le.line_id, l.billing_entity_id, l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
 where equipment_id = 41020;
 equipment_id | line_id | billing_entity_id |   radius_username    
--------------+---------+-------------------+----------------------
        41020 |   43014 |               577 | 4705530522@vzw3g.com
(1 row)

2018-03-13 11:18:12 MDT 192.168.144.244(44020) postgres 22610 3697489LOG:  statement: SELECT * FROM ops_api_user_suspend('A10000157EBC0D','5662121536@tsp18.sprintpcs.com')
2018-03-13 11:18:12 MDT 192.168.144.244(44020) postgres 22610 3697489LOG:  statement: SELECT   $1 
2018-03-13 11:18:12 MDT 192.168.144.244(44020) postgres 22610 3697489CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_user_suspend" line 13 at block variables initialization

2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 0LOG:  duration: 4.088 ms
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 3697502LOG:  statement: SELECT * FROM usergroup WHERE username = '4704214130@vzw3g.com'
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 0LOG:  duration: 0.442 ms
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 3697503LOG:  statement: SELECT


2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 3697520LOG:  statement: SELECT * FROM usergroup WHERE username = '4049895393@vzw3g.com'
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 0LOG:  duration: 0.359 ms
2018-03-13 11:24:26 MDT [local] csctoss_owner 24523 3697521LOG:  statement: select * from unique_identifier where equipment_id = 41020;
2018-03-13 11:24:26 MDT [local] csctoss_owner 24523 0LOG:  duration: 1.065 ms
2018-03-13 11:25:25 MDT [local] csctoss_owner 24523 3697522LOG:  statement: select * from unique_identifier where unique_identifier_type = 'ESN HEX' and value = 'A10000157EBC0D';
2018-03-13 11:25:25 MDT [local] csctoss_owner 24523 0LOG:  duration: 0.789 ms
2018-03-13 11:25:43 MDT [local] csctoss_owner 24523 3697523LOG:  statement: select * from unique_identifier where equipment_id = 35876;
2018-03-13 11:25:43 MDT [local] csctoss_owner 24523 0LOG:  duration: 0.534 ms
2018-03-13 11:26:26 MDT 192.168.144.244(44050) postgres 24524 3697524LOG:  statement: RESET ALL;








2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 0LOG:  duration: 3.304 ms
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 3697520LOG:  statement: SELECT * FROM usergroup WHERE username = '4049895393@vzw3g.com'
2018-03-13 11:18:16 MDT 192.168.144.244(44020) postgres 22610 0LOG:  duration: 0.359 ms


----  Test ops_api_expire_ex()
-- uscc

select le.equipment_id
      ,ui.value as SN
      ,le.line_id
      ,l.billing_entity_id
      ,l.radius_username
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier ui on (ui.equipment_id = le.equipment_id and unique_identifier_type = 'SERIAL NUMBER')
 where l.radius_username like '%uscc%'
   and l.billing_entity_id = 577;


---- VZW data

 equipment_id |     sn     |       esn        | line_id | billing_entity_id |   radius_username    
--------------+------------+------------------+---------+-------------------+----------------------
        40986 | 936731     | A1000043873425   |   43051 |               577 | 4705530550@vzw3g.com


select * from ops_api_suspend_ex('A1000043873425');
-[ RECORD 1 ]-+-----------
result_code   | t
error_message | Succeeded.

select * from ops_api_expire_ex('A1000043873425',true);
-[ RECORD 1 ]-+------------------------------------------------
result_code   | t
error_message | Line associated to the equipment is now expired


--- sprint data

 equipment_id |     sn     |      esn       | line_id | billing_entity_id |        radius_username         
--------------+------------+----------------+---------+-------------------+--------------------------------
        40901 | 912377     | A100001578C8CB |   42617 |               577 | 5002625238@tsp17.sprintpcs.com

select * from ops_api_suspend_ex('A100001578C8CB');
-[ RECORD 1 ]-+-----------
result_code   | t
error_message | Succeeded.

select * from ops_api_expire_ex('A100001578C8CB',true);
-[ RECORD 1 ]-+------------------------------------------------
result_code   | t
error_message | Line associated to the equipment is now expired


--- uscc data

 equipment_id |   sn   |   esn    | line_id | billing_entity_id |   radius_username   
--------------+--------+----------+---------+-------------------+---------------------
        19575 | 607422 | F616F915 |   32144 |               577 | 3126711186@uscc.net

select * from ops_api_suspend_ex('F616F915');
-[ RECORD 1 ]-+-----------
result_code   | t
error_message | Succeeded.

select * from ops_api_expire_ex('F616F915',true);
-[ RECORD 1 ]-+------------------------------------------------
result_code   | t
error_message | Line associated to the equipment is now expired

