-- Using type ops_api_retval for all specified functions 
-- (this type is already in place for ops_api_activate and ops_api_assign)

--
-- Name: ops_api_retval; Type: TYPE; Schema: csctoss; Owner: csctoss_owner
--

CREATE TYPE ops_api_retval AS (
	result_code boolean,
	error_message text
);

ALTER TYPE ops_api_retval OWNER TO csctoss_owner;

-- Test data

 line_id | equipment_id |           radius_username            |         mac          |       serialno       |       esn_hex        
---------+--------------+--------------------------------------+----------------------+----------------------+----------------------
   44009 |         2379 | 3123883702@uscc.net                  | 0080440D8DC8         | 639831               | F611C1DC
   46838 |         2395 | 3123883728@uscc.net                  | 0D8DC5               | 639828               | F611C214
   12671 |         3263 | 3128543376@uscc.net                  | 02018E               | 02018E               | F6148728
    3274 |         3324 | 3122178382@uscc.net                  | 0DA73A               | 640347               | F614B78E

*   2588 |         3326 | 3122178402@uscc.net                  | 0DA525               | 640357               | F614B79F

    3447 |         3328 | 3128540874@uscc.net                  | 0DA6FB               | 640355               | F614B7A0

-   2657 |         3333 | 3122178520@uscc.net                  | 0DA523               | 640403               | F614B806

    2656 |         3335 | 3122178556@uscc.net                  | 0DA593               | 640396               | F614B7D7
    3337 |         3336 | 3122178559@uscc.net                  | 0DA62A               | 640412               | F614B7DB
    3314 |         3338 | 3122178570@uscc.net                  | 0DA51D               | 640388               | F614B7DD
   40916 |         3341 | 3122178624@uscc.net                  | 0DA4ED               | 642464               | F614B7CF
    2654 |         3342 | 3122178633@uscc.net                  | 0DA4F4               | 640318               | F614B7DC

--
-- Testing ops_api_expire using an existing 
begin;
BEGIN

select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

select * from ops_api_expire('F614B79F');
ERROR:  syntax error at or near "$1"
LINE 1: SELECT  'Unknown error!'  $1  := false
                                  ^
QUERY:  SELECT  'Unknown error!'  $1  := false
CONTEXT:  PL/pgSQL function "ops_api_expire" line 146 at assignment
SQL statement "SELECT  * from ops_api_expire( $1 , true)"
PL/pgSQL function "ops_api_expire" line 4 at select into variables
csctoss=# rollback;
ROLLBACK


--  Problem is that an undetected error was found in the code.  There was no
--  check if a 'Framed-IP-Address' record exists in radreply table.  Once the
--  error check was done, the function ran correctly in that it threw a valid
--  error message.

csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_expire('F614B79F');
 result_code |                            error_message                             
-------------+----------------------------------------------------------------------
 f           | ERROR:  Framed-IP-Address does not exist in RADREPLY for this device
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 2
begin;
BEGIN

select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

select * from ops_api_expire('F614B806');
 result_code |                  error_message                  
-------------+-------------------------------------------------
 t           | Line associated to the equipment is now expired
(1 row)

rollback;
ROLLBACK

--
-- Testing ops_api_modify()

-- Test 1
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_modify('ESN HEX','352613070386846','352613070190859');
INFO:  ERROR:  ERROR - Update failed for unique_identifier 352613070190859
 result_code |                        error_message                        
-------------+-------------------------------------------------------------
 f           | ERROR - Update failed for unique_identifier 352613070190859
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 2
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_modify('ESN HEX','352613070283910','352613070190859');
 result_code |                   error_message                    
-------------+----------------------------------------------------
 f           | ERROR - Old value does not exist:  352613070283910
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 3 - replace MDN already exists
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_modify('MDN','4708290319','4708291866');
NOTICE:  OTHER EXCEPTION:  ERROR - MDN update failed, old value 4708290319, new value 4708291866
 result_code |                             error_message                             
-------------+-----------------------------------------------------------------------
 f           | ERROR - MDN update failed, old value 4708290319, new value 4708291866
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 4 - No errors
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

csctoss=# select * from ops_api_modify('MDN','4708290319','4705320904');
 result_code | error_message 
-------------+---------------
 t           | 
(1 row)

csctoss=# rollback;
ROLLBACK
csctoss=#


-- Testing ops_api_suspend()

-- Test 1:  Run using a blank esn hex
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_suspend('');
 result_code |                    error_message                     
