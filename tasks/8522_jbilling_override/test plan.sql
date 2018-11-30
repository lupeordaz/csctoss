-- test plan
select * from ops_api_activate('353238060039236'
	                         , '89148000003298404612'
	                         , '4043271503'
	                         , '4043271503'
	                         , '419508'
	                         , '00042D0666B4'
	                         , 171
	                         , 'vzw3g'
	                         , 'vzw3g');

csctoss=# begin;
BEGIN
csctoss=# select * from ops_api_activate('353238060039236', '89148000003298404612', '4043271503', '4043271503', '419508', '00042D0666B4', 171, 'vzw3g', 'vzw3g');
 result_code |    error_message     
-------------+----------------------
 t           | Device is activated.
(1 row)

csctoss=# commit;
COMMIT
csctoss=# 


select * from ops_api_assign('353238060039236', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);

csctoss=# begin;
BEGIN
select * from ops_api_assign('353238060039236', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
NOTICE:  Sales Order: SO-12436
NOTICE:  ESN: 353238060039236
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4043271503
NOTICE:  USERNAME: 4043271503@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4043271503@vzw3g.com][line_id=46963][billing_entity_id=699]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found IP pool.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Class attribute value into radreply table. [line_id=46963]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Class attribute value into radreply table. [line_id=46963]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Updating static_ip_pool table for [IP=10.81.136.114 / VRF=SERVICE-vzwretail_cnione]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  STATIC IP: 10.81.136.114
ERROR:  ERROR: Invalid Product code
csctoss=# rollback
csctoss-# 

SELECT product_id, plan_type_id, length_days 
  FROM csctoss.product
 WHERE 1 = 1
   AND product_id = 156;
 product_id |     product_code     | plan_type_id | length_days | obsolete |           product_desc           | prepaid_unit | prepaid_allowa
nce | default_logical_apn | sales_price 
------------+----------------------+--------------+-------------+----------+----------------------------------+--------------+---------------
----+---------------------+-------------
        156 | MRC-CNI-SS-M-0-N-0-3 |            4 |     1000000 | f        | CNI Secure and Safe Connectivity | MB           |               
  5 |                     |        0.00
(1 row)


BEGIN;
select * from ops_api_assign('353238060039236', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-CNI-SS-M-0-N-0-3', FALSE);
csctoss=# BEGIN;
BEGIN
csctoss=# select * from ops_api_assign('353238060039236', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-CNI-SS-M-0-N-0-3', FALSE);
NOTICE:  Sales Order: SO-12436
NOTICE:  ESN: 353238060039236
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4043271503
NOTICE:  USERNAME: 4043271503@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4043271503@vzw3g.com][line_id=46966][billing_entity_id=699]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found IP pool.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Class attribute value into radreply table. [line_id=46966]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Class attribute value into radreply table. [line_id=46966]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.136.114]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Updating static_ip_pool table for [IP=10.81.136.114 / VRF=SERVICE-vzwretail_cnione]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  STATIC IP: 10.81.136.114
NOTICE:  Inserting Warranty Info into equipment_warranty table
 result_code |            error_message             
-------------+--------------------------------------
 t           | Line assignment is done succesfully.
(1 row)

csctoss=# commit;
COMMIT
csctoss=#

--

select * from unique_identifier where equipment_id = 43866;
 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        43866 | ESN DEC                | 89148000004023158895 |       | 2018-08-28   | 
        43866 | ESN HEX                | 352613070309996      |       | 2018-08-28   | 
        43866 | MAC ADDRESS            | 00804413A3B1         |       | 2018-08-28   | 
        43866 | MDN                    | 4704215622           |       | 2018-08-28   | 
        43866 | MIN                    | 4704215622           |       | 2018-08-28   | 
        43866 | SERIAL NUMBER          | S11554               |       | 2018-08-28   | 
(6 rows)

csctoss=# \e
 equipment_id | equipment_model_id | model_number1 
--------------+--------------------+---------------
        43866 |                186 | SL-05-E2-CV1

ESN HEX                 352613070309996      
ESN DEC                 89148000004023158895 
MDN                     4704215622           
MIN                     4704215622           
SERIAL NUMBER           S11554               
MAC ADDRESS             00804413A3B1         


   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;

-- Test 1 - Set up ESN HEX and assign using OSS product table (No calls to JBilling)
--   Step 1 - Activate ESN HEX 352613070309996

BEGIN
select * from ops_api_activate('352613070309996'
                              , '89148000004023158895'
                              , '4704215622'
                              , '4704215622'
                              , 'S11554'
                              , '00804413A3B1'
                              , 186
                              , 'vzw3g'
                              , 'vzw3g');
 result_code |    error_message     
-------------+----------------------
 t           | Device is activated.
(1 row)

csctoss=# commit;
COMMIT


--   Step 2 - Call ops_api_assign using new signature functon passing 7 parameters.

