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
-- Name: update_unique_identifier_value(integer, text, text, text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION update_unique_identifier_value(integer, text, text, text) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_equipment_id              int  := $1 ;
  par_unique_identifier_type    text := $2 ;
  par_old_value                 text := $3 ;
  par_new_value                 text := $4 ;
  v_numrows                     integer;
  var_return_row                ops_api_retval%ROWTYPE;

  v_errmsg                      text;

BEGIN

  PERFORM public.set_change_log_staff_id(3) ;

  -- Validate parameters.
  PERFORM true
    FROM unique_identifier
   WHERE equipment_id = par_equipment_id
     AND unique_identifier_type = par_unique_identifier_type
     AND value = par_old_value ;

  IF NOT FOUND THEN
    v_errmsg := 'Old value does not exist.';
    RAISE EXCEPTION '';
  END IF ;

  IF ( SELECT TRUE 
         FROM unique_identifier 
        WHERE unique_identifier_type = par_unique_identifier_type
          AND value = par_new_value ) THEN
    v_errmsg := 'Unique identifier type ' || par_unique_identifier_type || ' with value ' || par_new_value || ' already exists';
    RAISE EXCEPTION '';
  END IF;

  -- Just update unique identifier value from old to new.
  UPDATE csctoss.unique_identifier
     SET value = par_new_value
   WHERE equipment_id = par_equipment_id
     AND unique_identifier_type = par_unique_identifier_type
     AND value = par_old_value ;

  GET DIAGNOSTICS v_numrows = ROW_COUNT;
  IF v_numrows = 0 THEN
    v_errmsg := 'Update Failed!';
    RAISE EXCEPTION '';
  END IF;

  var_return_row.result_code := true ;
  var_return_row.error_message := 'Successful Update!' ;
  RETURN NEXT var_return_row ;
  RETURN ;

EXCEPTION
  WHEN raise_exception THEN
    var_return_row.result_code := false;
    var_return_row.error_message:=v_errmsg;
    RAISE NOTICE 'rt_oss_rma: when raise_exception:  % ',v_errmsg;
    RETURN NEXT var_return_row;
    RETURN;

  WHEN others THEN
    v_errmsg := 'Unknown error!';
    var_return_row.result_code := false;
    var_return_row.error_message := v_errmsg;
    RAISE NOTICE 'OTHER EXCEPTION:  %', v_errmsg;
    RETURN NEXT var_return_row;
    RETURN;

END ;
$_$;

ALTER FUNCTION csctoss.update_unique_identifier_value(integer, text, text, text) OWNER TO csctoss_owner;
--
-- Name: FUNCTION update_unique_identifier_value(integer, text, text, text); Type: COMMENT; Schema: csctoss; Owner: csctoss_owner
--

COMMENT ON FUNCTION update_unique_identifier_value(integer, text, text, text) IS 'Function to update unique_identifier.value.';

--
-- Name: update_unique_identifier_value(integer, text, text, text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION update_unique_identifier_value(integer, text, text, text) FROM PUBLIC;
REVOKE ALL ON FUNCTION update_unique_identifier_value(integer, text, text, text) FROM csctoss_owner;
GRANT ALL ON FUNCTION update_unique_identifier_value(integer, text, text, text) TO csctoss_owner;
GRANT ALL ON FUNCTION update_unique_identifier_value(integer, text, text, text) TO PUBLIC;
--
-- PostgreSQL database dump complete
--