-------------+------------------------------------------------------
 f           | ERROR:  Input ESN HEX Is Null. Please enter a value.
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 2:  Run using a non active esn hex
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_suspend('352613070283910');
 result_code |                     error_message                      
-------------+--------------------------------------------------------
 f           | ERROR:  ESN HEX value does not exist - 352613070283910
(1 row)

csctoss=# rollback;
ROLLBACK

-- Test 3:  Run with an active esn hex that has an active line
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# select * from ops_api_suspend('352613070386846');
 result_code | error_message 
-------------+---------------
 t           | 
(1 row)

csctoss=# rollback;
ROLLBACK


-- Testing ops_api_suspend()

-- test data
 line_id | equipment_id |   radius_username    |         mac          |       serialno       |       esn_hex        
---------+--------------+----------------------+----------------------+----------------------+----------------------
   10343 |        38531 | 4046158483@vzw3g.com | 0080440E07AE         | 613865               | F6116C8B
   11237 |        38533 | 4046158482@vzw3g.com | 0080440E35EE         | 615954               | F6116C87
   13629 |        38527 | 4048592983@vzw3g.com | 0080440DF1E5         | 621572               | F612DC81
   16476 |        36833 | 4045766433@vzw3g.com | 0080440E177C         | 607823               | F612DD1B
*  22168 |        37423 | 4045482577@vzw3g.com | 0080440E191A         | 613709               | F610B463
   24280 |        26534 | 4044166201@vzw3g.com | 0080440F0443         | 693692               | A100000942B5A0
   24281 |        26538 | 4044162906@vzw3g.com | 0080440F0444         | 693700               | A100000942B543
   27056 |        28209 | 4049228546@vzw3g.com | 0080440F0440         | 693691               | A100000942B5A3

-- Test 1 - suspend a device first, then restore

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

select * from ops_api_suspend('F610B463');
 result_code | error_message 
-------------+---------------
 t           | 
(1 row)

select * from ops_api_restore('F610B463');
 result_code |    error_message    
-------------+---------------------
 t           | Device is restored.
(1 row)

rollback;
ROLLBACK

-- Test 2 - test ops_api_restore where no esn hex is defined

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

select * from ops_api_restore('');
 result_code |                    error_message                     
-------------+------------------------------------------------------
 f           | ERROR:  Input ESN HEX Is Null. Please enter a value.
(1 row)

rollback;
ROLLBACK

-- Test 3 - test with an esn hex that is not suspended.

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

select * from ops_api_restore('F612DC81');
 result_code |                      error_message                       
-------------+----------------------------------------------------------
 f           | ERROR:  Device is not suspended and can not be restored.
(1 row)

ROLLBACK;
ROLLBACK

-- Test 4 - test with an esn hex that is cancelled.

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

select * from ops_api_restore('F615C897');
 result_code |               error_message               
-------------+-------------------------------------------
 f           | ERROR:  Cannot restore a canceled device.
(1 row)

rollback;
ROLLBACK


-- Test 5 - test with an esn hex that does not exist.

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

select * from ops_api_restore('F61X5829');
 result_code |             error_message             
-------------+---------------------------------------
 f           | ERROR:  ESN HEX value does not exist.
(1 row)

rollback;
ROLLBACK


--


SELECT equipment_id 
  FROM unique_identifier
 WHERE unique_identifier_type = 'ESN HEX'
   AND value LIKE 'A100000942B543';
var_equipment_id 
--------------
        26538


SELECT value
  FROM unique_identifier
 WHERE unique_identifier_type = 'MDN'
   AND equipment_id = 26538;
  var_mdn   
------------
 4044162906
(1 row)


SELECT unam.username
      FROM username unam
      WHERE SUBSTR(unam.username,1,10) = var_mdn;
     var_username
----------------------
 4044162906@vzw3g.com
(1 row)

SELECT TRUE 
  FROM unique_identifier 
  JOIN line_equipment le USING (equipment_id) 
 WHERE value = '4044162906'
   AND le.end_date IS NULL;
 bool 
------
 t
 t
(2 rows)



