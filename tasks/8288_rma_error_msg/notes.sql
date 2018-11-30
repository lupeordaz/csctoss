#testoss01

Existing line/equipment

select l.line_id                                                         
      ,le.equipment_id
      ,l.radius_username
      ,uim.value as mac
      ,uis.value as serialno
      ,uie.value as esn_hex
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uie.value = 'A1000036981EF8';
 line_id | equipment_id |   radius_username    |     mac      | serialno |    esn_hex     
---------+--------------+----------------------+--------------+----------+----------------
   47095 |        39985 | 4705720444@vzw3g.com | 00804410692D | 771951   | A1000036981EF8
   40649 |        39985 |                      | 00804410692D | 771951   | A1000036981EF8
   40242 |        39985 |                      | 00804410692D | 771951   | A1000036981EF8
(3 rows)

Replacement

select l.line_id                                                         
        ,l.radius_username
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = 'A1000036981E50';
 line_id |   radius_username    | equipment_id | start_date |  end_date  |     mac      | serialno |    esn_hex     
---------+----------------------+--------------+------------+------------+--------------+----------+----------------
   46569 |                      |        35566 | 2018-03-12 | 2018-08-09 | 008044115337 | 876885   | A1000036981E50
   36020 | 4047090618@vzw3g.com |        35566 | 2013-09-24 | 2017-12-19 | 008044115337 | 876885   | A1000036981E50
(2 rows)


select * from line_equipment where equipment_id = 35566 and end_date = '2018-08-09';
 line_id | equipment_id | start_date |  end_date  | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+------------+---------------------------+-----------+--------------+--------------
   46569 |        35566 | 2018-03-12 | 2018-08-09 |                       181 |           |              | 
(1 row)


begin;

select public.set_change_log_staff_id(3);

update line_equipment
   set end_date = '2018-08-22'
 where equipment_id = 35566
   and end_date = current_date;

select * from rt_oss_rma('A1000036981EF8','A1000036981E50', '125', true);

rollback;


csctoss=# \x
Expanded display is on.
csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
-[ RECORD 1 ]-----------+--
set_change_log_staff_id | 3

csctoss=# update line_equipment
csctoss-#    set end_date = '2018-08-22'
csctoss-#  where equipment_id = 35566
csctoss-#    and end_date = current_date;
UPDATE 0
csctoss=# select * from rt_oss_rma('A1000036981EF8','A1000036981E50', '125', true);
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A1000036981E50
NOTICE:  TEST FAILED: Replacement ESN cannot have todays date as end_date in line_equipment table
-[ RECORD 1 ]-----+----------------------------------------------------------------------------
billing_entity_id | 
old_equip_id      | 
old_model         | 
old_sn            | 
old_username      | 
new_equip_id      | 
new_model         | 
new_sn            | 
rma_so_num        | 
line_id           | 
carrier           | 
username          | 
groupname         | 
message           | Replacement ESN cannot have todays date as end_date in line_equipment table

csctoss=# rollback;
ROLLBACK
csctoss=# 


