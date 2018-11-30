-- Function: update_mac_addr(text)

-- DROP FUNCTION update_mac_addr(text);

CREATE OR REPLACE FUNCTION update_mac_addr()
  RETURNS int AS
$BODY$
DECLARE
  var_mac_addr_row                  RECORD;
  var_return_code             int;

BEGIN

var_ip_desc = $1;
RAISE NOTICE 'var_ip_desc=%', var_ip_desc;

FOR var_mac_addr_row IN
select a.equip_id
      ,a.serial_no
      ,uis.value
      ,a.mac_addr
      ,uie.value
  from temp_mac_addr_correct a
  join unique_identifier uis on (uis.equipment_id = a.equip_id and uis.unique_identifier_type = 'SERIAL NUMBER')
  join unique_identifier uie on (uie.equipment_id = a.equip_id and uie.unique_identifier_type = 'MAC ADDRESS') ;
    LOOP
      var_return_row.id = var_ip_row.id;
      var_return_row.static_ip = var_ip_row.static_ip;
      var_return_row.carrier_id = var_ip_row.carrier_id;
      var_return_row.carrier_name = var_ip_row.carrier_name;
      var_return_row.groupname = var_ip_row.groupname;
      var_return_row.billing_entity_id = var_ip_row.billing_entity_id;
      var_return_row.billing_name = var_ip_row.billing_name;
      RETURN NEXT var_return_row;
   END LOOP;
              
RAISE NOTICE 'Finished Function';
RETURN;

END ;
$BODY$
  LANGUAGE plpgsql STABLE SECURITY DEFINER;
ALTER FUNCTION update_mac_addr(text)
  OWNER TO csctoss_owner;
