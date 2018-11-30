select p.line_id
      ,p.radius_username
      ,p.esn_hex
      ,p.serial_number
      ,ui.equipment_id
      ,uim.value as mac_addr
  from portal_active_lines_vw p
  join unique_identifier ui ON ui.value = p.esn_hex AND ui.unique_identifier_type = 'ESN HEX'
  join unique_identifier uim ON uim.equipment_id = ui.equipment_id
 where p.is_connected = 'YES'
   and uim.unique_identifier_type = 'MAC ADDRESS'
 order by 2,1;
