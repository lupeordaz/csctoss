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
-- Name: insert_update_location_labels(integer, text, text, text, text, text, text, integer); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--

CREATE OR REPLACE FUNCTION insert_update_location_labels(integer, text, text, text, text, text, text, integer) RETURNS SETOF ops_api_retval
    LANGUAGE plpgsql
  AS $_$
DECLARE 

    par_line_id           integer := $1;
    par_owner             text := $2;
    par_id                text := $3;
    par_name              text := $4;
    par_address           text := $5;
    par_processor         text := $6;
    par_fwver             text := $7;
    par_uptime            integer := $8;
    var_return_row        ops_api_retval%ROWTYPE;

BEGIN 
  IF EXISTS ( SELECT TRUE FROM location_labels WHERE line_id = par_line_id) THEN        

      UPDATE location_labels 
      SET owner = par_owner, 
      id = par_id, 
      name = par_name, 
      address = par_address, 
      processor = par_processor,
      fwver = par_fwver,
      uptime = par_uptime
      WHERE line_id = par_line_id;

    IF NOT FOUND THEN   
      var_return_row.result_code := 'false'
      var_return_row.error_message := 'Update Failed.'
      RETURN NEXT var_return_row;
      RETURN;
    ELSE
      var_return_row.result_code := 'true';
      var_return_row.error_message := 'Update successful!';
      RETURN NEXT var_return_row;
      RETURN;

    END IF;   
  ELSE  
      INSERT INTO location_labels(line_id, owner, id, name, address, processor, fwver, uptime)
           VALUES (par_line_id, par_owner, par_id, par_name, par_address, par_processor, par_fwver, par_uptime); 
      IF NOT FOUND THEN           
        var_return_row.result_code := 'false'
        var_return_row.error_message := 'Insert Failed.'
        RETURN NEXT var_return_row;
        RETURN;
      ELSE
        var_return_row.result_code := 'true';
        var_return_row.error_message := 'Insert successful!';
        RETURN NEXT var_return_row;
        RETURN;
  END IF; 
END IF;
RETURN;
END; 
$_$;


ALTER FUNCTION csctoss.insert_update_location_labels(integer, text, text, text, text, text, text, integer) OWNER TO csctoss_owner;

--
-- PostgreSQL database dump complete
--
