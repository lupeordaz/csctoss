--
-- PostgreSQL database dump
--

-- Dumped from database version 8.0.14
-- Dumped by pg_dump version 9.6.6

SET statement_timeout = 0;
--SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
--SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
--SET escape_string_warning = off;
--SET row_security = off;

SET search_path = csctoss, pg_catalog;


SET search_path = csctoss, pg_catalog;

--
-- Name: ops_api_activate(text, text, text, text, text, text, integer, text, text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_api_activate(text, text, text, text, text, text, integer, text, text) RETURNS ops_api_activate_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;

   var_equipment_id            integer;
   var_receiving_lot_id        integer;
   var_username                text;
   var_groupname               text;
   v_errmsg                    text;
   var_return                  ops_api_activate_retval%ROWTYPE;

BEGIN

  RAISE NOTICE '--- Starting ops_api_activate ---';

  PERFORM public.set_change_log_staff_id(3) ;

  -- Check to see if the parameters are null
  IF par_esn_hex = ''
    OR par_esn_dec = ''
    OR par_mdn = ''
    OR par_min = ''
    OR par_serial_number = ''
    OR par_mac_address = ''
    OR par_equipment_model_id IS NULL
    OR par_carrier = ''
  THEN
      v_errmsg  := 'All or some of the input parameters are NULL or empty';
      RAISE EXCEPTION 'ERROR: No parameters';
  END IF;

  -- Check to see of parameter does not contain a space character
  IF par_esn_hex LIKE '% %'
    OR par_esn_dec LIKE '% %'
    OR par_mdn LIKE '% %'
    OR par_min LIKE '% %'
    OR par_serial_number LIKE '% %'
    OR par_mac_address LIKE '% %'
  THEN
      v_errmsg  := 'All or some of the input parameters contain a space character.';
      RAISE EXCEPTION 'ERROR: Invalid parameter';
  END IF;

  RAISE NOTICE 'Valid parameter count!';

  -- Insert receiving_lot information before inserting equipment details
  var_receiving_lot_id := nextval('csctoss.receiving_lot_receiving_lot_id_seq');
  INSERT INTO receiving_lot (receiving_lot_id, description, receiving_status, purchase_order_date, ship_date, received_date, item_count, vendor)
       VALUES (var_receiving_lot_id, 'Operations API: '||current_date,'OPEN',current_date,current_date,current_date,1,'unknown');

  var_equipment_id := nextval('csctoss.equipment_equipment_id_seq');

  IF EXISTS (SELECT TRUE FROM equipment_model WHERE equipment_model_id = par_equipment_model_id) THEN
    -- Insert equipment details
    IF NOT EXISTS (SELECT TRUE FROM equipment WHERE equipment_id = var_equipment_id) THEN
      INSERT INTO equipment(equipment_id, equipment_type, equipment_model_id, receiving_lot_id, enabled_flag)
           VALUES (var_equipment_id, 'ROUTER', par_equipment_model_id, var_receiving_lot_id, 'TRUE');
    ELSE
      v_errmsg  := 'Equipment_Id ' || var_equipment_id || ' already exists.';
      RAISE EXCEPTION  'ERROR:  Invalid Equipment_Id.' ;
    END IF;

  ELSE
    v_errmsg := 'Equipment Model ID ' || par_equipment_model_id || ' is wrong.';
    RAISE EXCEPTION 'ERROR:  Invalid Equipment Model ID.' ;
  END IF;

  -- Insert equipment details in the equipment_status table
  INSERT INTO equipment_status(equipment_id, equipment_status_type, date_created)
     VALUES (var_equipment_id, 'AVAILABLE-ATLANTA', current_date);

  -- Insert the unique_identifier values in the unique_identifier table for the equipment_id obtained.
  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
       VALUES (var_equipment_id, 'ESN HEX', par_esn_hex, current_date);
  ELSE
    v_errmsg := 'ESN Hex ' || par_esn_hex || ' already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid ESN HEX.';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'ESN DEC' AND value = par_esn_dec) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
       VALUES (var_equipment_id, 'ESN DEC', par_esn_dec, current_date);
  ELSE
    v_errmsg := 'ESN DEC ' || par_esn_dec || ' already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid ESN DEC.';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'MDN' AND value = par_mdn) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
         VALUES (var_equipment_id, 'MDN', par_mdn, current_date);
  ELSE
    v_errmsg := 'MDN ' || par_mdn || ' already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid MDN';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'MIN' AND value = par_min) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
         VALUES (var_equipment_id, 'MIN', par_min, current_date);
  ELSE
    v_errmsg = 'MIN ' || par_min || ' already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid MIN';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'SERIAL NUMBER' AND value = par_serial_number) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
       VALUES (var_equipment_id, 'SERIAL NUMBER', par_serial_number, current_date);
  ELSE
