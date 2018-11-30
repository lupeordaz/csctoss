
ESN HEX:		353238060067682

Sale Order:		SO100364
Billing Entit	Area Wide, Inc
Groupname:		SERVICE-vzwretail_cnione
Static IP:		true
Product Code:	MRC-005-01RP-EVV


SELECT em.carrier                                                          
  FROM unique_identifier ui
  JOIN equipment e ON (ui.equipment_id = e.equipment_id)
  JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id)
 WHERE 1 = 1
   AND ui.value = '353238060067682'
 LIMIT 1;
 carrier 
---------
 VZW


select billing_entity_id from billing_entity where name like 'Area Wide, Inc%';
 billing_entity_id 
-------------------
               368


SELECT em.carrier
  FROM unique_identifier ui
  JOIN equipment e ON (ui.equipment_id = e.equipment_id)
  JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id)
 WHERE 1 = 1
   AND ui.value = '353238060067682'
 LIMIT 1;


SELECT static_ip
  FROM static_ip_pool sip
  JOIN static_ip_carrier_def sid
    ON (sid.carrier_def_id = sip.carrier_id)
 WHERE groupname = 'SERVICE-vzwretail_cnione'
   AND carrier LIKE '%'||VZW||'%'
   AND billing_entity_id = par_billing_entity_id
 ORDER BY billing_entity_id


-- Call ops_api_activate
   par_esn_hex                 353238060067682
   par_esn_dec                 89148000004599387399
   par_mac_address             00042D066A90
   par_serial_number           tS420496
   par_mdn                     4708298912
   par_min                     4708298912

   par_equipment_model_id      171
   par_realm                   vzw3g.com
   par_carrier                 VZW


        44297 | ESN DEC                | 89148000004599387399 |       | 2018-11-01   | 
        44297 | ESN HEX                | 353238060067682      |       | 2018-11-01   | 
        44297 | MAC ADDRESS            | 00042D066A90         |       | 2018-11-01   | 
        44297 | MDN                    | 4708298912           |       | 2018-11-01   | 
        44297 | MIN                    | 4708298912           |       | 2018-11-01   | 
        44297 | SERIAL NUMBER          | S420496              |       | 2018-11-01   | 




-- Call ops_api_assign
    par_esn_hex             :	353238060067682
    par_sales_order         :	SO100364
    par_billing_entity_id   :	368
    par_groupname           :	'SERVICE-vzwretail_cnione'
    par_static_ip_boolean   :	true
    par_product_code        :	'MRC-005-01RP-EVV'
    par_bypass_jbilling     :	true

select * from ops_api_assign('353238060067682','SO100364',368,'SERVICE-vzwretail_cnione',true,'MRC-005-01RP-EVV',true);

--
BEGIN
csctoss=# select * from ops_api_assign('353238060067682','SO100364',368,'SERVICE-vzwretail_cnione',true,'MRC-005-01RP-EVV',true)
csctoss-# ;
NOTICE:  Sales Order: SO100364
NOTICE:  ESN: 353238060067682
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4708298912
NOTICE:  USERNAME: 4708298912@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4708298912@vzw3g.com][line_id=47269][billing_entity_id=368]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 269 at select into variables
NOTICE:  No billing entity id path selected.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 269 at select into variables
NOTICE:  Processing radreply: Username: 4708298912@vzw3g.com, static_ip: 10.80.0.85.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 269 at select into variables
NOTICE:  Update static_ip_pool for static_ip 10.80.0.85: line_id - 47269, groupname - SERVICE-vzwretail_cnione
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 269 at select into variables
NOTICE:  STATIC IP: 10.80.0.85
NOTICE:  Inserting Warranty Info into equipment_warranty table
 result_code |            error_message             
-------------+--------------------------------------
 t           | Line assignment is done succesfully.
(1 row)

csctoss=# rollback;
ROLLBACK


