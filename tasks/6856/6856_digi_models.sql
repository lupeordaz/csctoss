select uis.value as serial_number
      ,em.model_number2
      ,uie.value as esn_hex
  from equipment_model em
  join equipment e ON e.equipment_model_id = em.equipment_model_id
  join unique_identifier uis ON uis.equipment_id = e.equipment_id AND uis.unique_identifier_type = 'SERIAL NUMBER'
  join unique_identifier uie ON uie.equipment_id = e.equipment_id AND uie.unique_identifier_type = 'ESN HEX'
 where em.vendor like '%Digi%'
 order by 1;
