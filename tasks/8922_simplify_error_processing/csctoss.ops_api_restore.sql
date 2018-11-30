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

--
-- Name: ops_api_restore(text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_api_restore(text) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_esn_hex                   text := $1;
  var_equipment_id              integer;
  var_username                  text;
  var_mdn                       text;
  var_return_row                ops_api_retval%ROWTYPE;
  v_errmsg                      text;

BEGIN
  PERFORM public.set_change_log_staff_id (3);

  v_errmsg := 'ERROR:  Input ESN HEX Is Null. Please enter a value.';
  IF par_esn_hex = '' THEN
    RAISE EXCEPTION '';
  ELSE
    -- Validate parameters.
    v_errmsg := 'ERROR:  ESN HEX value does not exist.';
    SELECT equipment_id INTO var_equipment_id
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value LIKE par_esn_hex;

    IF NOT FOUND THEN
      RAISE EXCEPTION '' ;
    ELSE
      /*
      --Check if active line_id is mapped to the equipment_id
      IF EXISTS (SELECT line_id FROM line_equipment WHERE equipment_id = var_equipment_id AND end_date IS NOT NULL) THEN
        RAISE EXCEPTION 'Line_ID is inactive and hence the device cannot be restored.';
      END IF;
      */
  
      -- Retrieve MDN and Username values
      SELECT value INTO var_mdn
      FROM unique_identifier
      WHERE unique_identifier_type = 'MDN'
      AND equipment_id = var_equipment_id;
  
      SELECT unam.username INTO var_username
      FROM username unam
      WHERE SUBSTR(unam.username,1,10) = var_mdn;
    END IF;

    -- To Restore a suspended device
    v_errmsg := 'ERROR:  Cannot restore a canceled device.';
    IF EXISTS(SELECT TRUE 
                FROM unique_identifier 
                JOIN line_equipment le USING (equipment_id) 
               WHERE value = var_mdn 
                 AND le.end_date IS NULL) THEN
      v_errmsg := 'ERROR:  Device is not suspended and can not be restored.';
      IF EXISTS( SELECT TRUE 
                   FROM usergroup 
                  WHERE username LIKE var_username 
                    AND (groupname LIKE 'disconnected' OR 
                         groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione')) THEN
        DELETE FROM usergroup
        WHERE username LIKE var_username
        AND groupname LIKE 'disconnected';

        DELETE FROM usergroup
        WHERE username LIKE var_username
        AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione';
  
      ELSE
        RAISE EXCEPTION '';
      END IF;
    ELSE
      RAISE EXCEPTION '';
    END IF;
  END IF;

  var_return_row.result_code := true ;
  var_return_row.error_message := 'Device is restored.' ;
  RETURN NEXT var_return_row ;
  RETURN ;

  EXCEPTION
    WHEN raise_exception THEN
      var_return_row.result_code := false;
      var_return_row.error_message:=v_errmsg;
      RETURN NEXT var_return_row;
      RETURN;

    WHEN others THEN
      var_return_row.result_code := false;
      var_return_row.error_message:=v_errmsg;
      RAISE NOTICE 'OTHER EXCEPTION:  %', v_errmsg;
      RETURN NEXT var_return_row;
      RETURN;

END ;
$_$;


ALTER FUNCTION csctoss.ops_api_restore(text) OWNER TO csctoss_owner;

--
-- Name: ops_api_restore(text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_restore(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_restore(text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_restore(text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_restore(text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_restore(text) TO csctoss_reader;
GRANT ALL ON FUNCTION ops_api_restore(text) TO PUBLIC;


--
-- PostgreSQL database dump complete
--