SELECT TRUE   
  FROM usergroup   
 WHERE username LIKE '9172631095' 
   AND (groupname LIKE 'disconnected' OR 
   		groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione');


-- ops_change_static_ip

-- Test 1 :  username not found

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

 result_code |                          error_message                           
-------------+------------------------------------------------------------------
 f           | ERROR: radius_username not found on line table. [line_id=999888]
(1 row)

rollback;
ROLLBACK

-- Test 2: Old IP address not in radreply table.

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

SELECT * FROM csctoss.ops_change_static_ip('46393', '10.60.80.202', '10.60.80.124');
 result_code |                       error_message                       
-------------+-----------------------------------------------------------
 f           | ERROR: Old IP address was not assigned in radreply table.
(1 row)

rollback;
ROLLBACK

-- Test 3: New IP address not in radreply

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

SELECT * FROM csctoss.ops_change_static_ip('44361', '10.81.148.210', '10.81.20.118');
 result_code |                           error_message                            
-------------+--------------------------------------------------------------------
 f           | ERROR: New IP address was not retrieved from static_ip_pool table.
(1 row)

rollback;
ROLLBACK


-- Test 4: 

csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# SELECT * FROM csctoss.ops_change_static_ip(44361, '10.81.148.210', '10.81.125.112');
 result_code |                                      error_message                                       
-------------+------------------------------------------------------------------------------------------
 t           | Static IP address has been changed from 10.81.148.210 to 10.81.125.112 for line_id=44361
(1 row)

csctoss=# rollback;
ROLLBACK


-- update_unique_identifier_value
-- Test 1 - change the ESN HEX type

csctoss=# BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# SELECT * FROM csctoss.update_unique_identifier_value(38527, 'ESN HEX', 'F612DC81', 'F612DC18');
 result_code |   error_message    
-------------+--------------------
 t           | Successful Update!
(1 row)

csctoss=# ROLLBACK;
ROLLBACK

-- Test 2 - change the MDN type
begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# SELECT * FROM csctoss.update_unique_identifier_value(38527, 'SERIAL NUMBER', '621572', '621579');
 result_code | error_message  
-------------+----------------
 f           | Unknown error!
(1 row)

csctoss=# ROLLBACK;
ROLLBACK

-- Test 3 - test with invalud serial number (duplicate condition)

begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# SELECT * FROM csctoss.update_unique_identifier_value(38527, 'SERIAL NUMBER', '621572', '621579');
 result_code |                             error_message                             
-------------+-----------------------------------------------------------------------
 f           | Unique identifier type SERIAL NUMBER with value 621579 already exists
(1 row)


-- insert_update_location_labels.sql
-- Test 1 - change the ESN HEX type
--    select * from (line_id, owner, id, name, address, processor, fwver, uptime);
line_id   | 44861
owner     | ARLENE SISON 323-335-8652
id        | CA1569
name      | ALAS CARGO LLC (5)
address   | 627 N VERMONT AVE, LOS ANGELES,CA 90004
processor | TransFast Remittance, LLC
fwver     | 
uptime    | 


-- Test 1 - update 44861

begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
------------------------- 
                       3
(1 row)

select * from insert_update_location_labels(44861, 'ARLENE SISON 323-335-8652', 'CA158793', 'ALAS CARGO LLC (5)' ,'627 N VERMONT AVE, SAN LUIS OBISPO,CA 9004' ,'TransFast Remittance, LLC' ,'' ,NULL);

ROLLBACK;


UPDATE location_labels 
       SET owner = 'ARLENE SISON 323-335-8652', 
              id = 'CA158793', 
            name = 'ALAS CARGO LLC (5)', 
         address = '627 N VERMONT AVE, SAN LUIS OBISPO,CA 9004', 
       processor = 'TransFast Remittance, LLC',
           fwver = '',
          uptime = null
   WHERE line_id = 44861;


UPDATE location_labels
   SET owner = 'ARLENE SISON 323-335-8652'
          id = 'CA1569'
        name = 'ALAS CARGO LLC (5)'
     address = '627 N VERMONT AVE, LOS ANGELES,CA 90004'
   processor = 'TransFast Remittance, LLC'
       fwver = ''
      uptime = null
 WHERE line_id = 44861;


line_id   | 44861
owner     | ARLENE SISON 323-335-8652
id        | CA1569
name      | ALAS CARGO LLC (5)
address   | 627 N VERMONT AVE, LOS ANGELES,CA 90004
processor | TransFast Remittance, LLC
fwver     | 
uptime    | 


UPDATE location_labels 
   SET owner = 'ARLENE SISON 323-335-8652', 
          id = 'CA1569', 
        name = 'ALAS CARGO LLC (5)', 
     address = '627 N VERMONT AVE, LOS ANGELES,CA 90004', 
   processor = 'TransFast Remittance, LLC',
       fwver = '',
      uptime = null
WHERE line_id = 44861;




