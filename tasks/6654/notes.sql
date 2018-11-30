====

-- Test Plan

-[ Test 1 ]-----+-------------------------------------
old ESN value       | 4702597338
radius_username     | 4702597338@vzw3g.com
billing_entity_id   | 112
name                | Contour Demo
line_id             | 42748
equipment_id        | 40531
start_date          | 2015-10-21 00:00:00+00
end_date            | 
start_date          | 2015-10-21
end_date            | 
notes               | SO-10295

warranty_start_date | 2015-10-21 00:00:00+00
warranty_end_date   | 2020-10-21 00:00:00+00

new ESN value         A10000157E3DEE
equipment_id        | 32783
esn_hex             | A10000157E3DEE
warranty_start_date | 2017-07-19 00:00:00+00
warranty_end_date   | 2022-07-19 00:00:00+00


New ESN value
 equipment_id |  model_number1  |    esn_hex     | serialno |  warranty_start_date   |   warranty_end_date    
--------------+-----------------+----------------+----------+------------------------+------------------------
        32783 | Systech 8100ESP | A10000157E3DEE | 760478   | 2017-07-19 00:00:00+00 | 2022-07-19 00:00:00+00
        32783 | Systech 8100ESP | A10000157E3DEE | 760478   | 2017-07-19 00:00:00+00 | 2022-07-19 00:00:00+00
        32783 | Systech 8100ESP | A10000157E3DEE | 760478   | 2017-07-19 00:00:00+00 | 2022-07-19 00:00:00+00


select * from rt_oss_rma('4702597338', 'A10000157E3DEE', '5312');