csctoss=# BEGIN;
BEGIN
select * from ops_api_assign('352613070309996', 'SO-12437', 577, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-005-01RP-EVV', FALSE);
NOTICE:  Sales Order: SO-12437
NOTICE:  ESN: 352613070309996
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4704215622
NOTICE:  USERNAME: 4704215622@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4704215622@vzw3g.com][line_id=46965][billing_entity_id=577]

NOTICE:  We found IP pool.

NOTICE:  We found an available IP address in the IP pool. [IP=10.81.150.59]

NOTICE:  Inserting Class attribute value into radreply table. [line_id=46965]

NOTICE:  Inserted Class attribute value into radreply table. [line_id=46965]

NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.150.59]

NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.150.59]

NOTICE:  Updating static_ip_pool table for [IP=10.81.150.59 / VRF=SERVICE-vzwretail_cnione]

NOTICE:  STATIC IP: 10.81.150.59

NOTICE:  Inserting Warranty Info into equipment_warranty table
 result_code |            error_message             
-------------+--------------------------------------
 t           | Line assignment is done succesfully.
(1 row)

csctoss=# commit;
COMMIT
csctoss=# 

-- Test 1 is Successful.


-- Test 2 - 
--   Step 1 - Activate ESN HEX 352613070309996

BEGIN
select * from ops_api_activate('353238060034021'
                              , '89148000003298403028'
                              , '4043271521'
                              , '4043271521'
                              , '419510'
                              , '00042D0666B6'
                              , 171
                              , 'vzw3g'
                              , 'vzw3g');

 result_code |    error_message     
-------------+----------------------
 t           | Device is activated.
(1 row)

csctoss=# commit;
COMMIT


--   Step 2 - Call ops_api_assign using original signature that calls JBilling.  This should return
--            an error since the ESN 353238060034021 is already provisioned in JBilling

BEGIN
csctoss=# select * from ops_api_assign('353238060034021', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE);

NOTICE:  Sales Order: SO-12436

NOTICE:  ESN: 353238060034021

NOTICE:  CARRIER: VZW

NOTICE:  MDN/MIN: 4043271521

NOTICE:  USERNAME: 4043271521@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione

NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4043271521@vzw3g.com][line_id=46967][billing_entity_id=699]

NOTICE:  We found IP pool.

NOTICE:  We found an available IP address in the IP pool. [IP=10.81.136.115]

NOTICE:  Inserting Class attribute value into radreply table. [line_id=46967]

NOTICE:  Inserted Class attribute value into radreply table. [IP=10.81.136.115]

NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.136.115]

NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.136.115]

NOTICE:  Updating static_ip_pool table for [IP=10.81.136.115 / VRF=SERVICE-vzwretail_cnione]

NOTICE:  STATIC IP: 10.81.136.115

NOTICE:  Calling Jbilling to get Product Name (internal number) from item table.

NOTICE:  MRC Product Code from Jbilling: <NULL> length: <NULL>

ERROR:  ERROR: Product code not present in Product table


csctoss=# rollback;
ROLLBACK

-- Test is Successful because it calls the JBilling database; cannot enter data on JBilling 
-- because it already exists.



-- Test 3:  Insert ESN HEX 353238060035945 via new signature and bypassing JBilling processing
--   Step 1:  Activate ESN HEX 353238060035945


BEGIN
select * from ops_api_activate('353238060035945'
                              , '89148000000986138015'
                              , '4706336563'
                              , '4706336563'
                              , '419355'
                              , '00042D06661B'
                              , 171
                              , 'vzw3g'
                              , 'vzw3g');

 result_code |    error_message     
-------------+----------------------
 t           | Device is activated.
(1 row)

csctoss=# commit;
COMMIT



--   Step 2 - Call ops_api_assign using new signature functon passing 7 parameters.

csctoss=# begin;
BEGIN
csctoss=# select * from ops_api_assign('353238060035945', 'SO-12438', 699, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-CNI-SS-M-0-N-0-3', FALSE);
NOTICE:  Sales Order: SO-12438
NOTICE:  ESN: 353238060035945
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4706336563
NOTICE:  USERNAME: 4706336563@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4706336563@vzw3g.com][line_id=46970][billing_entity_id=699]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found IP pool.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.136.115]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Class attribute value into radreply table. [line_id=46970]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Class attribute value into radreply table. [IP=10.81.136.115]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.136.115]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.136.115]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Updating static_ip_pool table for [IP=10.81.136.115 / VRF=SERVICE-vzwretail_cnione]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  STATIC IP: 10.81.136.115
NOTICE:  Inserting Warranty Info into equipment_warranty table
 result_code |            error_message             
-------------+--------------------------------------
 t           | Line assignment is done succesfully.
(1 row)

-- Test 1 is Successful; line is established and device is provisioned.









ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4043271521@vzw3g.com][line_id=46967][billing_entity_id=699]

select * from ops_api_static_ip_assign('VZW', 'SERVICE-vzwretail_cnione', '4043271521@vzw3g.com', 46967, 699);

