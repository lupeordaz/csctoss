-- Function: unique_id()
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
-- DROP FUNCTION unique_id(integer, text);

CREATE OR REPLACE FUNCTION unique_id(integer, text)
  RETURNS unique_id_retval AS
$BODY$
DECLARE
    par_unique_type                    integer  := $1;
    par_value                          text     := $2;
    var_row                            RECORD;
    var_sql                            VARCHAR;
    var_mac                            text     := 'MAC ADDRESS';
    var_sn                             text     := 'SERIAL NUMBER';
    var_esn                            text     := 'ESN HEX';
    var_retval                         unique_id_retval%ROWTYPE;

BEGIN
  
  var_sql := 'select l.line_id
                ,le.equipment_id
                ,l.radius_username
                ,uim.value as uim
                ,uis.value as uis 
                ,uie.value as uie 
                ,NULL
            from line_equipment le
            join line l on l.line_id = le.line_id';

  var_sql := var_sql || ' join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = ';
  var_sql := var_sql || quote_literal(var_mac);
  var_sql := var_sql || ' join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = ';
  var_sql := var_sql || quote_literal(var_sn);
  var_sql := var_sql || ' join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = ';
  var_sql := var_sql || quote_literal(var_esn);

  var_sql := var_sql || ' where ' || CASE WHEN par_unique_type = 1 
                                    THEN 'uim.value = ' 
                                  WHEN par_unique_type = 2
                                    THEN 'uis.value = '
                                  ELSE 'uie.value = '
                             END;

  var_sql := var_sql || quote_literal(par_value);

  FOR var_row IN
    EXECUTE var_sql
  LOOP
    var_retval.line_id         =  var_row.line_id;
    var_retval.equipment_id    =  var_row.equipment_id;
    var_retval.radius_username =  var_row.radius_username;
    var_retval.uim_value       =  var_row.uim;
    var_retval.uis_value       =  var_row.uis; 
    var_retval.uie_value       =  var_row.uie;
    var_retval.message         =  'Success';
  END LOOP;

  RETURN var_retval;

END ;
$BODY$
  LANGUAGE plpgsql STABLE SECURITY DEFINER;
ALTER FUNCTION unique_id(integer, text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION unique_id(integer, text) TO public;
GRANT EXECUTE ON FUNCTION unique_id(integer, text) TO postgres;