CREATE OR REPLACE FUNCTION alert_nas_error_new(integer)
  RETURNS SETOF text AS
$BODY$
DECLARE

  par_top_n                        integer := $1 ;

  var_sql                          text ;
  var_model_number1                text ;
  var_serial_number                text ;
  var_return                       text ;

  rec_usage                        record ;
  rec_kount                        record ;
  
  line_id_curr                     integer;
  hoststring                       text;
  var_sig_str                      record;
  var_ss_sql			   text;  

BEGIN

  RETURN NEXT '-----------------------------------------' ;
  RETURN NEXT 'SPRINT LINES Top 20 NAS-Error' ;
  RETURN NEXT '-----------------------------------------' ;
  RETURN NEXT '' ;

  RETURN NEXT 'USERNAME                          S/N             MODEL              TERMCAUSE  COUNT SIGNAL STRENGTH' ;
  RETURN NEXT '--------------------------------- --------------- ------------------ ---------- ----- ---------------' ;

  -- dynamically build the sql statement
  var_sql := 'SELECT username
                    ,acctterminatecause
                    ,class::integer as line_id
                    ,count(*)
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%sprint%''
            GROUP BY 1,2,3
            ORDER BY 4 DESC
               LIMIT '||par_top_n ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_usage IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(username              text
                                        ,acctterminatecause    text
                                        ,line_id               integer
                                        ,kount                 integer)
  LOOP

    -- for each row returned get the oss data and return the complete record
    SELECT emod.model_number1
          ,COALESCE((select value from csctoss.unique_identifier where equipment_id = equp.equipment_id and unique_identifier_type = 'SERIAL NUMBER'),'NULL')
      INTO var_model_number1
          ,var_serial_number
      FROM csctoss.line_equipment lieq
      JOIN csctoss.equipment equp ON (lieq.equipment_id = equp.equipment_id)
      JOIN csctoss.equipment_model emod ON (equp.equipment_model_id = emod.equipment_model_id)
     WHERE lieq.line_id = rec_usage.line_id
       AND lieq.end_date IS NULL;


    line_id_curr:=rec_usage.line_id;

    --build query to pull signal strength

    var_ss_sql:='select min(rssi)
                from portal.unit_status
                where line_id ='||line_id_curr||'
                and date::date = current_date-1';

    hoststring:='host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r';

    select * into var_sig_str from  public.dblink(hoststring,var_ss_sql)
    AS sig_str_row(ss varchar);

    RAISE NOTICE 'var_sig_str.ss: %', var_sig_str.ss;

    IF var_sig_str.ss IS NULL
    THEN
       var_sig_str.ss := 'Not Found';
    END IF;


    -- build and return the record
    var_return := RPAD(rec_usage.username,33,' ')           ||' '||
                  RPAD(var_serial_number,15,' ')            ||' '||
                  RPAD(var_model_number1,18,' ')            ||' '||
                  RPAD(rec_usage.acctterminatecause,10,' ') ||' '||
                  RPAD(rec_usage.kount::text,5,' ')         ||' '||
		  LPAD(var_sig_str.ss,10,' ');

    RETURN NEXT var_return ;

  END LOOP ;

  -- return a blank line
  RETURN NEXT '' ;

  -- return a total count
  var_sql := 'SELECT count(*)
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%sprint%''' ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_kount IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(kount integer)
  LOOP
    var_return := 'SPRINT TOTAL NAS-Error: '||rec_kount.kount::text ;
    RETURN NEXT var_return ;
  END LOOP ;

  RETURN NEXT '' ;

  -- return a unique count
  var_sql := 'SELECT count(distinct(username))
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%sprint%''' ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_kount IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(kount integer)
  LOOP
    var_return := 'SPRINT # UNIQUE DEVICES WITH NAS-Error: '||rec_kount.kount::text ;
    RETURN NEXT var_return ;
  END LOOP ;

  RETURN NEXT '' ;

  -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC -- USCC 

  RETURN NEXT '-----------------------------------------' ;
  RETURN NEXT 'USCC LINES Top 20 NAS-Error' ;
  RETURN NEXT '-----------------------------------------' ;
  RETURN NEXT '' ;
  RETURN NEXT 'USERNAME                          S/N             MODEL              TERMCAUSE  COUNT SIGNAL STRENGTH' ;
  RETURN NEXT '--------------------------------- --------------- ------------------ ---------- ----- ---------------' ;

  -- dynamically build the sql statement
  var_sql := 'SELECT username
                    ,acctterminatecause
                    ,class::integer as line_id
                    ,count(*)
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%uscc%''
            GROUP BY 1,2,3
            ORDER BY 4 DESC
               LIMIT '||par_top_n ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_usage IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(username              text
                                        ,acctterminatecause    text
                                        ,line_id               integer
                                        ,kount                 integer)
  LOOP

    -- for each row returned get the oss data and return the complete record
    SELECT emod.model_number1
          ,COALESCE((select value from csctoss.unique_identifier where equipment_id = equp.equipment_id and unique_identifier_type = 'SERIAL NUMBER'),'NULL')
      INTO var_model_number1
          ,var_serial_number
      FROM csctoss.line_equipment lieq
      JOIN csctoss.equipment equp ON (lieq.equipment_id = equp.equipment_id)
      JOIN csctoss.equipment_model emod ON (equp.equipment_model_id = emod.equipment_model_id)
     WHERE lieq.line_id = rec_usage.line_id
       AND lieq.end_date IS NULL;


    line_id_curr:=rec_usage.line_id;

    --build query to pull signal strength

    var_ss_sql:='select min(rssi)
                from portal.unit_status
                where line_id ='||line_id_curr||'
                and date::date = current_date-1';

    hoststring:='host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r';

    select * into var_sig_str from  public.dblink(hoststring,var_ss_sql)
    AS sig_str_row(ss varchar);

    RAISE NOTICE 'var_sig_str.ss: %', var_sig_str.ss;

    IF var_sig_str.ss IS NULL
    THEN
       var_sig_str.ss := 'Not Found';
    END IF;

  

    -- build and return the record
    var_return := RPAD(rec_usage.username,33,' ')           ||' '||
                  RPAD(var_serial_number,15,' ')            ||' '||
                  RPAD(var_model_number1,18,' ')            ||' '||
                  RPAD(rec_usage.acctterminatecause,10,' ') ||' '||
                  RPAD(rec_usage.kount::text,5,' ') 	    ||' '||
		  LPAD(var_sig_str.ss,10,' ');

    RETURN NEXT var_return ;

  END LOOP ;

  -- return a blank line
  RETURN NEXT '' ;

  -- return a total count
  var_sql := 'SELECT count(*)
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%uscc%''' ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_kount IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(kount integer)
  LOOP
    var_return := 'USCC TOTAL NAS-Error: '||rec_kount.kount::text ;
    RETURN NEXT var_return ;
  END LOOP ;

  -- return a blank line
  RETURN NEXT '' ;

  -- return a unique count
  var_sql := 'SELECT count(distinct(username))
                FROM master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
               WHERE acctterminatecause = ''NAS-Error''
                 AND acctstarttime::date = current_date-1
                 AND username LIKE ''%uscc%''' ;

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_kount IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(kount integer)
  LOOP
    var_return := 'USCC # UNIQUE DEVICES WITH NAS-Error: '||rec_kount.kount::text ;
    RETURN NEXT var_return ;
  END LOOP ;

  RETURN NEXT '' ;


  RETURN ;
  
END ;
$BODY$
  LANGUAGE plpgsql STABLE;
