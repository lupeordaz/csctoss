
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
	left outer join dblink((select * from fetch_csctmon_conn()),
   where uis.value = 'A10111';

 line_id | equipment_id |   radius_username    |     mac      | serialno |     esn_hex      
---------+--------------+----------------------+--------------+----------+------------------
   45127 |        42709 | 4704212268@vzw3g.com | 00804412CEDA | A10111   | 00A1000051C2DCE0
(1 row)



select framedipaddress from dblink((select * from fetch_csctmon_conn()),
'select username
      ,framedipaddress
      ,acctstarttime 
  from master_radacct 
 where username = ''4704212268@vzw3g.com''
 order by acctstarttime desc limit 1
') AS mrac (username text, framedipaddress text, acctstarttime text);



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
	left outer join dblink((select * from fetch_csctmon_conn()),
							  'select username
							         ,framedipaddress
							         ,acctstarttime 
						         from master_radacct 
						        where username = ''4704212268@vzw3g.com''
						        order by acctstarttime desc limit 1
							  ') AS mrac (username text, framedipaddress text, acctstarttime text);
	  ON (line.radius_username = mrac.username)
   where uis.value = 'A10111';




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
    left outer join dblink((select * from fetch_csctmon_conn()),
                                      'select username
                                             ,framedipaddress
                                             ,acctstarttime 
                                     from master_radacct 
                                    where username = mrac.radius_username
                                    order by acctstarttime desc limit 1
                                      ') AS mrac (username text, framedipaddress text, acctstarttime text) 
      ON (l.radius_username = mrac.username)
   where uis.value = 'A10111';

ERROR:  sql error
DETAIL:  ERROR:  missing FROM-clause entry for table "l" at character 149

-- 20180705

 select l.line_id
        ,le.equipment_id
        ,l.radius_username
    from line_equipment le
    join line l on l.line_id = le.line_id
   where le.equipment_id = 42709;
 line_id | equipment_id |   radius_username    
---------+--------------+----------------------
   45127 |        42709 | 4704212268@vzw3g.com
(1 row)


select username, framedipaddress from dblink((select * from fetch_csctmon_conn()),
'select username
      ,framedipaddress
      ,acctstarttime 
  from master_radacct 
 where username = ''4704212268@vzw3g.com''
 order by acctstarttime desc limit 1
') AS mrac (username text, framedipaddress text, acctstarttime text);
       username       | framedipaddress 
----------------------+-----------------
 4704212268@vzw3g.com | 10.81.149.147
(1 row)


select l.line_id
        ,le.equipment_id
        ,l.radius_usernamel
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
        ,mrac.framedipaddress
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
    left outer join dblink((select * from fetch_csctmon_conn()),
                                          'select username
                                                 ,framedipaddress
                                                 ,acctstarttime
                                         from master_radacct
                                        where username = ''4704212268@vzw3g.com''
                                        order by acctstarttime desc limit 1
                                          ') AS mrac (username text, framedipaddress text, acctstarttime text)
      on (l.radius_username = mrac.username)
   where uis.value = 'A10111';
 line_id | equipment_id |   radius_username    |     mac      | serialno |     esn_hex      | framedipaddress 
---------+--------------+----------------------+--------------+----------+------------------+-----------------
   45127 |        42709 | 4704212268@vzw3g.com | 00804412CEDA | A10111   | 00A1000051C2DCE0 | 10.81.149.147
(1 row)





