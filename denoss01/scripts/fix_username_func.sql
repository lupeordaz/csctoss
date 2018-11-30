-- Function: fix_username_func(text)
-- DROP FUNCTION csctoss.fix_username_func(text);
CREATE OR REPLACE FUNCTION csctoss.fix_username_func(text,
                                                     text,
                                                     text,
                                                     integer,
                                                     integer,
                                                     integer,
                                                     integer,
                                                     integer)
  RETURNS SETOF text AS
$BODY$
declare
in_old_username   text:=$1;
in_new_username   text:=$2;
in_staff_login    text:=$3;
in_username_cnt   integer:=$4;
in_radcheck_cnt   integer:=$5;
in_radreply_cnt   integer:=$6;
in_usergroup_cnt  integer:=$7;
in_line_cnt       integer:=$8;

v_staff_id        integer;
v_result          integer;
v_tab             text;
v_fail_ind        integer;
v_in_count        integer;
begin

    set client_min_messages=NOTICE;
    
    RAISE NOTICE 'Start of DB Username Update Function';

    select * into v_staff_id from staff where staff_login_name= in_staff_login;
 
    select * into v_result from public.set_change_log_staff_id(v_staff_id);

    if v_result = -1  or v_result=v_staff_id
    then
        RAISE NOTICE 'change log staff id was set';
    else
        RAISE NOTICE 'change log staff id could not be set(%)',v_result;
        RAISE exception 'change log staff id could not be set';
    end if;
--   Updating username
     v_tab:='username';
     v_in_count:=in_username_cnt;
     update  csctoss.username 
     set username    = in_new_username
     where username  = in_old_username;
     GET DIAGNOSTICS v_result = ROW_COUNT;
     if  v_in_count = v_result
     then
         return next  rpad(v_tab,9)||'   table : expected ('||v_in_count||') updated ('||v_result||')- passed';
     else
         raise notice 'update of % table failed : updates: expected (%) actual (%)',v_tab,v_in_count,v_result;
         raise exception 'Username Change was NOT successful';
     end if;
--   Updating radreply
     v_tab:='radreply';
     v_in_count:=in_radreply_cnt;
     update  csctoss.radreply 
     set username    = in_new_username
     where username  = in_old_username;
     GET DIAGNOSTICS v_result = ROW_COUNT;
     if  v_in_count = v_result
     then
         return next  rpad(v_tab,9)||'   table : expected ('||v_in_count||') updated ('||v_result||')- passed';
     else
         raise notice 'update of % table failed : updates: expected (%) actual (%)',v_tab,v_in_count,v_result;
         raise exception 'Username Change was NOT successful';
     end if;
--   Updating radcheck
     v_tab:='radcheck';
     v_in_count:=in_radcheck_cnt;
     update  csctoss.radcheck 
     set username    = in_new_username
     where username  = in_old_username;
     GET DIAGNOSTICS v_result = ROW_COUNT;
     if  v_in_count = v_result
     then
         return next  rpad(v_tab,9)||'   table : expected ('||v_in_count||') updated ('||v_result||')- passed';
     else
         raise notice 'update of % table failed : updates: expected (%) actual (%)',v_tab,v_in_count,v_result;
         raise exception 'Username Change was NOT successful';
     end if;
--   Updating usergroup
     v_tab:='usergroup';
     v_in_count:=in_usergroup_cnt;
     update  csctoss.usergroup 
     set username    = in_new_username
     where username  = in_old_username;
     GET DIAGNOSTICS v_result = ROW_COUNT;
     if  v_in_count = v_result
     then
         return next  v_tab||'   table : expected ('||v_in_count||') updated ('||v_result||')- passed';
     else
         raise notice 'update of % table failed : updates: expected (%) actual (%)',v_tab,v_in_count,v_result;
         raise exception 'Username Change was NOT successful';
     end if;
--   Updating line
     v_tab:='line';
     v_in_count:=in_line_cnt;
     update  csctoss.line 
     set radius_username    = in_new_username
     where radius_username  = in_old_username;
     GET DIAGNOSTICS v_result = ROW_COUNT;
     if  v_in_count = v_result
     then
         return next  rpad(v_tab,9)||'   table : expected ('||v_in_count||') updated ('||v_result||')- passed';
     else
         raise notice 'update of % table failed : updates: expected (%) actual (%)',v_tab,v_in_count,v_result;
         raise exception 'Username Change was NOT successful';
     end if;
     return next '';
     return next 'End of DB Username Update Function';
     return;
END ;
$BODY$
  LANGUAGE plpgsql VOLATILE
  ;



--ALTER FUNCTION oss.fix_username_func(text,text,text) OWNER TO postgres;

--GRANT EXECUTE ON FUNCTION csctoss.fix_username_func(text,text,text) TO csctoss_owner;
--GRANT EXECUTE ON FUNCTION csctoss.fix_username_func(text,text,text) TO postgres;