--    v_errmsg := 'SERIAL NUMBER already exists.';
    v_errmsg := 'SERIAL NUMBER ' || par_serial_number || ' already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid SERIAL NUMBER';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM unique_identifier WHERE unique_identifier_type = 'MAC ADDRESS' AND value = par_mac_address) THEN
    INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
       VALUES (var_equipment_id, 'MAC ADDRESS', par_mac_address, current_date);
  ELSE
    v_errmsg := 'MAC ' || par_mac_address || ' Address already exists.';
    RAISE EXCEPTION 'ERROR:  Invalid MAC ADDRESS';
  END IF;

  -- Insert the details of username table
  par_carrier := lower(par_carrier);

  IF par_carrier LIKE 'sprint%' THEN
    par_carrier := (par_carrier) || 'pcs';
    var_username := par_mdn || '@'||par_realm || '.'||par_carrier || '.com';

  ELSIF par_carrier LIKE 'vzw%' THEN
    var_username := par_mdn || '@'||par_realm || '.com';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM username WHERE username = var_username) THEN
    INSERT INTO username(username, billing_entity_id, primary_service, enabled, start_date, end_date, date_created, auth_pod)
       VALUES (var_username, 1, 'TRUE', 'TRUE', current_date, '2999-12-31', current_date, 'FALSE');
  ELSE
    v_errmsg := 'Username ' || var_username || ' already exists in username table.';
    RAISE EXCEPTION 'ERROR:  Invalid Username, username';
  END IF;

  -- Insert the details of radcheck table
  IF NOT EXISTS (SELECT TRUE FROM radcheck WHERE username = var_username) THEN
    IF par_carrier LIKE 'sprint%' THEN
      INSERT INTO radcheck(username, attribute, op, value)
        VALUES (var_username, 'ClearText-Password', ':=', '');
    ELSIF par_carrier LIKE 'vzw%' THEN
      INSERT INTO radcheck(username, attribute, op, value)
        VALUES (var_username, 'Auth-Type', ':=', 'Accept');
    END IF;
  ELSE
    v_errmsg := 'Username ' || var_username || ' already exists in radcheck table.';
    RAISE EXCEPTION 'ERROR:  Invalid Username, radcheck';
  END IF;

  -- Insert the details of usergroup table
  IF par_carrier LIKE 'sprint%' THEN
    var_groupname := 'SERVICE-inventory';
  ELSIF par_carrier LIKE 'vzw%' THEN
    var_groupname := 'SERVICE-vzw_inventory';
  END IF;

  IF NOT EXISTS (SELECT TRUE FROM usergroup WHERE username = var_username) THEN
    INSERT INTO usergroup(username, groupname, priority)
       VALUES (var_username, var_groupname, 50000);
  ELSE
    v_errmsg := 'Username ' || var_username || ' already exists in usergroup table.';
    RAISE EXCEPTION 'ERROR:  Invalid Username, usergroup';
  END IF;

  var_return.result_code := true;
  var_return.error_message := 'SUCCESS:  sevice is activated.' ;
  RETURN var_return ;

EXCEPTION
        WHEN raise_exception THEN
            var_return.result_code := false;
            var_return.error_message:=v_errmsg;
            RAISE NOTICE 'rt_oss_rma: when raise_exception:  % ',v_errmsg;
            RETURN var_return;
0
--        WHEN others THEN
--            v_errmsg := 'Unknown error!';
--            var_return.result_code := false;
--            var_return.error_message := v_errmsg;
--            RAISE NOTICE 'ERROR:  Unknown Error! ';
--            RETURN var_return;
END;
$_$;


ALTER FUNCTION csctoss.ops_api_activate(text, text, text, text, text, text, integer, text, text) OWNER TO csctoss_owner;

COMMENT ON FUNCTION ops_api_activate(text, text, text, text, text, text, integer, text, text) IS 'Activate Function to insert equipment, unique_identifiers, username details.';

--
-- PostgreSQL database dump complete
--

