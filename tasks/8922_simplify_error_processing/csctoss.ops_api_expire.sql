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
-- Name: ops_api_expire(text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--
CREATE OR REPLACE FUNCTION ops_api_expire(text) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
    var_return_row                ops_api_retval%ROWTYPE;
BEGIN
    select * INTO var_return_row from ops_api_expire($1, true);
    RETURN NEXT var_return_row;
    RETURN;

END;
$_$;

ALTER FUNCTION csctoss.ops_api_expire(text) OWNER TO csctoss_owner;

REVOKE ALL ON FUNCTION ops_api_expire(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_expire(text) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire(text) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire(text) TO PUBLIC;
GRANT ALL ON FUNCTION ops_api_expire(text) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_expire(text) TO csctoss_reader;
--

CREATE OR REPLACE FUNCTION ops_api_expire(text, boolean) RETURNS SETOF ops_api_retval
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
    v_numrows                     integer;
    var_return_row                ops_api_retval%ROWTYPE;

    v_errmsg                      text;

BEGIN
    PERFORM public.set_change_log_staff_id (3);

    v_errmsg := 'ERROR:  Input ESN HEX Is Null. Please enter a value.';
    IF par_esn_hex = '' THEN
        RAISE EXCEPTION '';
    ELSE
        -- Validate parameters.
        v_errmsg := 'ERROR:  ESN HEX value doesnt exist.';
        SELECT equipment_id INTO var_equipment_id
        FROM unique_identifier
        WHERE unique_identifier_type = 'ESN HEX'
        AND value = par_esn_hex;

        IF NOT FOUND THEN
            RAISE EXCEPTION '';
        END IF;
    END IF;

    RAISE NOTICE 'Equipment id: %', var_equipment_id;
    -- Retrieve line_id using equipment_id
    SELECT line_id INTO var_line_id
      FROM line_equipment
     WHERE equipment_id = var_equipment_id
       AND end_date IS NULL;

    v_errmsg := 'ERROR:  Username does not exist for this device';
    SELECT radius_username INTO var_username 
      FROM line 
     WHERE line_id = var_line_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION '';
    END IF;

    RAISE NOTICE 'line_id: %', var_line_id;
    RAISE NOTICE 'radius_username: %', var_username;
    -- Deallocate static IP address and delete radreply records.
    IF EXISTS (SELECT TRUE FROM radreply WHERE username LIKE var_username) THEN
        v_errmsg := 'ERROR:  Framed-IP-Address does not exist in RADREPLY for this device';
        SELECT value INTO var_static_ip
        FROM radreply
        WHERE username = var_username
        AND attribute = 'Framed-IP-Address';

        IF NOT FOUND THEN
            RAISE EXCEPTION '';
        END IF;

        RAISE NOTICE 'var_static_ip: %', var_static_ip;
        IF EXISTS ( SELECT TRUE FROM static_ip_pool WHERE static_ip = var_static_ip AND line_id = var_line_id ) THEN
            v_errmsg := 'ERROR:  Update failed for static_ip_pool: %' || var_static_ip;
            UPDATE static_ip_pool 
               SET is_assigned = 'FALSE'
                  ,line_id = NULL
             WHERE static_ip = var_static_ip 
               AND line_id = var_line_id;

            GET DIAGNOSTICS v_numrows = ROW_COUNT;
            IF v_numrows = 0 THEN
                RAISE EXCEPTION '';
            END IF;
        END IF;

        DELETE FROM radreply WHERE username = var_username;
    END IF;

    -- To suspend an assigned device which is not expired
    IF (SELECT TRUE FROM username WHERE username LIKE var_username) THEN

        IF var_username ~ '@vzw' THEN
            IF NOT EXISTS( SELECT TRUE 
                             FROM usergroup 
                            WHERE username LIKE var_username 
                              AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione') THEN

                v_errmsg := 'ERROR:  Insert failed for usergroup, username:  ' || var_username;
                INSERT INTO usergroup(username, groupname, priority)
                VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);

                GET DIAGNOSTICS v_numrows = ROW_COUNT;
                IF v_numrows = 0 THEN
                    RAISE EXCEPTION '';
                END IF;
                RAISE NOTICE 'VZW Username % inserted into usergroup.';
            END IF;
        ELSE
            IF NOT EXISTS( SELECT TRUE 
                             FROM usergroup 
                            WHERE username LIKE var_username 
                              AND groupname LIKE '%disconnected' 
                              AND priority = 1) THEN

                v_errmsg := 'ERROR2:  Insert failed for usergroup, username:  ' || var_username;
                INSERT INTO usergroup(username, groupname, priority)
                VALUES (var_username, 'disconnected', 1);

                GET DIAGNOSTICS v_numrows = ROW_COUNT;
                IF v_numrows = 0 THEN
                    RAISE EXCEPTION '';
                END IF;
                RAISE NOTICE 'Non VZW Username % inserted into usergroup.';
            END IF;
        END IF;
    END IF;

    v_errmsg := 'ERROR:  Line associated to the equipment has already expired';
    IF EXISTS ( SELECT TRUE 
                  FROM line_equipment 
                 WHERE line_id = var_line_id 
                   AND end_date IS NULL) THEN
 
        v_errmsg := 'ERROR:  Update Failed for line_equipment:  ' || var_equipment_id;
        UPDATE line_equipment SET end_date = current_date
        WHERE line_id = var_line_id
        AND equipment_id = var_equipment_id;

        GET DIAGNOSTICS v_numrows = ROW_COUNT;
        IF v_numrows = 0 THEN
            RAISE EXCEPTION '';
        END IF;

        -- UPDATE line end_date too
        v_errmsg := 'ERROR:  Update Failed for line:  ' || var_line_id;
        UPDATE line
        SET end_date = current_date,
            radius_username = null,
            line_label = null
        WHERE line_id = var_line_id;

        GET DIAGNOSTICS v_numrows = ROW_COUNT;
        IF v_numrows = 0 THEN
            RAISE EXCEPTION '';
        END IF;
    ELSE
        RAISE EXCEPTION '' ;
    END IF ;

    /*connect to jbilling to cancel*/
    IF (par_bypass_jbilling = FALSE) THEN
        v_errmsg := 'ERROR:  Jbilling Provisioning Failed.';
        var_sql := 'select * from oss.archive_equipment('||quote_literal(par_esn_hex)||')';
        FOR var_return_row IN
            SELECT * FROM public.dblink(fetch_jbilling_conn(), var_sql) AS rec_type (result_code boolean)
        LOOP
            IF (var_return_row.result_code = 'FALSE') THEN
                RAISE EXCEPTION '';
            END IF;
        END LOOP;
    END IF;

    var_return_row.result_code := 'true';
    var_return_row.error_message := 'Line associated to the equipment is now expired';
    RETURN NEXT var_return_row;
    RETURN;

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

END;
$_$;


ALTER FUNCTION csctoss.ops_api_expire(text, boolean) OWNER TO csctoss_owner;

--
-- Name: ops_api_expire(text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION ops_api_expire(text, boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION ops_api_expire(text, boolean) FROM csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire(text, boolean) TO csctoss_owner;
GRANT ALL ON FUNCTION ops_api_expire(text, boolean) TO PUBLIC;
GRANT ALL ON FUNCTION ops_api_expire(text, boolean) TO csctoss_test;
GRANT ALL ON FUNCTION ops_api_expire(text, boolean) TO csctoss_reader;


--
-- PostgreSQL database dump complete
--

