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

SET search_path = public, pg_catalog;

--
-- Name: packet_of_disconnect(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION packet_of_disconnect(text) RETURNS SETOF text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $_$
DECLARE

  par_username_or_session      text := $1 ;

  var_sql                      text ;
  var_string                   text ;
  var_conn                     text ;
  var_return                   text ;
  var_pos                      int ;
  var_username                 text ;
  con_sprintname               text := 'cn01.sprintpcs.com';
  var_found                    boolean := false;

  rec_conn                     record ;
  rec_mrac                     record ;
  rec_lnsl                     record ;

BEGIN

  -- build sql dynamically based on username or session
  var_sql := 'SELECT username
                    ,acctsessionid
                    ,framedipaddress
                    ,xascendsessionsvrkey
                    ,nasidentifier
                FROM master_radacct 
               WHERE acctstoptime IS NULL
                 AND acctstarttime > (current_timestamp - interval ''1 day'')' ;

  IF par_username_or_session like '%@%' THEN
    var_sql := var_sql || ' AND username = '||quote_literal(par_username_or_session) ;
  ELSE
    var_sql := var_sql || ' AND acctsessionid = '||quote_literal(par_username_or_session) ;
  END IF ;

  var_sql := var_sql || ' ORDER BY master_radacctid DESC' ;

  --RETURN NEXT var_sql ;

  RAISE NOTICE 'var_sql: %',var_sql;
  -- get relevent accounting records for this username or acctsessionid
  FOR rec_mrac IN 
    SELECT *
      FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql) 
        AS rec_type(username             varchar
                   ,acctsessionid        varchar
                   ,framedipaddress      inet
                   ,xascendsessionsvrkey varchar
                   ,nasidentifier        varchar)
  LOOP

    var_found := true ;

    IF rec_mrac.username like '%uscc%' THEN
      var_pos := ( select position('@' in rec_mrac.username ));
      var_username := (select substring(rec_mrac.username from 1 for var_pos)) || con_sprintname;  
    ELSE  
      var_username := rec_mrac.username;
    END IF;

    var_string := var_username                         ||','||
                  rec_mrac.acctsessionid               ||','||
                  host(rec_mrac.framedipaddress)::text ||','||
                  rec_mrac.xascendsessionsvrkey        ||','||
                  rec_mrac.nasidentifier ;

    -- get the lns connection information
    SELECT *
      INTO rec_lnsl
      FROM csctoss.lns_lookup
     WHERE upper(nasidentifier) = upper(rec_mrac.nasidentifier) ;

    IF NOT FOUND THEN
      RETURN NEXT 'RC1: ERROR' ;
      RETURN NEXT 'RC2:' ;
      RETURN NEXT 'RC3:' ;
      RETURN NEXT 'ERR: NAS Identifier '||rec_mrac.nasidentifier||' undefined in lns_lookup table.' ;
    ELSE
      var_conn := rec_lnsl.nasidentifier               ||','||
                  rec_lnsl.radclient_ip_address::text  ||','||
                  rec_lnsl.radclient_port::text        ||','||
                  rec_lnsl.radclient_password ;
    END IF ;

    -- call the plsh_pod(text,text) function and evaluate results
    BEGIN

      --RETURN NEXT 'STRING: '||var_string ;
      --RETURN NEXT 'LNS CONN: '||var_conn ;

      SELECT *
        INTO var_return
        FROM public.plsh_pod(var_string,var_conn) ;

      -- NEED TO DO SOMETHING HERE BESIDES THEN NULL !!!
      -- NEED TO DO SOMETHING HERE BESIDES THEN NULL !!!
      -- NEED TO DO SOMETHING HERE BESIDES THEN NULL !!!

    EXCEPTION
      WHEN OTHERS THEN NULL ; -- RETURN NEXT 'ERROR: '||var_return ;
    END ;

    -- return success regardless of function call
    RETURN NEXT 'RC1: SUCCESS' ;
    RETURN NEXT 'RC2: Username '||rec_mrac.username||' POD sent to '||rec_mrac.nasidentifier ;
    RETURN NEXT 'RC3: '||var_string ;
    RETURN NEXT 'ERR:' ; 
  
  END LOOP ;

  -- if no satisfying accounting records found then report it
  IF NOT var_found THEN
    RETURN NEXT 'RC1: ERROR' ;
    RETURN NEXT 'RC2:' ;
    RETURN NEXT 'RC3:' ;
    RETURN NEXT 'ERR: Username or Session '||COALESCE(par_username_or_session,'NULL')||' has no open accounting records last 24 hours.' ;
  END IF ;

  RETURN ;

END ;

$_$;


ALTER FUNCTION public.packet_of_disconnect(text) OWNER TO postgres;

--
-- Name: FUNCTION packet_of_disconnect(text); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION packet_of_disconnect(text) IS 'Database function to validate pod request, pass to plsh_pod(text), evaluate and report results.';


--
-- Name: packet_of_disconnect(text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION packet_of_disconnect(text) FROM PUBLIC;
REVOKE ALL ON FUNCTION packet_of_disconnect(text) FROM postgres;
GRANT ALL ON FUNCTION packet_of_disconnect(text) TO postgres;
GRANT ALL ON FUNCTION packet_of_disconnect(text) TO slony;
GRANT ALL ON FUNCTION packet_of_disconnect(text) TO csctoss_owner;


--
-- PostgreSQL database dump complete
--