csctoss=# select * from rt_oss_rma('4702597338', 'A10000157E3DEE', '5312');
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A10000157E3DEE
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 112: Contour Demo
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  rt_oss_rma:  Serial number found for original esn: 4702597338 equip id: 40531
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : 4702597338
NOTICE:  old ip            : 10.80.1.109
NOTICE:  old username      : 4702597338@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_cnione
NOTICE:  old equipment id  : 40531
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : A10000157E3DEE
NOTICE:  new equipment id  : 32783
NOTICE:  new model         : Systech 8100ESP
NOTICE:  carrier           : SPRINT
NOTICE:  billing entity    : 112
NOTICE:  billing entity nm : Contour Demo
NOTICE:  new username      : 5774874304@tsp17.sprintpcs.com
NOTICE:  new groupname     : SERVICE-private_atm
NOTICE:  static ip?        : f
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 2 rows related to old username(4702597338@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_uscc_sprint , priority=50000 WHERE 1=1 AND username=4702597338@vzw3g.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 5774874304@tsp17.sprintpcs.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=42748, old_equipment_id=40531, new_equipment_id=32783, end_date=2018-05-22
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.
NOTICE:  INSERT/UPDATE equipment_warranty: v_nequipid: 32783, start_date=2015-10-21, model id=77
NOTICE:  [rt_oss_rma] Insert/Update for equipment_warranty succeeded. Move on to static IP handling.
NOTICE:  rt_oss_rma: Sucessfully updated new username  
NOTICE:  -----------  calling jbilling_rma ------------------------------------- 
NOTICE:   the sql to call jbilling_rma: SELECT * from oss.rt_jbilling_rma(112 , 77 , '4702597338' , 'A10000157E3DEE' , '760478' , '5774874304@tsp17.sprintpcs.com',42748,'5312')
NOTICE:  rt_oss_rma: Returned from Jbilling: Jbilling RMA: No active line found in jbilling for esn_hex: 4702597338
 billing_entity_id | old_equip_id | old_model | old_sn |     old_username     | new_equip_id |    new_model    | new_sn |                               rma_so_num                               | line_id | carrier |            username            |      groupname      | message 
-------------------+--------------+-----------+--------+----------------------+--------------+-----------------+--------+------------------------------------------------------------------------+---------+---------+--------------------------------+---------------------+---------
               112 |        40531 | WR11-L800 | 419994 | 4702597338@vzw3g.com |        32783 | Systech 8100ESP | 760478 | Jbilling RMA: No active line found in jbilling for esn_hex: 4702597338 |   42748 | SPRINT  | 5774874304@tsp17.sprintpcs.com | SERVICE-private_atm | Success
(1 row)


SELECT le.equipment_id
      ,em.model_number1
      ,uie.value as esn_hex
      ,uis.value as serialno
      ,ew.warranty_start_date
      ,ew.warranty_end_date
  from line_equipment le
  join equipment e on e.equipment_id = le.equipment_id
  join equipment_model em on em.equipment_model_id =  e.equipment_model_id
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
  join equipment_warranty ew on ew.equipment_id = e.equipment_id
 where uie.value = 'A10000157E3DEE'
 group by le.equipment_id, em.model_number1, uie.value, uis.value, ew.warranty_start_date, ew.warranty_end_date;

 equipment_id |  model_number1  |    esn_hex     | serialno |  warranty_start_date   |   warranty_end_date    
--------------+-----------------+----------------+----------+------------------------+------------------------
        32783 | Systech 8100ESP | A10000157E3DEE | 760478   | 2015-10-21 00:00:00+00 | 2020-10-21 00:00:00+00
(1 row)

--

-[ Test 2 ]-----+-------------------------------------

SELECT ui.value                                             
      ,l.radius_username 
      ,be.billing_entity_id 
      ,be.name 
      ,l.line_id 
      ,ui.equipment_id 
      ,l.start_date 
      ,l.end_date 
      ,le.start_date 
      ,le.end_date 
      ,l.notes
  FROM unique_identifier ui
  JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
  JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
  JOIN line l ON (le.line_id = l.line_id)
  JOIN billing_entity be ON (l.billing_entity_id = be.billing_entity_id)
 WHERE 1 = 1
   AND ui.unique_identifier_type = 'ESN HEX'
   AND le.end_date IS NULL
   AND l.end_date IS NULL
   AND ui.value = 'A100001574C491';

-----+-----------------------
Old Esn value       | A100001574C491
radius_username     | 4046953646@vzw3g.com
billing_entity_id   | 112
name                | Contour Demo
line_id             | 46564
equipment_id        | 37778
start_date          | 2018-03-12 00:00:00+00
end_date            | 
start_date          | 2018-03-12
end_date            | 
notes               | SO-12116
warranty_start_date | 2014-04-23 00:00:00+00
warranty_end_date   | 2019-04-23 00:00:00+00


New device
equipment_id        | 36812
esn_hex             | A10000157EC118
serial_number       | 789490
warranty_start_date | 2015-09-10 00:00:00+00
warranty_end_date   | 2020-09-10 00:00:00+00


select * from rt_oss_rma('A100001574C491', 'A10000157EC118', '5332');
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A10000157EC118
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 112: Contour Demo
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  Static ip address not present for old username: 4046953646@vzw3g.com
NOTICE:  rt_oss_rma:  Serial number found for original esn: A100001574C491 equip id: 37778
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : A100001574C491
NOTICE:  old ip            : <NULL>
NOTICE:  old username      : 4046953646@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_inventory_cnione
NOTICE:  old equipment id  : 37778
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : A10000157EC118
NOTICE:  new equipment id  : 36812
NOTICE:  new model         : Systech 8110ESP
NOTICE:  carrier           : SPRINT
NOTICE:  billing entity    : 112
NOTICE:  billing entity nm : Contour Demo
NOTICE:  new username      : 5339384706@tsp17.sprintpcs.com
NOTICE:  new groupname     : SERVICE-private_atm
NOTICE:  static ip?        : f
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 1 rows related to old username(4046953646@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_uscc_sprint , priority=50000 WHERE 1=1 AND username=4046953646@vzw3g.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 5339384706@tsp17.sprintpcs.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=46564, old_equipment_id=37778, new_equipment_id=36812, end_date=2018-05-23
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.
NOTICE:  INSERT/UPDATE equipment_warranty: v_nequipid: 36812, start_date=2014-04-23, model id=68
NOTICE:  [rt_oss_rma] Insert/Update for equipment_warranty succeeded. Move on to static IP handling.
NOTICE:  rt_oss_rma: Sucessfully updated new username  
NOTICE:  -----------  calling jbilling_rma ------------------------------------- 
NOTICE:   the sql to call jbilling_rma: SELECT * from oss.rt_jbilling_rma(112 , 68 , 'A100001574C491' , 'A10000157EC118' , '789490' , '5339384706@tsp17.sprintpcs.com',46564,'5332')
NOTICE:  rt_oss_rma: Returned from Jbilling: Jbilling RMA: No active line found in jbilling for esn_hex: A100001574C491
-[ RECORD 1 ]-----+---------------------------------------------------------------------------
billing_entity_id | 112
old_equip_id      | 37778
old_model         | Systech 8100EVE
old_sn            | 862074
old_username      | 4046953646@vzw3g.com
new_equip_id      | 36812
new_model         | Systech 8110ESP
new_sn            | 789490
rma_so_num        | Jbilling RMA: No active line found in jbilling for esn_hex: A100001574C491
line_id           | 46564
carrier           | SPRINT
username          | 5339384706@tsp17.sprintpcs.com
groupname         | SERVICE-private_atm
message           | Success


SELECT le.equipment_id
      ,em.model_number1
      ,uie.value as esn_hex
      ,uis.value as serialno
      ,ew.warranty_start_date
      ,ew.warranty_end_date
  from line_equipment le
  join equipment e on e.equipment_id = le.equipment_id
  join equipment_model em on em.equipment_model_id =  e.equipment_model_id
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
  join equipment_warranty ew on ew.equipment_id = e.equipment_id
 where uie.value = 'A10000157EC118'
 group by le.equipment_id, em.model_number1, uie.value, uis.value, ew.warranty_start_date, ew.warranty_end_date;

-[ RECORD 1 ]-------+-----------------------
equipment_id        | 36812
model_number1       | Systech 8110ESP
esn_hex             | A10000157EC118
serialno            | 789490
warranty_start_date | 2014-04-23 00:00:00+00
warranty_end_date   | 2019-04-23 00:00:00+00

--- Test 3

SELECT ui.value                                             
      ,l.radius_username 
      ,be.billing_entity_id 
      ,be.name 
      ,l.line_id 
      ,ui.equipment_id 
      ,l.start_date 
      ,l.end_date 
      ,le.start_date 
      ,le.end_date 
      ,l.notes
  FROM unique_identifier ui
  JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
  JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
  JOIN line l ON (le.line_id = l.line_id)
  JOIN billing_entity be ON (l.billing_entity_id = be.billing_entity_id)
 WHERE 1 = 1
   AND ui.unique_identifier_type = 'ESN HEX'
   AND le.end_date IS NULL
   AND l.end_date IS NULL
   AND ui.value = 'A10000157E3DEE';

Old ESN value       | A10000157E3DEE
radius_username     | 5774874304@tsp17.sprintpcs.com
billing_entity_id   | 112
name                | Contour Demo
line_id             | 42748
equipment_id        | 32783
start_date          | 2015-10-21 00:00:00+00
end_date            | 
start_date          | 2018-05-22
end_date            | 
notes               | SO-10295
warranty_start_date | 2015-10-21 00:00:00+00
warranty_end_date   | 2020-10-21 00:00:00+00


new ESN value       | A10000157EBB8B
equipment_id        | 36795
serial_number       | 779912
warranty_start_date | 2014-03-11 00:00:00+00
warranty_end_date   | 2019-03-11 00:00:00+00


select * from rt_oss_rma('A10000157E3DEE', 'A10000157EBB8B', '5312');
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A10000157EBB8B
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 112: Contour Demo
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  Static ip address not present for old username: 5774874304@tsp17.sprintpcs.com
NOTICE:  rt_oss_rma:  Serial number found for original esn: A10000157E3DEE equip id: 32783
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : A10000157E3DEE
NOTICE:  old ip            : <NULL>
NOTICE:  old username      : 5774874304@tsp17.sprintpcs.com
NOTICE:  old groupname     : SERVICE-private_atm
NOTICE:  old equipment id  : 32783
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : A10000157EBB8B
NOTICE:  new equipment id  : 36795
NOTICE:  new model         : Systech 8110ESP
NOTICE:  carrier           : SPRINT
NOTICE:  billing entity    : 112
NOTICE:  billing entity nm : Contour Demo
NOTICE:  new username      : 5339384618@tsp18.sprintpcs.com
NOTICE:  new groupname     : SERVICE-private_atm
NOTICE:  static ip?        : f
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 1 rows related to old username(5774874304@tsp17.sprintpcs.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_uscc_sprint , priority=50000 WHERE 1=1 AND username=5774874304@tsp17.sprintpcs.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 5339384618@tsp18.sprintpcs.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=42748, old_equipment_id=32783, new_equipment_id=36795, end_date=2018-05-23
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.
NOTICE:  INSERT/UPDATE equipment_warranty: v_nequipid: 36795, start_date=2015-10-21, model id=68
NOTICE:  [rt_oss_rma] Insert/Update for equipment_warranty succeeded. Move on to static IP handling.
NOTICE:  rt_oss_rma: Sucessfully updated new username  
NOTICE:  -----------  calling jbilling_rma ------------------------------------- 
NOTICE:   the sql to call jbilling_rma: SELECT * from oss.rt_jbilling_rma(112 , 68 , 'A10000157E3DEE' , 'A10000157EBB8B' , '779912' , '5339384618@tsp18.sprintpcs.com',42748,'5312')
NOTICE:  rt_oss_rma: Returned from Jbilling: Jbilling RMA: No active line found in jbilling for esn_hex: A10000157E3DEE
 billing_entity_id | old_equip_id |    old_model    | old_sn |          old_username          | new_equip_id |    new_model    | new_sn |                                 rma_so_num                                 | line_id | carrier |            username            |      groupname      | message 
-------------------+--------------+-----------------+--------+--------------------------------+--------------+-----------------+--------+----------------------------------------------------------------------------+---------+---------+--------------------------------+---------------------+---------
               112 |        32783 | Systech 8100ESP | 760478 | 5774874304@tsp17.sprintpcs.com |        36795 | Systech 8110ESP | 779912 | Jbilling RMA: No active line found in jbilling for esn_hex: A10000157E3DEE |   42748 | SPRINT  | 5339384618@tsp18.sprintpcs.com | SERVICE-private_atm | Success
(1 row)





----






-[ RECORD 1 ]-----+-----------------------
value             | A10000157EE728
radius_username   | 4045485418@vzw3g.com
billing_entity_id | 76
name              | B and E Transactions
line_id           | 37372
equipment_id      | 35408
start_date        | 2014-03-09 18:00:00-06
end_date          | 
start_date        | 2014-04-29
end_date          | 
notes             | SO-8347

csctoss=# select * from equipment_warranty where equipment_id = 35408;
-[ RECORD 1 ]-------+-----------------------
equipment_id        | 35408
warranty_start_date | 2014-03-09 18:00:00-06
warranty_end_date   | 2019-03-09 18:00:00-07





