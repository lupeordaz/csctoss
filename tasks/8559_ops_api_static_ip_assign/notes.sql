

[carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4705120287@vzw3g.com][line_id=47045][billing_entity_id=825]



BEGIN; select ops_api_static_ip_assign('VZW', 'SERVICE-vzwretail_cnione', '4705120287@vzw3g.com', 47045, 825); ROLLBACK;

--

csctoss=# BEGIN; select * from rt_oss_rma('352613070306034', '352613070467521', '773263383926', false); ROLLBACK;
BEGIN
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: 352613070467521
NOTICE:  New ESN: 352613070467521 not found in UI table
NOTICE:  rt_oss_rma: when raise_exception:  New ESN: 352613070467521 not found in UI table 
 billing_entity_id | old_equip_id | old_model | old_sn | old_username | new_equip_id | new_model | new_sn | rma_so_num | line_id | carrier | userna
me | groupname |                    message                     
-------------------+--------------+-----------+--------+--------------+--------------+-----------+--------+------------+---------+---------+-------
---+-----------+------------------------------------------------
                   |              |           |        |              |              |           |        |            |         |         |       
   |           | New ESN: 352613070467521 not found in UI table
(1 row)

ROLLBACK
csctoss=# 

--

select l.line_id                                                         
        ,le.equipment_id
        ,e.equipment_model_id
        ,em.carrier
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join equipment e on e.equipment_id = le.equipment_id
    join equipment_model em on e.equipment_model_id = em.equipment_model_id
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = '352613070467521';
 line_id | equipment_id | equipment_model_id | carrier |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+--------------------+---------+----------------------+--------------+----------+-----------------
   47141 |        43807 |                186 | VZW     | 4704211265@vzw3g.com | 00804412E9D5 | S21724   | 352613070467521
(1 row)

--

csctoss=# select * from unique_identifier where equipment_id = 43807;
 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        43807 | ESN DEC                | 89148000003298402970 |       | 2018-08-03   | 
        43807 | ESN HEX                | 352613070467521      |       | 2018-08-03   | 
        43807 | MAC ADDRESS            | 00804412E9D5         |       | 2018-08-03   | 
        43807 | MDN                    | 4705120287           |       | 2018-08-03   | 
        43807 | MIN                    | 4705120287           |       | 2018-08-03   | 
        43807 | SERIAL NUMBER          | S21724               |       | 2018-08-03   | 
(6 rows)

--


   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;

select * from ops_api_activate('352613070467521'
                              , '89148000003298402970'
                              , '4705120287'
                              , '4705120287'
                              , 'S21724'
                              , '00804412E9D5'
                              , 186
                              , 'vzw3g'
                              , 'vzw3g');
 result_code |    error_message     
-------------+----------------------
 t           | Device is activated.
(1 row)

--

NOTICE:  Calling function ops_api_static_ip(VZW,SERVICE-vzwretail_cnione,4705120287@vzw3g.com,47045,825)


NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW]
                                                           [vrf=SERVICE-vzwretail_cnione]
                                                           [username=4705120287@vzw3g.com]
                                                           [line_id=47045]
                                                           [billing_entity_id=825]


NOTICE:  No billing entity id path selected.




SELECT static_ip
  FROM static_ip_pool sip
  JOIN static_ip_carrier_def sid
    ON (sid.carrier_def_id = sip.carrier_id)
 WHERE groupname = 'SERVICE-vzwretail_cnione'
   AND carrier LIKE '%VZW%'
   AND billing_entity_id = 825
 ORDER BY billing_entity_id
 LIMIT 1;



csctoss=# begin;
BEGIN
csctoss=# SELECT * FROM public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

csctoss=# INSERT INTO radreply (username, attribute, op, value, priority)
csctoss-# VALUES('4702302503@vzw3g.com', 'Framed-IP-Address', '=', '10.80.0.215', 10);
ERROR:  Username 4702302503@vzw3g.com already assigned Framed-IP-Address 10.81.23.52
csctoss=# ROLLBACK;
ROLLBACK
csctoss=#

BEGIN; ops_api_static_ip('VZW','SERVICE-vzwretail_cnione','4702302503@vzw3g.com', 47045, 825); ROLLBACK; 


--

csctoss=# BEGIN; select * from ops_api_static_ip_assign('VZW','SERVICE-vzwretail_cnione','4702302503@vzw3g.com', 47045, 825); ROLLBACK;
BEGIN
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4702302503@vzw3g.com][line_id=47045][billing_entity_id=825]
NOTICE:  No billing entity id path selected.
NOTICE:  Processing radreply: Username: 4702302503@vzw3g.com, static_ip: 10.80.0.215.
ERROR:  Username 4702302503@vzw3g.com already assigned Framed-IP-Address 10.81.23.52
CONTEXT:  SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
PL/pgSQL function "ops_api_static_ip_assign" line 139 at SQL statement
ROLLBACK

