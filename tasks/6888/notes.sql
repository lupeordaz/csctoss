

select * from ops_api_expire_ex('A100001578C862');
 result_code |             error_message              
-------------+----------------------------------------
 f           | Exception: Unknown exception happened.
(1 row)

csctoss=# 


select le.line_id
  from equipment e
  join unique_identifier uie
       on e.equipment_id = uie.equipment_id
       and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis
       on e.equipment_id = uis.equipment_id
       and uis.unique_identifier_type = 'SERIAL NUMBER'
  join equipment_model em
       on e.equipment_model_id = em.equipment_model_id
 where uie.value = 'A10000157EC0D3';




select le.line_id
      ,uis.value as serial_number
      ,uie.value as esn_hex
      ,ui.equipment_id
  from line_equipment le
  join unique_identifier ui
       on le.equipment_id = ui.equipment_id
  join unique_identifier uie
       on ui.equipment_id = uie.equipment_id
       and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis
       on ui.equipment_id = uis.equipment_id
       and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uie.value = 'A10000157EC0D3';