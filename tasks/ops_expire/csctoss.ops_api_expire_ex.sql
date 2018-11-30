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
-- Name: ops_api_expire_ex(text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--
CREATE OR REPLACE FUNCTION ops_api_expire_ex(text) RETURNS SETOF ops_api_expire_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
  var_return_row                ops_api_expire_retval%ROWTYPE;
BEGIN
  select * INTO var_return_row from ops_api_expire_ex($1, false);
  RETURN NEXT var_return_row;
  RETURN;

END;
$_$;

ALTER FUNCTION csctoss.ops_api_expire_ex(text) OWNER TO csctoss_owner;

--
-- Name: ops_api_expire_ex(text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_expire_ex(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_expire_ex(text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO PUBLIC;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_reader;
--

CREATE OR REPLACE FUNCTION ops_api_expire_ex(text, boolean) RETURNS SETOF ops_api_expire_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_esn_hex                   text := $1;
  par_bypass_jbilling           boolean := $2;
  var_equipment_id              integer;
  var_line_id                   integer;
  var_username                  text;
  --var_mdn                     text;
  var_static_ip                 text;
  var_usergroup_id              integer;
  var_conn_string               text;
  var_sql                       text;
  var_return_row                ops_api_expire_retval%ROWTYPE;

BEGIN
  PERFORM public.set_change_log_staff_id (3);

  IF par_esn_hex IS NULL OR par_esn_hex = '' THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Input ESN HEX is NULL or empty. Please enter a value.';
    RETURN NEXT var_return_row;
    RETURN;
  ELSE
    -- Validate parameters.
    SELECT equipment_id INTO var_equipment_id
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value = par_esn_hex;

    IF NOT FOUND THEN
      var_return_row.result_code := false;
      var_return_row.error_message := 'ESN HEX value does not exists.';
      RETURN NEXT var_return_row;
      RETURN;
    END IF;
  END IF;

  -- Retrieve line_id using equipment_id
  SELECT line_id INTO var_line_id
  FROM line_equipment
  WHERE equipment_id = var_equipment_id
  AND end_date IS NULL;

  SELECT radius_username INTO var_username FROM line WHERE line_id = var_line_id;
  IF NOT FOUND THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Username does not exists for the device.';
    RETURN NEXT var_return_row;
    RETURN;
  END IF;

  -- Deallocate static IP address and delete radreply records.
  IF EXISTS (SELECT TRUE FROM radreply WHERE username LIKE var_username) THEN
    SELECT value INTO var_static_ip
    FROM radreply
    WHERE username = var_username
    AND attribute = 'Framed-IP-Address';

    IF EXISTS ( SELECT TRUE FROM static_ip_pool WHERE static_ip = var_static_ip AND line_id = var_line_id ) THEN
      UPDATE static_ip_pool SET is_assigned = 'FALSE', line_id = NULL
      WHERE static_ip = var_static_ip AND line_id = var_line_id;
    END IF;

    DELETE FROM radreply WHERE username = var_username;
    --DELETE FROM radcheck WHERE username = var_username;

  END IF;

  -- To Suspend an assigned device which is not expired
  IF (SELECT TRUE FROM username WHERE username LIKE var_username) THEN

    IF var_username ~ '@vzw' THEN
      IF NOT EXISTS( SELECT TRUE FROM usergroup WHERE username LIKE var_username AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione') THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
      END IF;
    ELSE
      IF NOT EXISTS( SELECT TRUE FROM usergroup WHERE username LIKE var_username AND groupname LIKE '%disconnected' AND priority = 1) THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'disconnected', 1);
      END IF;
    END IF;

  END IF;

  IF EXISTS ( SELECT TRUE FROM line_equipment WHERE line_id = var_line_id AND end_date IS NULL) THEN
    UPDATE line_equipment SET end_date = current_date
    WHERE line_id = var_line_id
    AND equipment_id = var_equipment_id;

    -- UPDATE line end_date too
    UPDATE line SET end_date = current_date,
                    radius_username = null,
                    line_label = null
    WHERE line_id = var_line_id;
    IF NOT FOUND THEN
      var_return_row.result_code := false;
      var_return_row.error_message := 'Updating line.end_date failed.';
      RETURN NEXT var_return_row;
      RETURN;
    END IF;

  ELSE
    var_return_row.result_code := false;
    var_return_row.error_message := 'Line associated to the equipment has already expired.';
    RETURN NEXT var_return_row;
    RETURN;
  END IF ;


  /*connect to jbilling to cancel*/
  IF (par_bypass_jbilling = FALSE) THEN
    var_sql := 'SELECT * FROM oss.archive_equipment(' || quote_literal(par_esn_hex) || ')';
    FOR var_return_row IN
      SELECT * FROM public.dblink(fetch_jbilling_conn(), var_sql) AS rec_type (result_code boolean)
    LOOP
      IF (var_return_row.result_code = 'FALSE') THEN
        var_return_row.result_code := false;
        var_return_row.error_message := 'Jbilling Provisioning Failed.';
        RETURN NEXT var_return_row;
        RETURN;
      END IF;
    END LOOP;
  END IF;
  
  var_return_row.result_code := true;
  var_return_row.error_message := 'Line associated to the equipment is now expired';
  RETURN NEXT var_return_row;
  RETURN;

EXCEPTION
  WHEN OTHERS THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Exception: Unknown exception happened.';
    RETURN NEXT var_return_row;
    RETURN;
END;
$_$;


ALTER FUNCTION csctoss.ops_api_expire_ex(text) OWNER TO csctoss_owner;

--
-- Name: ops_api_expire_ex(text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_expire_ex(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_expire_ex(text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO PUBLIC;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_expire_ex(text) TO csctoss_reader;


--
-- PostgreSQL database dump complete
--

