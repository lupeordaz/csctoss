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
-- Name: ops_api_modify(text, text, text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_api_modify(text, text, text) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_unique_identifier_type    text := $1 ;
  par_old_value                 text := $2 ;
  par_new_value                 text := $3 ;
  var_equipment_id              integer;
  var_username                  text;
  v_numrows                     integer;
  v_errmsg                      text;

  var_return_row                ops_api_retval%ROWTYPE;

BEGIN

  v_errmsg := 'ERROR - All or some of the input values are null.';
  IF par_unique_identifier_type = ''
               OR par_old_value = ''
               OR par_new_value = '' THEN 

      RAISE EXCEPTION '';
  ELSE 
      -- Validate parameters.
      v_errmsg := 'ERROR - Old value does not exist:  ' || par_old_value;
      SELECT equipment_id INTO var_equipment_id
        FROM unique_identifier
       WHERE unique_identifier_type = par_unique_identifier_type
         AND value = par_old_value ;

      IF NOT FOUND THEN
          RAISE EXCEPTION '' ;
      END IF ;

      -- check to see if MDN and MIN have the same values (only if the input type is MDN/MIN)
      IF par_unique_identifier_type IN ('MDN', 'MIN') THEN

          v_errmsg := 'ERROR - MDN update failed, old value ' || par_old_value || ', new value ' || par_new_value;
          UPDATE csctoss.unique_identifier 
          SET value = par_new_value
          WHERE equipment_id = var_equipment_id
          AND unique_identifier_type = 'MDN'
          AND value = par_old_value ;

          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;

          v_errmsg := 'ERROR - MIN update failed, old value ' || par_old_value || ', new value ' || par_new_value;
          UPDATE csctoss.unique_identifier 
          SET value = par_new_value
          WHERE equipment_id = var_equipment_id
          AND unique_identifier_type = 'MIN'
          AND value = par_old_value ;
      
          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;

          -- Also update the username/usergroup/radcheck tables for the username column
          v_errmsg := 'ERROR - Username ' || var_username || ' does not match with MDN/MIN value.';
          SELECT username INTO var_username
          FROM username
          WHERE (SUBSTR(username,1,10)) = par_old_value; 

          IF NOT FOUND THEN
              RAISE EXCEPTION '' ;
          END IF;
        
          v_errmsg := 'ERROR - Update failed for username:  ' || var_username;
          UPDATE username 
          SET username = replace(var_username, par_old_value, par_new_value)
          WHERE SUBSTR(username,1,10) = par_old_value; 
  	    
          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;
  	   
          v_errmsg := 'ERROR - Update failed for usergroup; username:  ' || var_username;
          UPDATE usergroup
          SET username = replace(var_username, par_old_value, par_new_value)
          WHERE SUBSTR(username,1,10) = par_old_value;
  	   
          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;

          v_errmsg := 'ERROR - Update failed for radcheck; username:  ' || var_username;
          UPDATE radcheck
          SET username = replace(var_username, par_old_value, par_new_value)
          WHERE SUBSTR(username,1,10) = par_old_value;
    
          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;

      ELSE
          -- Update unique identifier value from old to new for other types.
          v_errmsg := 'ERROR - Update failed, unique_identifier_type ' || par_unique_identifier_type || ' value ' || par_new_value;
          UPDATE csctoss.unique_identifier
          SET value = par_new_value
          WHERE equipment_id = var_equipment_id
          AND unique_identifier_type = par_unique_identifier_type
          AND value = par_old_value ;

          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE EXCEPTION '';
          END IF;
      END IF;
  END IF;
  
  var_return_row.result_code := true ;
  var_return_row.error_message := '' ;
  RETURN NEXT var_return_row ;
  RETURN ;

  EXCEPTION
    WHEN raise_exception THEN
      var_return_row.result_code := false;
      var_return_row.error_message := v_errmsg;
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

ALTER FUNCTION csctoss.ops_api_modify(text, text, text) OWNER TO csctoss_owner;

--
-- Name: ops_api_modify(text, text, text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_modify(text, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_modify(text, text, text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_modify(text, text, text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_modify(text, text, text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_modify(text, text, text) TO csctoss_reader;
GRANT ALL ON FUNCTION ops_api_modify(text, text, text) TO PUBLIC;


--
-- PostgreSQL database dump complete
--

