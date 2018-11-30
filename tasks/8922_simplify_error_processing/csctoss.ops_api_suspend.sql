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
-- Name: ops_api_suspend(text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_api_suspend(text) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_esn_hex                   text := $1;
  var_equipment_id              integer;
  var_line_id                   integer;
  var_username                  text;
  var_mdn                       text;
  var_usergroup_id              integer;
  v_numrows                     integer;
  v_errmsg                      text;

  var_return_row                ops_api_retval%ROWTYPE;

BEGIN
  PERFORM public.set_change_log_staff_id (3);

  v_errmsg := 'ERROR:  Input ESN HEX Is Null. Please enter a value.';
  IF par_esn_hex = '' THEN
    RAISE EXCEPTION '';
  END IF;

  -- Validate parameters.
  v_errmsg := 'ERROR:  ESN HEX value does not exist - ' || par_esn_hex;
  SELECT equipment_id INTO var_equipment_id
  FROM unique_identifier
  WHERE unique_identifier_type = 'ESN HEX'
  AND value LIKE par_esn_hex;

  IF NOT FOUND THEN
    RAISE EXCEPTION '' ;
  ELSE
    -- Retrieve MDN and Username values
    SELECT value INTO var_mdn
    FROM unique_identifier
    WHERE unique_identifier_type = 'MDN'
    AND equipment_id = var_equipment_id;

    v_errmsg := 'ERROR:  Username does not exist for the device ' || var_equipment_id;
    SELECT unam.username INTO var_username
    FROM username unam
    WHERE SUBSTR(unam.username,1,10) = var_mdn;

    IF NOT FOUND THEN
      RAISE EXCEPTION '';
    END IF;
  END IF;

  -- To Suspend an assigned device which is not expired
  IF EXISTS (SELECT TRUE 
               FROM line 
              WHERE radius_username LIKE var_username 
                AND line_label LIKE par_esn_hex AND end_date IS NULL) THEN
    IF var_username ~ '@vzw' THEN
      IF NOT EXISTS( SELECT TRUE 
                       FROM usergroup 
                      WHERE username LIKE var_username 
                        AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione') THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
      END IF;

      IF NOT EXISTS( SELECT TRUE 
                       FROM usergroup 
                      WHERE username LIKE var_username 
                        AND groupname LIKE 'userdisconnected') THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'userdisconnected', 3);
      END IF;
    END IF;
  ELSE
    IF EXISTS (SELECT TRUE FROM username WHERE username LIKE var_username) THEN

      IF var_username ~ '@vzw' THEN
        IF NOT EXISTS( SELECT TRUE 
                         FROM usergroup 
                        WHERE username LIKE var_username 
                          AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione' 
                          AND priority = 1) THEN
          INSERT INTO usergroup(username, groupname, priority)
          VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
        END IF;
      ELSE
        IF NOT EXISTS( SELECT TRUE 
                         FROM usergroup 
                        WHERE username LIKE var_username 
                          AND groupname LIKE 'disconnected' 
                          AND priority = 1) THEN
          INSERT INTO usergroup(username, groupname, priority)
	        VALUES (var_username, 'disconnected', 1);
        END IF;
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


ALTER FUNCTION csctoss.ops_api_suspend(text) OWNER TO csctoss_owner;

--
-- Name: ops_api_suspend(text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_suspend(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_suspend(text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_suspend(text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_suspend(text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_suspend(text) TO csctoss_reader;
GRANT ALL ON FUNCTION ops_api_suspend(text) TO PUBLIC;


--
-- PostgreSQL database dump complete
--

