Original Equipment:
Model:WR11-L800
ESN :353238060066510
S/N :419884
Return Tracking # : 1Z7X74R90393381420

New Equipment:

Model:WR11-L800
ESN :353238060192241
S/N :419545
Tracking # :773335385895

--

select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = '353238060066510';
 line_id | equipment_id | start_date | end_date |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+------------+----------+----------------------+--------------+----------+-----------------
   44855 |        42545 | 2017-04-09 |          | 4705327139@vzw3g.com | 00042D06682C | 419884   | 353238060066510
(1 row)


select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = '353238060192241';
 line_id | equipment_id | start_date | end_date |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+------------+----------+----------------------+--------------+----------+-----------------
   46429 |        43381 | 2018-02-14 |          | 4705226374@vzw3g.com | 00042D0666D9 | 419545   | 353238060192241
(1 row)

--
-- Production data
select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = '353238060192241';
 line_id | equipment_id | start_date |  end_date  |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+------------+------------+----------------------+--------------+----------+-----------------
   46429 |        43381 | 2018-02-14 | 2018-09-26 |                      | 00042D0666D9 | 419545   | 353238060192241
   44855 |        43381 | 2018-09-27 |            | 4705226374@vzw3g.com | 00042D0666D9 | 419545   | 353238060192241
(2 rows)


--
-- Failed because end_date = current_date
--



