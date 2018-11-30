

BEGIN

select * from rt_oss_rma('352613070306034', '352613070467521', '773263383926', false);
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: 352613070467521
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 825: Carolina Coin Amusement LLC
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  rt_oss_rma:  Serial number found for original esn: 352613070306034 equip id: 43797
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : 352613070306034
NOTICE:  old ip            : 10.80.0.52
NOTICE:  old username      : 4045615012@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_cnione
NOTICE:  old equipment id  : 43797
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : 352613070467521
NOTICE:  new equipment id  : 43807
NOTICE:  new model         : SL-05-E2-CV1
NOTICE:  carrier           : VZW
NOTICE:  billing entity    : 825
NOTICE:  billing entity nm : Carolina Coin Amusement LLC
NOTICE:  new username      : 4705120287@vzw3g.com
NOTICE:  new groupname     : SERVICE-vzwretail_cnione
NOTICE:  static ip?        : t
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 2 rows related to old username(4045615012@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 

NOTICE:  Deleted 1 rows related to new username from radcheck: % 

NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_vzwretail_cnione , priority=50000 WHERE 1=1 AND username=4045615012@vzw3g.com

NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 4705120287@vzw3g.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=47045, old_equipment_id=43797, new_equipment_id=43807, end_date=2018-09-18
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4705120287@vzw3g.com][line_id=47045][billing_entity_id=825]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 500 at select into variables
NOTICE:  No billing entity id path selected.
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 500 at select into variables
 billing_entity_id | old_equip_id | old_model | old_sn | old_username | new_equip_id | new_model | new_sn | rma_so_num | line_id | carrier | username | 
groupname |                                   message                                    
-------------------+--------------+-----------+--------+--------------+--------------+-----------+--------+------------+---------+---------+----------+-
----------+------------------------------------------------------------------------------
                   |              |           |        |              |              |           |        |            |         |         |          | 
          | INSERT FAILED for new row into line_equipment with new equipment id for line
(1 row)

csctoss=# ROLLBACK;
ROLLBACK
csctoss=# 


select l.line_id
FROM unique_identifier ui
       JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
       JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
       JOIN line l ON (le.line_id = l.line_id)
       JOIN billing_entity be ON (l.billing_entity_id = be.billing_entity_id)
       WHERE 1 = 1
       AND ui.unique_identifier_type = 'ESN HEX'
       AND ui.value = '352613070306034'
       AND le.end_date IS NULL
       AND l.end_date IS NULL;
 line_id 
---------
   47045
(1 row)


select * 
  from line_equipment le
 where 1=1
   and le.line_id=47045
   and le.equipment_id=43797
   and le.end_date =current_date;
 line_id | equipment_id | start_date | end_date | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+----------+---------------------------+-----------+--------------+--------------
(0 rows)

INSERT INTO line_equipment
         ( SELECT '47045'::integer,43807::integer,current_date,
                  null,billing_entity_address_id,ship_date,install_date,installed_by
           from line_equipment le
           where 1=1
             and le.line_id='47045'
             and le.equipment_id=43797
             and le.end_date =current_date);


UPDATE line_equipment 
   set end_date = current_date
 where 1=1
   and equipment_id = '43797'
   and line_id = '47045'
   and end_date is null;

--

ops_api_static_ip_assign is called: parameters => [carrier=VZW]
                                                  [vrf=SERVICE-vzwretail_cnione]
                                                  [username=4705120287@vzw3g.com]
                                                  [line_id=47045]
                                                  [billing_entity_id=825]

select * from ops_api_static_ip_assign('VZW','SERVICE-vzwretail_cnione', '4705120287@vzw3g.com', 47045, 825);

select * from rt_oss_rma('352613070306034', '352613070467521', '773263383926', false);

BEGIN; select * from rt_oss_rma('352613070306034', '352613070344837', '773263383926', false); ROLLBACK;

csctoss=# BEGIN; select * from rt_oss_rma('352613070306034', '352613070344837', '773263383926', true); COMMIT;
BEGIN
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: 352613070344837
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 825: Carolina Coin Amusement LLC
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  rt_oss_rma:  Serial number found for original esn: 352613070306034 equip id: 43797
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : 352613070306034
NOTICE:  old ip            : 10.80.0.52
NOTICE:  old username      : 4045615012@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_cnione
NOTICE:  old equipment id  : 43797
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : 352613070344837
NOTICE:  new equipment id  : 43915
NOTICE:  new model         : SL-05-E2-CV1
NOTICE:  carrier           : VZW
NOTICE:  billing entity    : 825
NOTICE:  billing entity nm : Carolina Coin Amusement LLC
NOTICE:  new username      : 4044166735@vzw3g.com
NOTICE:  new groupname     : SERVICE-vzwretail_cnione
NOTICE:  static ip?        : t
NOTICE:  ----- End of Function data ----------
NOTICE:  Update line_equipment for equipment_id: 43797
NOTICE:  DIAG v_numrows: 1
NOTICE:  Deleted 2 rows related to old username(4045615012@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_vzwretail_cnione , priority=50000 WHERE 1=1 AND username=4045615012@vzw3g.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 4044166735@vzw3g.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=47045, old_equipment_id=43797, new_equipment_id=43915, end_date=2018-09-18
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded.
NOTICE:  Processing equipment_warranty for new equipment id: 43915
NOTICE:  Calling function ops_api_static_ip(VZW,SERVICE-vzwretail_cnione,4044166735@vzw3g.com,47045,825)
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4044166735@vzw3g.com][line_id=47045][billing_entity_id=825]


CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 504 at select into variables


NOTICE:  No billing entity id path selected.


CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 504 at select into variables

NOTICE:  Processing radreply: Username: 4044166735@vzw3g.com, static_ip: 10.80.0.130.


CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 504 at select into variables
NOTICE:  Update static_ip_pool for static_ip 10.80.0.130: line_id - 47045, groupname - SERVICE-vzwretail_cnione
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 504 at select into variables
NOTICE:  ops_api_static_ip return: 10.80.0.130
NOTICE:  rt_oss_rma: Sucessfully updated new username  
 billing_entity_id | old_equip_id |  old_model   | old_sn |     old_username     | new_equip_id |  new_model   | new_sn | rma_so_num | line_id | carrier |       username       |        groupname       
  | message 
-------------------+--------------+--------------+--------+----------------------+--------------+--------------+--------+------------+---------+---------+----------------------+------------------------
--+---------
               825 |        43797 | SL-05-E2-CV1 | S12916 | 4045615012@vzw3g.com |        43915 | SL-05-E2-CV1 | S14851 |            |   47045 | VZW     | 4044166735@vzw3g.com | SERVICE-vzwretail_cnion
e | Success
(1 row)

COMMIT
csctoss=#