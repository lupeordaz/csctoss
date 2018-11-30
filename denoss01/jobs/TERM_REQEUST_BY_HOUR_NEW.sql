create or replace function csctoss.TERM_REQUEST_BY_HOUR_NEW(boolean)
RETURNS SETOF hourly_report_record_type AS
$BODY$
DECLARE

  sw_is_set                        boolean:=$1;

  var_sql                          text ;
  var_return                       text ;
  var_sql_yesterday                text;
  var_sql_today                    text;

  ar_count_spr                     integer;
  ne_count_spr                     integer;
  ss_count_spr                     integer;

  ar_count_usc                     integer;
  ne_count_usc                     integer;
  ss_count_usc                     integer;
  first_time_sw                    integer :=1;
  prev_hour                        text;
  rec_usage                        record ;


  current_record                   hourly_report_record_type;

  ar_count_spr_total               integer;
  ne_count_spr_total               integer;
  ss_count_spr_total               integer;

  ar_count_usc_total               integer;
  ne_count_usc_total               integer;
  ss_count_usc_total               integer;

  date_to_use                      date;

BEGIN
  -- dynamically build the sql statement
  ar_count_spr_total := 0;
  ne_count_spr_total := 0;
  ss_count_spr_total := 0;

  ar_count_usc_total := 0;
  ne_count_usc_total := 0;
  ss_count_usc_total := 0;


  current_record.ar_count_spr := 0;
  current_record.ne_count_spr := 0;
  current_record.ss_count_spr := 0;

  current_record.ar_count_usc := 0;
  current_record.ne_count_usc := 0;
  current_record.ss_count_usc := 0;


        var_sql_yesterday:=
                'select *
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


        var_sql_today:=
                'select *
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
                where acctstarttime::date = current_date
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
                where acctstarttime::date = current_date
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

  --determine wether to run previous day results or todays results, based on parameter passed
  if (sw_is_set)
  then
        var_sql := var_sql_today;
  else
        var_sql := var_sql_yesterday;

  end if;


  -- execute dynamic query over link and return results
  FOR rec_usage IN SELECT *
                     FROM public.dblink((select * from csctoss.fetch_csctlog_conn()),var_sql)
                       AS       rec_type(hour                  varchar
                                        ,thisname              text
                                        ,acctterminatecause    text
                                        ,count                 integer)
  LOOP
    current_record.this_space := '--';
    if first_time_sw = 1
    then
       first_time_sw:=0;
       prev_hour:=rec_usage.hour;
       current_record.hour:=rec_usage.hour;
    end if;
    if rec_usage.hour <>  prev_hour
    then
         RETURN NEXT current_record;
         prev_hour:=rec_usage.hour;
         current_record.hour:=rec_usage.hour;
    end if;
    if rec_usage.thisname = 'SPRINT'
        then
                if rec_usage.acctterminatecause = 'Admin-Reset'
                then
                        current_record.ar_count_spr  = rec_usage.count;
                        ar_count_spr_total := ar_count_spr_total + rec_usage.count;
                elsif rec_usage.acctterminatecause = 'NAS-Error'
                    then
                        current_record.ne_count_spr = rec_usage.count;
                        ne_count_spr_total = ne_count_spr_total +  rec_usage.count;
                else
                     current_record.ss_count_spr = rec_usage.count;
                     ss_count_spr_total = ss_count_spr_total + rec_usage.count;
                end if;
        else
                if rec_usage.acctterminatecause = 'Admin-Reset'
                then
                        current_record.ar_count_usc = rec_usage.count;
                        ar_count_usc_total =ar_count_usc_total + rec_usage.count;
                elsif rec_usage.acctterminatecause = 'NAS-Error'
                then
                        current_record.ne_count_usc = rec_usage.count;
                        ne_count_usc_total = ne_count_usc_total +  rec_usage.count;
                else
                        current_record.ss_count_usc = rec_usage.count;
                        ss_count_usc_total = ss_count_usc_total +  rec_usage.count;
                end if;
    end if;
  END LOOP ;

-- prints last record

  RETURN NEXT current_record;

  current_record.hour:= 'Totals: ';
  current_record.ar_count_spr := ar_count_spr_total;
  current_record.ne_count_spr := ne_count_spr_total;
  current_record.ss_count_spr := ss_count_spr_total;
  current_record.this_space   := '--';
  current_record.ar_count_usc := ar_count_usc_total;
  current_record.ne_count_usc := ne_count_usc_total;
  current_record.ss_count_usc := ss_count_usc_total;

  RETURN NEXT current_record;
  -- return a blank line
  RETURN  ;

  RAISE NOTICE 'SQL: %', var_sql ;

END ;
$BODY$
  LANGUAGE plpgsql STABLE;

COMMENT ON FUNCTION TERM_REQUEST_BY_HOUR() IS 'Simple function to produce report of Termination Requests by hour .';
