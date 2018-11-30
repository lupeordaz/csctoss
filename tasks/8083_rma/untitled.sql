NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A1000043951158
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 577: ACFN
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  rt_oss_rma:  Serial number found for original esn: A1000036981D4E equip id: 39911
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : A1000036981D4E
NOTICE:  old ip            : 10.81.21.87
NOTICE:  old username      : 4049853138@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_cnione
NOTICE:  old equipment id  : 39911
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : A1000043951158
NOTICE:  new equipment id  : 38677
NOTICE:  new model         : Systech 8100EVE
NOTICE:  carrier           : VZW
NOTICE:  billing entity    : 577
NOTICE:  billing entity nm : ACFN
NOTICE:  new username      : 4048072812@vzw3g.com
NOTICE:  new groupname     : SERVICE-vzwretail_cnione
NOTICE:  static ip?        : t
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 2 rows related to old username(4049853138@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_vzwretail_cnione , priority=50000 WHERE 1=1 AND username=4049853138@vzw3g.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 4048072812@vzw3g.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=40191, old_equipment_id=39911, new_equipment_id=38677, end_date=2018-08-06
 billing_entity_id | old_equip_id | old_model | old_sn | old_username | new_equip_id | new_model | new_sn | rma_so_num | line_id | carrier | username | groupname |
                             message                              
-------------------+--------------+-----------+--------+--------------+--------------+-----------+--------+------------+---------+---------+----------+-----------+
------------------------------------------------------------------
                   |              |           |        |              |              |           |        |            |         |         |          |           |
 Insert new row into ine_equipment with new equipment id for line
(1 row)





vacuum verbose analyze radpostauth;
