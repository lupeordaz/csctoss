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
-- Name: ops_get_firmware_status(text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION ops_get_firmware_status(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
  par_firmware          text := $1;

  var_firmware_version  text;
  var_result            text;
  var_msg               text;
  rec_firmware          record;

BEGIN
--====================================================================--
--CHECK PARAMS
--====================================================================--
  IF par_firmware IS NULL THEN
    var_msg = 'Not Current';
  END IF; 

--====================================================================--
--Check connection status 
--====================================================================--
  IF (par_firmware IS NOT NULL) THEN
    IF (par_firmware = '') THEN
      var_msg = 'Not Current';
    ELSE
      IF par_firmware ~ ',' THEN
        var_firmware_version = substr(par_firmware, 1, strpos(par_firmware, ',') - 1);
        var_result = 0;
        FOR rec_firmware IN 
          select device_version, default_status
            from firmware
           where device_version ~ ','
        LOOP
          IF var_firmware_version = substr(rec_firmware.device_version, 1, strpos(rec_firmware.device_version, ',') - 1) THEN
            var_result = rec_firmware.default_status;
            EXIT;
          END IF;
        END LOOP ;
      ELSE
        var_firmware_version = par_firmware;

        SELECT default_status INTO var_result FROM csctoss.firmware 
        WHERE device_version LIKE '%' || var_firmware_version || '%'
        LIMIT 1;
          
      END IF;

      IF (var_result = '') IS NOT FALSE THEN
        var_msg = 'Not Current';
      ELSIF (var_result = 0) THEN
        var_msg = 'Not Current';
      ELSE
        var_msg = 'Current';
      END IF;    
    END IF;

  END IF;

  --RAISE NOTICE 'Value: %', result;

  RETURN var_msg;

END;
$_$;


ALTER FUNCTION csctoss.ops_get_firmware_status(text) OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--

