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
-- Name: ops_change_static_ip(integer, text, text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_change_static_ip(integer, text, text) RETURNS ops_api_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
  par_line_id                   integer := $1;
  par_old_ip                    text := $2;
  par_new_ip                    text := $3;
  var_username                  text;
  var_old_rad_reply_id          integer;
  var_static_ip_pool_id_old     integer;
  var_static_ip_pool_id_new     integer;
  v_numrows                     integer;
  var_return_row                ops_api_retval%ROWTYPE;

  v_errmsg                      text;  

BEGIN

  IF par_line_id IS NULL
    OR par_old_ip IS NULL
    OR par_new_ip IS NULL
  THEN
      v_errmsg  := 'All or some of the input parameters are NULL or empty';
      RAISE EXCEPTION 'ERROR: No parameters';
  END IF;

  PERFORM public.set_change_log_staff_id(3);

  -- Get radius_username by line_id
  SELECT radius_username INTO var_username
  FROM line
  WHERE line_id = par_line_id
  AND end_date IS NULL
  LIMIT 1;

  IF NOT FOUND THEN
      v_errmsg := 'ERROR: radius_username not found on line table. [line_id=' || par_line_id || ']';
      RAISE EXCEPTION '';
  END IF;

  -- Get id of old IP
  SELECT id INTO var_old_rad_reply_id
  FROM radreply
  WHERE username = var_username
  AND attribute = 'Framed-IP-Address'
  AND value = par_old_ip
  LIMIT 1;

  IF NOT FOUND THEN
      v_errmsg := 'ERROR: Old IP address was not assigned in radreply table.';
      RAISE EXCEPTION '';
  END IF;

  -- Get id of static_ip_pool for new IP
  SELECT id INTO var_static_ip_pool_id_new
  FROM  static_ip_pool
  WHERE static_ip = par_new_ip
  AND is_assigned = false
  AND line_id IS NULL
  LIMIT 1
  FOR UPDATE;

  IF NOT FOUND THEN
      v_errmsg := 'ERROR: New IP address was not retrieved from static_ip_pool table.';
      RAISE EXCEPTION '';
  END IF;

  -- Get id of static_ip_pool for old IP
  SELECT id INTO var_static_ip_pool_id_old
  FROM  static_ip_pool
  WHERE static_ip = par_old_ip
  AND line_id IS NOT NULL
  LIMIT 1
  FOR UPDATE;

  IF NOT FOUND THEN
      v_errmsg := 'ERROR: Old IP address was not retrieved from static_ip_pool table.';
      RAISE EXCEPTION '';
  END IF;

  IF var_static_ip_pool_id_new IS NULL AND par_new_ip NOT LIKE '166.%' THEN
    v_errmsg := 'ERROR: New IP address is not available in static_ip_pool table.';
    RAISE EXCEPTION '';
  ELSE
    IF var_static_ip_pool_id_old IS NULL AND par_old_ip NOT LIKE '166.%' THEN
      v_errmsg := 'ERROR: Could not find old IP address in static_ip_pool table.';
      RAISE EXCEPTION '';
    ELSE
      --update old pool entry
      IF par_old_ip NOT LIKE '166.%' THEN
        v_errmsg := 'ERROR: Failure in update of old static_ip_pool';
        UPDATE static_ip_pool
           SET is_assigned = false
              ,line_id = NULL
         WHERE id = var_static_ip_pool_id_old
           AND static_ip = par_old_ip;

        GET DIAGNOSTICS v_numrows = ROW_COUNT;
        IF v_numrows = 0 THEN
            RAISE EXCEPTION '';
        END IF;

      END IF;

      --update new pool entry
      IF par_new_ip NOT LIKE '166.%' THEN
        v_errmsg := 'ERROR: Failure in update of new static_ip_pool';
        UPDATE static_ip_pool
           SET is_assigned = true
              ,line_id = par_line_id
         WHERE static_ip = par_new_ip;

        GET DIAGNOSTICS v_numrows = ROW_COUNT;
        IF v_numrows = 0 THEN
            RAISE EXCEPTION '';
        END IF;
      END IF;

      --update radreply
      v_errmsg := 'ERROR: Failure in update of new static_ip_pool';
      UPDATE radreply
         SET value = par_new_ip
       WHERE username = var_username
        AND id  = var_old_rad_reply_id;

      GET DIAGNOSTICS v_numrows = ROW_COUNT;
      IF v_numrows = 0 THEN
          RAISE EXCEPTION '';
      END IF;
    END IF;
  END IF;

  v_errmsg := 'Static IP address has been changed from ' || par_old_ip || ' to ' || par_new_ip || ' for line_id=' || par_line_id;

  var_return_row.result_code := true;
  var_return_row.error_message := v_errmsg;
  RETURN var_return_row;

EXCEPTION
  WHEN raise_exception THEN
      var_return_row.result_code := false;
      var_return_row.error_message:=v_errmsg;
      RAISE NOTICE 'rt_oss_rma: when raise_exception:  % ',v_errmsg;
      RETURN var_return_row;

  WHEN others THEN
      v_errmsg := 'Unknown error!';
      var_return_row.result_code := false;
      var_return_row.error_message := v_errmsg;
      RAISE NOTICE 'ERROR:  Unknown Error! ';
      RETURN var_return_row;
END;
$_$;


ALTER FUNCTION csctoss.ops_change_static_ip(integer, text, text) OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

