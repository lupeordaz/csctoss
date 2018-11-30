create or replace function TERM_REQUEST_BY_HOUR()
RETURNS SETOF text AS
$BODY$
DECLARE


  var_sql                          text ;
  var_model_number1                text ;
  var_serial_number                text ;
  var_return                       text ;

  rec_usage                        record ;
  rec_kount                        record ;

  ar_count_spr			   integer;
  ne_count_spr			   integer;
  ss_count_spr			   integer;

  ar_count_usc			   integer;
  ne_count_usc			   integer;
  ss_count_usc			   integer;
  first_time_sw                    integer :=1;
  prev_hour                         text;

BEGIN

  RETURN NEXT '----------------------------------------------' ;
  RETURN NEXT 'SPRINT & USCC Hourly Termination Cause Report' ;
  RETURN NEXT '----------------------------------------------' ;
  RETURN NEXT '' ;

  RETURN NEXT '             SPRINT		US CELLULAR   			   ';
  RETURN NEXT 'HOUR    A/R    N/E    S/S    A/R    NAS    S/S ';
  RETURN NEXT '----  ------  -----  ----- ------ -----   -----';

  -- dynamically build the sql statement
              
var_sql:='select *
         from
         (
         select
                to_char(acctstarttime::timestamp,''HH24''),
               ( case when username LIKE ''%uscc%'' then ''USCC''
                 else ''SPRINT'' end
                ) as  thisname,
                acctterminatecause,
                count(*)
         from master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
         where acctstarttime::date = current_date-1
         and acctsessiontime IS NOT NULL
         AND class IS NOT NULL
         and  (username LIKE ''%uscc%''
              or
               username like  ''%sprint%''
              )
         and acctterminatecause in ( ''Admin-Reset'',''NAS-Error'')
         group by
                 to_char(acctstarttime::timestamp,''HH24''),
                ( case when username LIKE ''%uscc%'' then ''USCC''
                 else ''SPRINT'' end),
                 acctterminatecause
         --order by 1,2;
         union
         select
                to_char(acctstarttime::timestamp,''HH24''),
               ( case when username LIKE ''%uscc%'' then ''USCC''
                 else ''SPRINT'' end
                ) as  thisname,
                ''S/S''  as ss,
                count(*)
         from master_radacct_'||TO_CHAR(current_date-1,'YYYYMM')||'
         where acctstarttime::date = current_date-1
         and acctsessiontime IS NOT NULL
         AND class IS NOT NULL
         and  (username LIKE ''%uscc%''
              or
               username like  ''%sprint%''
              )
         AND acctsessiontime <= 1
         group by
                 to_char(acctstarttime::timestamp,''HH24''),
                ( case when username LIKE ''%uscc%'' then ''USCC''
                 else ''SPRINT'' end),
                 ss
         ) result
         order by 1,2,3 ';

  RAISE NOTICE 'SQL: %', var_sql ;

  -- execute dynamic query over link and return results
  FOR rec_usage IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(hour		       varchar
					,thisname	       text
                                        ,acctterminatecause    text
                                        ,count                 integer)
  LOOP

    if first_time_sw = 1
    then
       first_time_sw:=0;
       prev_hour:=rec_usage.hour;
    end if;
    if rec_usage.hour <>  prev_hour
    then 
           var_return := RPAD(prev_hour,4,' ')                 ||' '||
                	 LPAD(ar_count_spr,6,' ')               ||' '||
                	 LPAD(ne_count_spr,6,' ')               ||' '||
                	 LPAD(ss_count_spr,6,' ')               ||' '||
                	 LPAD(ar_count_usc,6,' ')               ||' '||
                	 LPAD(ne_count_usc,6,' ')	        ||' '||
			 LPAD(ss_count_usc,6,' ');
            ar_count_spr:=0;
            ne_count_spr:=0;
            ss_count_spr:=0;
            ar_count_usc:=0;
            ne_count_usc:=0;
            ss_count_usc:=0;
	    RETURN NEXT var_return;	
            prev_hour:=rec_usage.hour;
    end if;
    if rec_usage.thisname = 'SPRINT'
    	then
		if rec_usage.acctterminatecause = 'NAS-Error'
		then	
			ne_count_spr = rec_usage.count;
		elsif rec_usage.acctterminatecause = 'Admin-Reset'	
		    then	
			ar_count_spr = rec_usage.count;
                else 
		     ss_count_spr = rec_usage.count;   
                end if;
	else  
		if rec_usage.acctterminatecause = 'Admin-Reset'
		then
			ar_count_usc = rec_usage.count;
		elsif rec_usage.acctterminatecause = 'NAS-Error'	
		then
			ne_count_usc = rec_usage.count;
		else 
			ss_count_usc = rec_usage.count;
                end if;
    end if;
  END LOOP ;
-- prints last record
  var_return :=         RPAD(rec_usage.hour,4,' ')             ||' '||
                        LPAD(ar_count_spr,6,' ')               ||' '||
                        LPAD(ne_count_spr,6,' ')               ||' '||
                        LPAD(ss_count_spr,6,' ')               ||' '||
                        LPAD(ar_count_usc,6,' ')               ||' '||
                        LPAD(ne_count_usc,6,' ')               ||' '||
                        LPAD(ss_count_usc,6,' ');

  RETURN NEXT var_return;


  -- return a blank line
  RETURN NEXT '' ;
  RETURN;


END ;
$BODY$
  LANGUAGE plpgsql STABLE;
--ALTER FUNCTION  TERM_REQUEST_BY_HOUR()
--  OWNER TO csctoss_owner;
COMMENT ON FUNCTION TERM_REQUEST_BY_HOUR() IS 'Simple function to produce report of Termination Requests by hour .';

