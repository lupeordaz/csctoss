
SET search_path = public, pg_catalog;

CREATE OR REPLACE FUNCTION plpgsql_call_handler() RETURNS language_handler
    LANGUAGE c
    AS '/home/postgres/PGSQL/lib/plpgsql.so', 'plpgsql_call_handler';

CREATE OR REPLACE FUNCTION plsh_handler() RETURNS language_handler
    LANGUAGE c
    AS '/usr/local/INSTALL/postgresql-8.0.14/lib/pgplsh/pgplsh.so', 'plsh_handler';

CREATE OR REPLACE FUNCTION plsh_validator(oid) RETURNS void
    LANGUAGE c
    AS '/usr/local/INSTALL/postgresql-8.0.14/lib/pgplsh/pgplsh.so', 'plsh_validator';

CREATE OR REPLACE FUNCTION database_size(name) RETURNS bigint
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'database_size';

CREATE OR REPLACE FUNCTION packet_of_disconnect(text) RETURNS SETOF text
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $_$
DECLARE

  par_username_or_session      text := $1 ;

  var_sql                      text ;
  var_string                   text ;
  var_conn                     text ;
  var_return                   text ;
  var_found                    boolean := false ;

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

COMMENT ON FUNCTION packet_of_disconnect(text) IS 'Database function to validate pod request, pass to plsh_pod(text), evaluate and report results.';

CREATE OR REPLACE FUNCTION pg_database_size(oid) RETURNS bigint
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'pg_database_size';

CREATE OR REPLACE FUNCTION pg_relation_size(oid) RETURNS bigint
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'pg_relation_size';

CREATE OR REPLACE FUNCTION pg_size_pretty(bigint) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'pg_size_pretty';

CREATE OR REPLACE FUNCTION pg_tablespace_size(oid) RETURNS bigint
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'pg_tablespace_size';

CREATE OR REPLACE FUNCTION relation_size(text) RETURNS bigint
    LANGUAGE c STRICT
    AS '$libdir/dbsize', 'relation_size';

SET search_path = _csctoss_repl, pg_catalog;

DROP VIEW sl_status;

ALTER TABLE sl_nodelock
	ALTER COLUMN nl_conncnt SET DEFAULT nextval('_csctoss_repl.sl_nodelock_nl_conncnt_seq'::text);

CREATE OR REPLACE FUNCTION make_function_strict(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
begin
   update "pg_catalog"."pg_proc" set proisstrict = 't' where 
     proname = $1 and pronamespace = (select oid from "pg_catalog"."pg_namespace" where nspname = '_csctoss_repl') and prolang = (select oid from "pg_catalog"."pg_language" where lanname = 'c');
   return 1 ;
end
$_$;

COMMENT ON FUNCTION make_function_strict(text, text) IS 'Equivalent to 8.1+ ALTER FUNCTION ... STRICT';

CREATE OR REPLACE FUNCTION preparetableforcopy(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id		alias for $1;
	v_tab_oid		oid;
	v_tab_fqname	text;
begin
	-- ----
	-- Get the tables OID and fully qualified name
	-- ---
	select	PGC.oid,
			"_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) as tab_fqname
		into v_tab_oid, v_tab_fqname
			from "_csctoss_repl".sl_table T,   
				"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
				where T.tab_id = p_tab_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid;
	if not found then
		raise exception 'Table with ID % not found in sl_table', p_tab_id;
	end if;

	-- ----
	-- Setting pg_class.relhasindex to false will cause copy not to
	-- maintain any indexes. At the end of the copy we will reenable
	-- them and reindex the table. This bulk creating of indexes is
	-- faster.
	-- ----
	update pg_class set relhasindex = 'f' where oid = v_tab_oid;

	-- ----
	-- Try using truncate to empty the table and fallback to
	-- delete on error.
	-- ----
	perform "_csctoss_repl".TruncateOnlyTable(v_tab_fqname);
	raise notice 'truncate of % succeeded', v_tab_fqname;
	return 1;
	exception when others then
		raise notice 'truncate of % failed - doing delete', v_tab_fqname;
	update pg_class set relhasindex = 'f' where oid = v_tab_oid;
		execute 'delete from only ' || "_csctoss_repl".slon_quote_input(v_tab_fqname);
		return 0;
end;
$_$;

COMMENT ON FUNCTION preparetableforcopy(integer) IS 'Delete all data and suppress index maintenance';

CREATE INDEX log_tableid_idx ON sl_log_2 USING btree (log_tableid);

CREATE VIEW sl_status AS
	SELECT e.ev_origin AS st_origin, c.con_received AS st_received, e.ev_seqno AS st_last_event, e.ev_timestamp AS st_last_event_ts, c.con_seqno AS st_last_received, c.con_timestamp AS st_last_received_ts, ce.ev_timestamp AS st_last_received_event_ts, (e.ev_seqno - c.con_seqno) AS st_lag_num_events, (('now'::text)::timestamp(6) with time zone - (ce.ev_timestamp)::timestamp with time zone) AS st_lag_time FROM sl_event e, sl_confirm c, sl_event ce WHERE (((((e.ev_origin = c.con_origin) AND (ce.ev_origin = e.ev_origin)) AND (ce.ev_seqno = c.con_seqno)) AND ((e.ev_origin, e.ev_seqno) IN (SELECT sl_event.ev_origin, max(sl_event.ev_seqno) AS max FROM sl_event WHERE (sl_event.ev_origin = getlocalnodeid('_csctoss_repl'::name)) GROUP BY sl_event.ev_origin))) AND ((c.con_origin, c.con_received, c.con_seqno) IN (SELECT sl_confirm.con_origin, sl_confirm.con_received, max(sl_confirm.con_seqno) AS max FROM sl_confirm WHERE (sl_confirm.con_origin = getlocalnodeid('_csctoss_repl'::name)) GROUP BY sl_confirm.con_origin, sl_confirm.con_received)));

COMMENT ON VIEW sl_status IS 'View showing how far behind remote nodes are.';

SET search_path = carrier, pg_catalog;

ALTER TABLE api_activity_log
	ALTER COLUMN api_activity_log SET DEFAULT nextval('carrier.api_activity_log_api_activity_log_seq'::text);

ALTER TABLE app_config
	ALTER COLUMN app_config_id SET DEFAULT nextval('carrier.app_config_app_config_id_seq'::text);

ALTER TABLE request
	ALTER COLUMN request_id SET DEFAULT nextval('carrier.request_request_id_seq'::text);

ALTER TABLE request_carrier
	ALTER COLUMN request_carrier_id SET DEFAULT nextval('carrier.request_carrier_request_carrier_id_seq'::text);

ALTER TABLE request_status
	ALTER COLUMN request_status_id SET DEFAULT nextval('carrier.request_status_request_status_id_seq'::text);

ALTER TABLE request_type
	ALTER COLUMN request_type_id SET DEFAULT nextval('carrier.request_type_request_type_id_seq'::text);

SET search_path = csctoss, pg_catalog;

DROP TRIGGER _csctoss_repl_denyaccess_1270 ON billing_entity;

DROP TRIGGER _csctoss_repl_denyaccess_1150 ON equipment;

DROP TRIGGER _csctoss_repl_denyaccess_1080 ON equipment_model;

DROP TRIGGER _csctoss_repl_denyaccess_1930 ON line;

DROP TRIGGER _csctoss_repl_denyaccess_1940 ON line_equipment;

DROP TRIGGER _csctoss_repl_denyaccess_2480 ON location_labels;

DROP TRIGGER _csctoss_repl_denyaccess_1850 ON radreply;

DROP TRIGGER _csctoss_repl_denyaccess_1200 ON unique_identifier;

DROP TRIGGER _csctoss_repl_denyaccess_1800 ON usergroup;

DROP TRIGGER _csctoss_repl_denyaccess_1250 ON address;

DROP TRIGGER _csctoss_repl_denyaccess_1210 ON address_type;

DROP TRIGGER _csctoss_repl_denyaccess_2610 ON agreement_table;

DROP TRIGGER _csctoss_repl_denyaccess_1900 ON alert_activity;

DROP TRIGGER _csctoss_repl_denyaccess_1870 ON alert_definition;

DROP TRIGGER _csctoss_repl_denyaccess_1880 ON alert_definition_contact;

DROP TRIGGER _csctoss_repl_denyaccess_1890 ON alert_definition_snmp;

DROP TRIGGER _csctoss_repl_denyaccess_2340 ON alert_priority;

DROP TRIGGER _csctoss_repl_denyaccess_1860 ON alert_type;

DROP TRIGGER _csctoss_repl_denyaccess_2350 ON alert_usage_type;

DROP TRIGGER _csctoss_repl_denyaccess_2360 ON alerts;

DROP TRIGGER _csctoss_repl_denyaccess_2140 ON api_device_login;

DROP TRIGGER _csctoss_repl_denyaccess_2150 ON api_device_parser;

DROP TRIGGER _csctoss_repl_denyaccess_1370 ON api_key;

DROP TRIGGER _csctoss_repl_denyaccess_2160 ON api_parser;

DROP TRIGGER _csctoss_repl_denyaccess_1380 ON api_request_log;

DROP TRIGGER _csctoss_repl_denyaccess_2170 ON api_supported_device;

DROP TRIGGER _csctoss_repl_denyaccess_1140 ON app_config;

DROP TRIGGER _csctoss_repl_denyaccess_1910 ON atm_processor;

DROP TRIGGER _csctoss_repl_denyaccess_1760 ON attribute;

DROP TRIGGER _csctoss_repl_denyaccess_1750 ON attribute_type;

DROP TRIGGER _csctoss_repl_denyaccess_1330 ON billing_entity_address;

DROP TRIGGER _csctoss_repl_denyaccess_1710 ON billing_entity_download;

DROP TRIGGER _csctoss_repl_denyaccess_1430 ON billing_entity_location_label;

DROP TRIGGER _csctoss_repl_denyaccess_1360 ON billing_entity_product;

DROP TRIGGER _csctoss_repl_denyaccess_1260 ON billing_entity_type;

DROP TRIGGER _csctoss_repl_denyaccess_1600 ON bp_aggregate_usage_plan;

DROP TRIGGER _csctoss_repl_denyaccess_1590 ON bp_allotment_adjustment_history;

DROP TRIGGER _csctoss_repl_denyaccess_1480 ON bp_billing_calendar;

DROP TRIGGER _csctoss_repl_denyaccess_1490 ON bp_billing_period;

DROP TRIGGER _csctoss_repl_denyaccess_1540 ON bp_billing_charge;

DROP TRIGGER _csctoss_repl_denyaccess_1610 ON bp_billing_charge_discount;

DROP TRIGGER _csctoss_repl_denyaccess_1560 ON bp_billing_charge_onetime;

DROP TRIGGER _csctoss_repl_denyaccess_1550 ON bp_billing_charge_static;

DROP TRIGGER _csctoss_repl_denyaccess_1440 ON bp_billing_charge_type;

DROP TRIGGER _csctoss_repl_denyaccess_1450 ON bp_billing_charge_unit;

DROP TRIGGER _csctoss_repl_denyaccess_1570 ON bp_billing_charge_usage;

DROP TRIGGER _csctoss_repl_denyaccess_1520 ON bp_master_billing_plan;

DROP TRIGGER _csctoss_repl_denyaccess_1460 ON bp_billing_discount_type;

DROP TRIGGER _csctoss_repl_denyaccess_1530 ON bp_billing_entity_preferences;

DROP TRIGGER _csctoss_repl_denyaccess_1630 ON bp_billing_equipment_assignment;

DROP TRIGGER _csctoss_repl_denyaccess_1470 ON bp_charge_frequency;

DROP TRIGGER _csctoss_repl_denyaccess_1620 ON bp_past_due_charge;

DROP TRIGGER _csctoss_repl_denyaccess_1640 ON bp_period_billing_summary;

DROP TRIGGER _csctoss_repl_denyaccess_1660 ON bp_period_change_summary;

DROP TRIGGER _csctoss_repl_denyaccess_1650 ON bp_period_charge_summary;

DROP TRIGGER _csctoss_repl_denyaccess_1680 ON bp_period_status_summary;

DROP TRIGGER _csctoss_repl_denyaccess_1670 ON bp_period_usage_summary;

DROP TRIGGER _csctoss_repl_denyaccess_1580 ON bp_usage_allotment;

DROP TRIGGER _csctoss_repl_denyaccess_2060 ON branding_button;

DROP TRIGGER _csctoss_repl_denyaccess_2070 ON branding_content;

DROP TRIGGER _csctoss_repl_denyaccess_2080 ON branding_presentation;

DROP TRIGGER _csctoss_repl_denyaccess_1740 ON broadcast_message;

DROP TRIGGER _csctoss_repl_denyaccess_1720 ON broadcast_message_level;

DROP TRIGGER _csctoss_repl_denyaccess_1730 ON broadcast_message_type;

DROP TRIGGER _csctoss_repl_denyaccess_1390 ON plan;

DROP TRIGGER _csctoss_repl_denyaccess_1350 ON product;

DROP TRIGGER _csctoss_repl_denyaccess_1510 ON carrier;

DROP TRIGGER _csctoss_repl_denyaccess_2240 ON carrier_api_activity_log;

DROP TRIGGER _csctoss_repl_denyaccess_2050 ON carrier_domain;

DROP TRIGGER _csctoss_repl_denyaccess_2000 ON cc_auth_log;

DROP TRIGGER _csctoss_repl_denyaccess_2010 ON cc_encrypt_key;

DROP TRIGGER _csctoss_repl_denyaccess_1030 ON change_log;

DROP TRIGGER _csctoss_repl_denyaccess_2510 ON config;

DROP TRIGGER _csctoss_repl_denyaccess_2520 ON config_equipment;

DROP TRIGGER _csctoss_repl_denyaccess_1300 ON contact;

DROP TRIGGER _csctoss_repl_denyaccess_1340 ON contact_address;

DROP TRIGGER _csctoss_repl_denyaccess_1280 ON contact_level;

DROP TRIGGER _csctoss_repl_denyaccess_1290 ON contact_type;

DROP TRIGGER _csctoss_repl_denyaccess_1500 ON currency;

DROP TRIGGER _csctoss_repl_denyaccess_2500 ON device_monitor;

DROP TRIGGER _csctoss_repl_denyaccess_1700 ON download_file_type;

DROP TRIGGER _csctoss_repl_denyaccess_2180 ON equipment_credential;

DROP TRIGGER _csctoss_repl_denyaccess_2190 ON equipment_firmware;

DROP TRIGGER _csctoss_repl_denyaccess_1160 ON equipment_info;

DROP TRIGGER _csctoss_repl_denyaccess_1070 ON equipment_info_type;

DROP TRIGGER _csctoss_repl_denyaccess_2200 ON equipment_model_credential;

DROP TRIGGER _csctoss_repl_denyaccess_2370 ON equipment_model_status;

DROP TRIGGER _csctoss_repl_denyaccess_1170 ON equipment_note;

DROP TRIGGER _csctoss_repl_denyaccess_1180 ON equipment_software;

DROP TRIGGER _csctoss_repl_denyaccess_1190 ON equipment_status;

DROP TRIGGER _csctoss_repl_denyaccess_1110 ON equipment_status_type;

DROP TRIGGER _csctoss_repl_denyaccess_1100 ON equipment_type;

DROP TRIGGER _csctoss_repl_denyaccess_1780 ON username;

DROP TRIGGER _csctoss_repl_denyaccess_2560 ON equipment_warranty;

DROP TRIGGER _csctoss_repl_denyaccess_2580 ON equipment_warranty_rule;

DROP TRIGGER _csctoss_repl_denyaccess_2530 ON firmware;

DROP TRIGGER _csctoss_repl_denyaccess_2540 ON firmware_equipment;

DROP TRIGGER _csctoss_repl_denyaccess_1790 ON groupname;

DROP TRIGGER _csctoss_repl_denyaccess_2250 ON groupname_default;

DROP TRIGGER _csctoss_repl_denyaccess_1040 ON last_change_log;

DROP TRIGGER _csctoss_repl_denyaccess_2260 ON line_alert;

DROP TRIGGER _csctoss_repl_denyaccess_2270 ON line_alert_email;

DROP TRIGGER _csctoss_repl_denyaccess_1920 ON line_assignment_type;

DROP TRIGGER _csctoss_repl_denyaccess_1950 ON line_terminal;

DROP TRIGGER _csctoss_repl_denyaccess_1970 ON line_usage_day;

DROP TRIGGER _csctoss_repl_denyaccess_2330 ON line_usage_day_history;

DROP TRIGGER _csctoss_repl_denyaccess_1980 ON line_usage_month;

DROP TRIGGER _csctoss_repl_denyaccess_2280 ON line_usage_overage_calc;

DROP TRIGGER _csctoss_repl_denyaccess_2230 ON lns_lookup;

DROP TRIGGER _csctoss_repl_denyaccess_1220 ON location_label_type;

DROP TRIGGER _csctoss_repl_denyaccess_1310 ON login_tracking;

DROP TRIGGER _csctoss_repl_denyaccess_7000 ON master_radpostauth;

DROP TRIGGER _csctoss_repl_denyaccess_1960 ON mrad_duplicate;

DROP TRIGGER _csctoss_repl_denyaccess_1810 ON nas;

DROP TRIGGER _csctoss_repl_denyaccess_2570 ON soup_config_info;

DROP TRIGGER _csctoss_repl_denyaccess_2490 ON oss_jbill_billing_entity_mapping;

DROP TRIGGER _csctoss_repl_denyaccess_5300 ON otaps_monthly_usage_summary;

DROP TRIGGER _csctoss_repl_denyaccess_5310 ON otaps_product_code_translation;

DROP TRIGGER _csctoss_repl_denyaccess_2550 ON otaps_service_line_number;

DROP TRIGGER _csctoss_repl_denyaccess_2040 ON parser_log;

DROP TRIGGER _csctoss_repl_denyaccess_2020 ON plan_log;

DROP TRIGGER _csctoss_repl_denyaccess_1230 ON plan_type;

DROP TRIGGER _csctoss_repl_denyaccess_1690 ON portal_properties;

DROP TRIGGER _csctoss_repl_denyaccess_2290 ON product_overage_threshold;

DROP TRIGGER _csctoss_repl_denyaccess_2130 ON purchase_log;

DROP TRIGGER _csctoss_repl_denyaccess_1820 ON radcheck;

DROP TRIGGER _csctoss_repl_denyaccess_1830 ON radgroupcheck;

DROP TRIGGER _csctoss_repl_denyaccess_1840 ON radgroupreply;

DROP TRIGGER _csctoss_repl_denyaccess_2590 ON radius_operator;

DROP TRIGGER _csctoss_repl_denyaccess_1120 ON receiving_lot;

DROP TRIGGER _csctoss_repl_denyaccess_1060 ON replication_failure;

DROP TRIGGER _csctoss_repl_denyaccess_1400 ON report;

DROP TRIGGER _csctoss_repl_denyaccess_2600 ON rma_form;

DROP TRIGGER _csctoss_repl_denyaccess_1990 ON sales_order;

DROP TRIGGER _csctoss_repl_denyaccess_1320 ON security_roles;

DROP TRIGGER _csctoss_repl_denyaccess_1410 ON shipment;

DROP TRIGGER _csctoss_repl_denyaccess_1420 ON shipment_equipment;

DROP TRIGGER _csctoss_repl_denyaccess_1130 ON software;

DROP TRIGGER _csctoss_repl_denyaccess_2300 ON soup_config;

DROP TRIGGER _csctoss_repl_denyaccess_2090 ON soup_device;

DROP TRIGGER _csctoss_repl_denyaccess_2310 ON soup_dirnames;

DROP TRIGGER _csctoss_repl_denyaccess_2320 ON sprint_assignment;

DROP TRIGGER _csctoss_repl_denyaccess_2400 ON sprint_csa;

DROP TRIGGER _csctoss_repl_denyaccess_8000 ON sprint_master_radacct;

DROP TRIGGER _csctoss_repl_denyaccess_2390 ON sprint_msl;

DROP TRIGGER _csctoss_repl_denyaccess_1010 ON staff;

DROP TRIGGER _csctoss_repl_denyaccess_1020 ON staff_access;

DROP TRIGGER _csctoss_repl_denyaccess_1240 ON state_code;

DROP TRIGGER _csctoss_repl_denyaccess_2410 ON static_ip_carrier_def;

DROP TRIGGER _csctoss_repl_denyaccess_2380 ON static_ip_pool;

DROP TRIGGER _csctoss_repl_denyaccess_1000 ON system_parameter;

DROP TRIGGER _csctoss_repl_denyaccess_2110 ON throw_away_minutes;

DROP TRIGGER _csctoss_repl_denyaccess_1050 ON timezone;

DROP TRIGGER _csctoss_repl_denyaccess_2420 ON unique_identifier_history;

DROP TRIGGER _csctoss_repl_denyaccess_1090 ON unique_identifier_type;

DROP TRIGGER _csctoss_repl_denyaccess_2120 ON usergroup_error_log;

DROP TRIGGER _csctoss_repl_denyaccess_2470 ON userlevels;

DROP TRIGGER _csctoss_repl_denyaccess_2430 ON webui_users;

DROP VIEW active_lines_vw;

DROP VIEW device_monitor_vw;

DROP VIEW oss_jbill_plan_comparison_vw;

DROP VIEW oss_sync_ip_activity_vw;

DROP VIEW oss_sync_line_mrac_vw;

DROP VIEW portal_active_lines_vw;

DROP VIEW session_history_last30days_vw;

CREATE TABLE v_contact_id (
	nextval bigint
);

CREATE TABLE v_count (
	"count" bigint
);

CREATE TABLE v_new_sn (
	"value" text
);

CREATE TABLE v_old_ip (
	"value" character varying(253)
);

CREATE TABLE var_equipment_id (
	equipment_id integer
);

CREATE TABLE var_username (
	username character varying(64)
);

ALTER TABLE billing_entity
	ALTER COLUMN billing_entity_id SET DEFAULT nextval('csctoss.billing_entity_billing_entity_id_seq'::text);

ALTER TABLE equipment
	ALTER COLUMN equipment_id SET DEFAULT nextval('csctoss.equipment_equipment_id_seq'::text);

ALTER TABLE equipment_model
	ALTER COLUMN equipment_model_id SET DEFAULT nextval('csctoss.equipment_model_equipment_model_id_seq'::text);

ALTER TABLE line
	ALTER COLUMN line_id SET DEFAULT nextval('csctoss.line_line_id_seq'::text);

ALTER TABLE radreply
	ALTER COLUMN id SET DEFAULT nextval('csctoss.radreply_id_seq'::text);

ALTER TABLE usergroup
	ALTER COLUMN id SET DEFAULT nextval('csctoss.usergroup_id_seq'::text);

ALTER TABLE address
	ALTER COLUMN address_id SET DEFAULT nextval('csctoss.address_address_id_seq'::text);

ALTER TABLE agreement_table
	ALTER COLUMN id SET DEFAULT nextval('csctoss.agreement_table_id_seq'::text);

ALTER TABLE alert_activity
	ALTER COLUMN alert_activity_id SET DEFAULT nextval('csctoss.alert_activity_alert_activity_id_seq'::text);

ALTER TABLE alert_definition
	ALTER COLUMN alert_definition_id SET DEFAULT nextval('csctoss.alert_definition_alert_definition_id_seq'::text);

ALTER TABLE alert_type
	ALTER COLUMN alert_type_id SET DEFAULT nextval('csctoss.alert_type_alert_type_id_seq'::text);

ALTER TABLE alerts
	ALTER COLUMN alert_id SET DEFAULT nextval('csctoss.alerts_alert_id_seq'::text);

ALTER TABLE api_device_login
	ALTER COLUMN device_login_id SET DEFAULT nextval('csctoss.api_device_login_device_login_id_seq'::text);

ALTER TABLE api_key
	ALTER COLUMN api_key_id SET DEFAULT nextval('csctoss.api_key_api_key_id_seq'::text);

ALTER TABLE api_parser
	ALTER COLUMN parser_id SET DEFAULT nextval('csctoss.api_parser_parser_id_seq'::text);

ALTER TABLE api_supported_device
	ALTER COLUMN device_id SET DEFAULT nextval('csctoss.api_supported_device_device_id_seq'::text);

ALTER TABLE app_config
	ALTER COLUMN app_config_id SET DEFAULT nextval('csctoss.app_config_app_config_id_seq'::text);

ALTER TABLE bp_aggregate_usage_plan
	ALTER COLUMN bp_aggregate_usage_plan_id SET DEFAULT nextval('csctoss.bp_aggregate_usage_plan_bp_aggregate_usage_plan_id_seq'::text);

ALTER TABLE bp_billing_calendar
	ALTER COLUMN bp_billing_calendar_id SET DEFAULT nextval('csctoss.bp_billing_calendar_bp_billing_calendar_id_seq'::text);

ALTER TABLE bp_billing_period
	ALTER COLUMN bp_billing_period_id SET DEFAULT nextval('csctoss.bp_billing_period_bp_billing_period_id_seq'::text);

ALTER TABLE bp_billing_charge
	ALTER COLUMN bp_billing_charge_id SET DEFAULT nextval('csctoss.bp_billing_charge_bp_billing_charge_id_seq'::text);

ALTER TABLE bp_billing_charge_discount
	ALTER COLUMN bp_billing_charge_discount_id SET DEFAULT nextval('csctoss.bp_billing_charge_discount_bp_billing_charge_discount_id_seq'::text);

ALTER TABLE bp_billing_charge_onetime
	ALTER COLUMN bp_billing_charge_onetime_id SET DEFAULT nextval('csctoss.bp_billing_charge_onetime_bp_billing_charge_onetime_id_seq'::text);

ALTER TABLE bp_billing_charge_static
	ALTER COLUMN bp_billing_charge_static_id SET DEFAULT nextval('csctoss.bp_billing_charge_static_bp_billing_charge_static_id_seq'::text);

ALTER TABLE bp_billing_charge_usage
	ALTER COLUMN bp_billing_charge_usage_id SET DEFAULT nextval('csctoss.bp_billing_charge_usage_bp_billing_charge_usage_id_seq'::text);

ALTER TABLE bp_master_billing_plan
	ALTER COLUMN bp_master_billing_plan_id SET DEFAULT nextval('csctoss.bp_master_billing_plan_bp_master_billing_plan_id_seq'::text);

ALTER TABLE bp_billing_equipment_assignment
	ALTER COLUMN bp_billing_equipment_assignment_id SET DEFAULT nextval('csctoss.bp_billing_equipment_assignme_bp_billing_equipment_assignme_seq'::text);

ALTER TABLE bp_past_due_charge
	ALTER COLUMN bp_past_due_charge_id SET DEFAULT nextval('csctoss.bp_past_due_charge_bp_past_due_charge_id_seq'::text);

ALTER TABLE bp_period_billing_summary
	ALTER COLUMN bp_period_billing_summary_id SET DEFAULT nextval('csctoss.bp_period_billing_summary_bp_period_billing_summary_id_seq'::text);

ALTER TABLE bp_period_charge_summary
	ALTER COLUMN bp_period_charge_summary_id SET DEFAULT nextval('csctoss.bp_period_charge_summary_bp_period_charge_summary_id_seq'::text);

ALTER TABLE bp_period_usage_summary
	ALTER COLUMN bp_period_usage_summary_id SET DEFAULT nextval('csctoss.bp_period_usage_summary_bp_period_usage_summary_id_seq'::text);

ALTER TABLE bp_usage_allotment
	ALTER COLUMN bp_usage_allotment_id SET DEFAULT nextval('csctoss.bp_usage_allotment_bp_usage_allotment_id_seq'::text);

ALTER TABLE broadcast_message
	ALTER COLUMN broadcast_message_id SET DEFAULT nextval('csctoss.broadcast_message_broadcast_message_id_seq'::text);

ALTER TABLE broadcast_message_data
	ALTER COLUMN broadcast_id SET DEFAULT nextval('csctoss.broadcast_message_data_broadcast_id_seq'::text);

ALTER TABLE broadcast_message_level
	ALTER COLUMN broadcast_message_level_id SET DEFAULT nextval('csctoss.broadcast_message_level_broadcast_message_level_id_seq'::text);

ALTER TABLE broadcast_message_type
	ALTER COLUMN broadcast_message_type_id SET DEFAULT nextval('csctoss.broadcast_message_type_broadcast_message_type_id_seq'::text);

ALTER TABLE plan
	ALTER COLUMN plan_id SET DEFAULT nextval('csctoss.plan_plan_id_seq'::text);

ALTER TABLE carrier_api_activity_log
	ALTER COLUMN api_activity_log SET DEFAULT nextval('csctoss.carrier_api_activity_log_api_activity_log_seq'::text);

ALTER TABLE cc_auth_log
	ALTER COLUMN cc_auth_log_id SET DEFAULT nextval('csctoss.cc_auth_log_cc_auth_log_id_seq'::text);

ALTER TABLE cc_encrypt_key
	ALTER COLUMN cc_encrypt_key_id SET DEFAULT nextval('csctoss.cc_encrypt_key_cc_encrypt_key_id_seq'::text);

ALTER TABLE change_log
	ALTER COLUMN change_log_id SET DEFAULT nextval('csctoss.change_log_change_log_id_seq'::text);

ALTER TABLE config
	ALTER COLUMN id SET DEFAULT nextval('csctoss.config_id_seq'::text);

ALTER TABLE config_equipment
	ALTER COLUMN id SET DEFAULT nextval('csctoss.config_equipment_id_seq'::text);

ALTER TABLE contact
	ALTER COLUMN contact_id SET DEFAULT nextval('csctoss.contact_contact_id_seq'::text);

ALTER TABLE currency
	ALTER COLUMN currency_id SET DEFAULT nextval('csctoss.currency_currency_id_seq'::text);

ALTER TABLE equipment_credential
	ALTER COLUMN equipment_credential_id SET DEFAULT nextval('csctoss.equipment_credential_equipment_credential_id_seq'::text);

ALTER TABLE equipment_firmware
	ALTER COLUMN equipment_firmware_id SET DEFAULT nextval('csctoss.equipment_firmware_equipment_firmware_id_seq'::text);

ALTER TABLE firmware
	ALTER COLUMN id SET DEFAULT nextval('csctoss.firmware_id_seq'::text);

ALTER TABLE firmware_equipment
	ALTER COLUMN id SET DEFAULT nextval('csctoss.firmware_equipment_id_seq'::text);

ALTER TABLE firmware_gmu
	ALTER COLUMN firmware_gmu_id SET DEFAULT nextval('csctoss.firmware_gmu_firmware_gmu_id_seq'::text);

ALTER TABLE groupname_default
	ALTER COLUMN groupname_default_key_id SET DEFAULT nextval('csctoss.groupname_default_groupname_default_key_id_seq'::text);

ALTER TABLE master_radacct
	ALTER COLUMN master_radacctid SET DEFAULT nextval('csctoss.master_radacct_master_radacctid_seq'::text);

ALTER TABLE master_radpostauth
	ALTER COLUMN master_radpostauth_id SET DEFAULT nextval('csctoss.master_radpostauth_master_radpostauth_id_seq'::text);

ALTER TABLE message_priority
	ALTER COLUMN message_priority_id SET DEFAULT nextval('csctoss.message_priority_message_priority_id_seq'::text);

ALTER TABLE nas
	ALTER COLUMN id SET DEFAULT nextval('csctoss.nas_id_seq'::text);

ALTER TABLE soup_config_info
	ALTER COLUMN config_id SET DEFAULT nextval('csctoss.soup_config_info_config_id_seq'::text);

ALTER TABLE otaps_monthly_usage_summary
	ALTER COLUMN usage_monthly_summary_id SET DEFAULT nextval('csctoss.otaps_monthly_usage_summary_usage_monthly_summary_id_seq'::text);

ALTER TABLE parser_log
	ALTER COLUMN parser_log_id SET DEFAULT nextval('csctoss.parser_log_parser_log_id_seq'::text);

ALTER TABLE plan_log
	ALTER COLUMN plan_log_id SET DEFAULT nextval('csctoss.plan_log_plan_log_id_seq'::text);

ALTER TABLE purchase_log
	ALTER COLUMN purchase_log_id SET DEFAULT nextval('csctoss.purchase_log_purchase_log_id_seq'::text);

ALTER TABLE radcheck
	ALTER COLUMN id SET DEFAULT nextval('csctoss.radcheck_id_seq'::text);

ALTER TABLE radgroupcheck
	ALTER COLUMN id SET DEFAULT nextval('csctoss.radgroupcheck_id_seq'::text);

ALTER TABLE radgroupreply
	ALTER COLUMN id SET DEFAULT nextval('csctoss.radgroupreply_id_seq'::text);

ALTER TABLE radius_operator
	ALTER COLUMN op_id SET DEFAULT nextval('csctoss.radius_operator_op_id_seq'::text);

ALTER TABLE receiving_lot
	ALTER COLUMN receiving_lot_id SET DEFAULT nextval('csctoss.receiving_lot_receiving_lot_id_seq'::text);

ALTER TABLE replication_failure
	ALTER COLUMN replication_failure_id SET DEFAULT nextval('csctoss.replication_failure_replication_failure_id_seq'::text);

ALTER TABLE report
	ALTER COLUMN report_id SET DEFAULT nextval('csctoss.report_report_id_seq'::text);

ALTER TABLE rma_form
	ALTER COLUMN id SET DEFAULT nextval('csctoss.rma_form_id_seq'::text);

ALTER TABLE shipment
	ALTER COLUMN shipment_id SET DEFAULT nextval('csctoss.shipment_shipment_id_seq'::text);

ALTER TABLE software
	ALTER COLUMN software_id SET DEFAULT nextval('csctoss.software_software_id_seq'::text);

ALTER TABLE soup_config
	ALTER COLUMN soup_config_id SET DEFAULT nextval('csctoss.soup_config_soup_config_id_seq'::text);

ALTER TABLE soup_dirnames
	ALTER COLUMN soup_dirnames_id SET DEFAULT nextval('csctoss.soup_dirnames_soup_dirnames_id_seq'::text);

ALTER TABLE sprint_assignment
	ALTER COLUMN sprint_assignment_id SET DEFAULT nextval('csctoss.sprint_assignment_sprint_assignment_id_seq'::text);

ALTER TABLE sprint_csa
	ALTER COLUMN id SET DEFAULT nextval('csctoss.sprint_csa_id_seq'::text);

ALTER TABLE sprint_master_radacct
	ALTER COLUMN sprint_master_radacctid SET DEFAULT nextval('csctoss.sprint_master_radacct_sprint_master_radacctid_seq'::text);

ALTER TABLE static_ip_pool
	ALTER COLUMN id SET DEFAULT nextval('csctoss.static_ip_pool_id_seq'::text);

ALTER TABLE static_ip_reservation
	ALTER COLUMN reservation_id SET DEFAULT nextval('csctoss.static_ip_reservation_reservation_id_seq'::text);

ALTER TABLE throw_away_minutes
	ALTER COLUMN throw_away_min_id SET DEFAULT nextval('csctoss.throw_away_minutes_throw_away_min_id_seq'::text);

ALTER TABLE unique_identifier_history
	ALTER COLUMN unique_identifier_history_id SET DEFAULT nextval('csctoss.unique_identifier_history_unique_identifier_history_id_seq'::text);

ALTER TABLE usergroup_error_log
	ALTER COLUMN usergroup_error_log_id SET DEFAULT nextval('csctoss.usergroup_error_log_usergroup_error_log_id_seq'::text);

ALTER TABLE webui_users
	ALTER COLUMN id SET DEFAULT nextval('csctoss_users_id_seq'::text);

CREATE OR REPLACE FUNCTION ops_api_assign_20171219(text, text, integer, text, boolean) RETURNS SETOF ops_api_assign_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
   par_esn_hex                        text := $1;
   par_sales_order                    text := $2;
   par_billing_entity_id              integer := $3;
   par_groupname                      text := $4;
   par_static_ip_boolean              boolean := $5;
   var_equipment_id                   integer;
   var_line_id                        integer;
   var_mdn                            text;
   var_mdn_min                        text;
   var_username                       text;
   var_billing_entity_address_id      integer;
   var_static_ip                      text;
   var_conn_string                    text;
   var_serial_number                  text;
   var_line_start_date                date;
   var_line_equip_start_date          date;
   var_model_id                       integer;
   var_carrier                        text;
   var_sql                            text;
   var_return_row                     ops_api_assign_retval%ROWTYPE;
   v_return_2                         boolean;
   v_jbilling_item_code               text; 
   var_sql_2                          text;
   v_product_id                       integer;
   v_plan_type_id                     integer;
   v_length_days                      integer;
   v_line_ctr                         integer;
   v_numrows                          integer;
   v_count                            integer;
   v_priority                         integer;

BEGIN
    PERFORM public.set_change_log_staff_id (3);

    -- Check if the parameters are null
    IF par_esn_hex = ''
        OR par_sales_order = ''
        OR par_billing_entity_id IS NULL
        OR par_groupname = ''
        OR par_static_ip_boolean IS NULL
    THEN
       RAISE EXCEPTION 'All or some of the input values are null';
    END IF;

    -- Validate Parameters
    SELECT equipment_id INTO var_equipment_id
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value = par_esn_hex;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'The ESN HEX value entered doesnt exist';
    END IF;

    SELECT equipment_model_id INTO var_model_id
    FROM equipment
    WHERE equipment_id = var_equipment_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Equipment model doesnt exist.';
    END IF;

    -- Get carrier name from equipment model table
    SELECT em.carrier INTO var_carrier
    FROM unique_identifier ui
    JOIN equipment e ON ui.equipment_id = e.equipment_id
    JOIN equipment_model em ON em.equipment_model_id = e.equipment_model_id
    WHERE ui.value = par_esn_hex
    LIMIT 1;

    RAISE NOTICE 'Sales Order: %',par_sales_order;
    RAISE NOTICE 'ESN: %',par_esn_hex;
    RAISE NOTICE 'CARRIER: %',var_carrier;

    -- Retrieve a part of username depending upon carrier and MDN/MIN value.
    IF ( var_carrier = 'SPRINT') THEN
        SELECT value INTO var_mdn_min
        FROM unique_identifier
        WHERE unique_identifier_type = 'MDN'
        AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);

    ELSIF (var_carrier = 'VZW') THEN
        SELECT value INTO var_mdn_min
        FROM unique_identifier
        WHERE unique_identifier_type = 'MDN'
        AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);

    ELSIF (var_carrier = 'USCC')  THEN
        SELECT value INTO var_mdn_min
        FROM unique_identifier
        WHERE unique_identifier_type = 'MIN'
        AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);

    ELSIF (var_carrier = 'VODAFONE')  THEN
        SELECT value INTO var_mdn_min
        FROM unique_identifier
        WHERE unique_identifier_type = 'MDN'
        AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);

    END IF;

    RAISE NOTICE 'MDN/MIN: %',var_mdn_min;

    -- Retrieve username value using MDN or MIN value
    SELECT username INTO var_username
    FROM username
    WHERE SUBSTR(username, 1, 10) = var_mdn_min;
    RAISE NOTICE 'USERNAME: % USERGROUP: %',var_username,par_groupname;

    IF NOT FOUND THEN
        SELECT username INTO var_username
        FROM username
        WHERE 1 = 1
        AND substr(username, 1, 15) = var_mdn_min ;

        IF NOT FOUND THEN          
            RAISE EXCEPTION 'Username doesnt exist';
        END IF;
    END IF;

    -- Retrieve Serial Number value from unique_identifier
    SELECT value INTO var_serial_number
    FROM unique_identifier
    WHERE unique_identifier_type = 'SERIAL NUMBER'
    AND equipment_id = var_equipment_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Serial Number value doesnt exist for the Equipment.';
    END IF;

    -- Billing_entity_address_id retrieval
    SELECT address_id INTO var_billing_entity_address_id
    FROM billing_entity_address
    WHERE billing_entity_id = par_billing_entity_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Billing Entity Address doesnt exist';
    ELSE
        var_line_id := nextval('csctoss.line_line_id_seq');
        IF EXISTS (SELECT TRUE
                   FROM line l
                   JOIN line_equipment le USING (line_id) 
                   JOIN unique_identifier ui USING (equipment_id)
                   WHERE ui.unique_identifier_type = 'ESN HEX' 
                   AND ui.value = par_esn_hex AND le.end_date IS NULL) 
        THEN
            RAISE EXCEPTION 'Active Line already exists for the input parameters';
        ELSE
            -- Insert required fields values into line table
            INSERT INTO line (
                line_id, line_assignment_type, billing_entity_id, 
                billing_entity_address_id, active_flag, line_label, 
                start_date, date_created, radius_username, notes)
            VALUES (
                var_line_id, 'CUSTOMER ASSIGNED', par_billing_entity_id, 
                var_billing_entity_address_id, TRUE, par_esn_hex, 
                current_date, current_date, var_username, par_sales_order);

            SELECT start_date INTO var_line_start_date
            FROM line WHERE line_id = var_line_id;

            -- Update username table with SO_ORDER and Billing_Entity_ID
            UPDATE username
                SET notes = par_sales_order,
                    billing_entity_id = par_billing_entity_id
            WHERE username = var_username;

            IF NOT FOUND THEN
                RAISE EXCEPTION 'Username Update Failed!';
            END IF;
        END IF;
    END IF;

    -- If no active line exists for the equipment then Insert line, equipment details.
    IF NOT EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id = var_equipment_id AND end_date IS NULL) THEN

        -- [BEGIN] NEW CODE TO CHECK IF OWNERSHIP TRANSFER - IF SO, THEN BACK DATE END DATE
        IF EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id = var_equipment_id AND end_date = current_date ) THEN
            UPDATE line_equipment
            SET 
            end_date = current_date - 1
            WHERE equipment_id = var_equipment_id
            AND   end_date = current_date ;     
        END IF;
        -- [END] NEW CODE TO CHECK IF OWNERSHIP TRANSFER - IF SO, THEN BACK DATE END DATE
           
        INSERT INTO line_equipment
            (line_id, equipment_id, start_date, billing_entity_address_id)
        VALUES 
            (var_line_id, var_equipment_id, current_date, var_billing_entity_address_id);

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Line_Equipment Insert Failed!';
        END IF;

        -- no idea why this is here
        SELECT start_date INTO var_line_equip_start_date
        FROM line_equipment
        WHERE line_id = var_line_id
        AND equipment_id = var_equipment_id;

    ELSE
        RAISE EXCEPTION 'Equipment is already assigned to a line.';
    END IF;

    -- Update usergroup table with input groupname.
    SELECT priority INTO v_priority
    FROM groupname 
    WHERE 1 = 1
    AND groupname = par_groupname;

    GET DIAGNOSTICS v_numrows = ROW_COUNT;
    IF v_numrows = 0 THEN
        RAISE EXCEPTION 'Usergroup not found in GROUPNAME table.';
    END IF;
          
    DELETE FROM usergroup WHERE username LIKE var_username;

    INSERT INTO usergroup 
        (username,groupname,priority) 
    VALUES
        (var_username,par_groupname,v_priority) ;

    -- removed to fix duplicate issue- UPDATE usergroup SET groupname = par_groupname WHERE username LIKE var_username;

    -- SELECT carrier from equipment model table

    SELECT em.carrier INTO var_carrier
    FROM unique_identifier ui
    JOIN equipment e ON (ui.equipment_id = e.equipment_id)
    JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id)
    WHERE 1 = 1
    AND ui.value = par_esn_hex
    LIMIT 1;

    -- Assign static ip to radreply table.
    IF par_static_ip_boolean = FALSE THEN
        INSERT INTO radreply (username, attribute, op, value, priority)
        VALUES (var_username, 'Class', '=', var_line_id::text, 10);

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Radreply Update Failed!';
        END IF;

        RAISE NOTICE 'DYNAMIC IP- STATIC IP NOT ASSIGNED';
    ELSE
        SELECT * INTO var_static_ip FROM ops_api_static_ip_assign(var_carrier,par_groupname,var_username,var_line_id,par_billing_entity_id);
        RAISE NOTICE 'STATIC IP: %',var_static_ip;
    END IF;
          
    -- Get product code from JBilling.
    var_sql_2 := '
    SELECT i.internal_number
    FROM purchase_order po,
    order_line ol,
    item i,
    item_type_map itm
    WHERE 1=1
    AND po.public_number = ''' || par_sales_order || '''
    AND po.id = ol.order_id
    AND ol.item_id = i.id
    AND i.id = itm.item_id
    AND itm.type_id = 301
    AND internal_number LIKE ''MRC%''
    LIMIT 1';

    RAISE NOTICE 'Calling Jbilling to get Product Name (internal number) from item table.';

    SELECT prod_code into v_jbilling_item_code FROM public.dblink(fetch_jbilling_conn(), var_sql_2)
        AS rec_type (prod_code  text);
    v_count := length(v_jbilling_item_code);
    RAISE NOTICE 'MRC Product Code from Jbilling: % length: %', v_jbilling_item_code, v_count;

    SELECT product_id, plan_type_id, length_days INTO v_product_id, v_plan_type_id, v_length_days
    FROM csctoss.product
    WHERE 1 = 1
    AND product_code LIKE v_jbilling_item_code;

    GET DIAGNOSTICS v_numrows = ROW_COUNT;
    IF v_numrows = 0 THEN
        RAISE EXCEPTION 'ERROR: Product code not present in Product table';
    ELSE
        RAISE NOTICE 'Product Info: prod_id: %  plan_type: % length_days: %',v_product_id,v_plan_type_id,v_length_days;
    END IF;

    -- Insert csctoss.plan record.
    RAISE NOTICE 'Inserting Product Info into plan table';

    INSERT INTO plan
    (
    length_days, plan_type_id, comment , create_timestamp, product_id, 
    staff_id, line_id , start_date, end_date , prepaid_unit, 
    prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number
    )
    VALUES
    (
    v_length_days, v_plan_type_id , par_sales_order, current_timestamp, v_product_id, 
    3, var_line_id , current_date, null,  null,
    null, null,   current_date,   null  
    );

    GET DIAGNOSTICS v_numrows = ROW_COUNT;
    IF v_numrows = 0 THEN
        RAISE EXCEPTION 'Error: No rows inserted into plan table.';
    END IF;

    -- Insert csctoss.equipment_warranty record.
    RAISE NOTICE 'Inserting Warranty Info into equipment_warranty table';

    INSERT INTO equipment_warranty
    SELECT
    var_equipment_id,
    var_line_start_date,
    var_line_start_date + (ewr.num_of_months::text || ' month')::interval
    FROM equipment_warranty_rule ewr
    WHERE ewr.equipment_model_id = var_model_id
    AND NOT EXISTS (SELECT * FROM equipment_warranty ew WHERE ew.equipment_id = var_equipment_id);

    -- Connect to jbilling and query the function ops_api_prov_line, for provisioning line.
    var_sql := 'SELECT * FROM oss.assign_device_jbilling( ' || quote_literal(upper(par_sales_order))
            || ' , ' || quote_literal(par_esn_hex) || ' , ' || quote_literal(var_serial_number)||' , '
            || quote_literal(var_username) || ' ,' || var_line_id || ')';

    RAISE NOTICE 'Calling oss.assign_device_jbilling in Jbilling';
    RAISE NOTICE '###  var_sql: %',var_sql;

    SELECT result_code into v_return_2  FROM public.dblink(fetch_jbilling_conn(), var_sql)
        AS rec_type (result_code boolean);

    IF (v_return_2 = FALSE) THEN
        RAISE EXCEPTION 'Jbilling Provisioning Failed.';
    ELSE
        RAISE NOTICE 'Jbilling Provisioning Successful.';
    END IF;

    var_return_row.result_code := true;
    var_return_row.error_message := 'Line assignment is done succesfully.';
    RETURN NEXT var_return_row;
    RETURN;

 END;
  $_$;

CREATE OR REPLACE FUNCTION ops_api_expire_ex(text) RETURNS SETOF ops_api_expire_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
  var_return_row                ops_api_expire_retval%ROWTYPE;
BEGIN
  select * INTO var_return_row from ops_api_expire_ex($1, false);
  RETURN NEXT var_return_row;
  RETURN;

END;
$_$;

CREATE OR REPLACE FUNCTION ops_api_expire_ex(text, boolean) RETURNS SETOF ops_api_expire_retval
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
  var_return_row                ops_api_expire_retval%ROWTYPE;

BEGIN
  PERFORM public.set_change_log_staff_id (3);

  IF par_esn_hex IS NULL OR par_esn_hex = '' THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Input ESN HEX is NULL or empty. Please enter a value.';
    RETURN NEXT var_return_row;
    RETURN;
  ELSE
    -- Validate parameters.
    SELECT equipment_id INTO var_equipment_id
    FROM unique_identifier
    WHERE unique_identifier_type = 'ESN HEX'
    AND value = par_esn_hex;

    IF NOT FOUND THEN
      var_return_row.result_code := false;
      var_return_row.error_message := 'ESN HEX value does not exists.';
      RETURN NEXT var_return_row;
      RETURN;
    END IF;
  END IF;

  -- Retrieve line_id using equipment_id
  SELECT line_id INTO var_line_id
  FROM line_equipment
  WHERE equipment_id = var_equipment_id
  AND end_date IS NULL;

  SELECT radius_username INTO var_username FROM line WHERE line_id = var_line_id;
  IF NOT FOUND THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Username does not exists for the device.';
    RETURN NEXT var_return_row;
    RETURN;
  END IF;

  -- Deallocate static IP address and delete radreply records.
  IF EXISTS (SELECT TRUE FROM radreply WHERE username LIKE var_username) THEN
    SELECT value INTO var_static_ip
    FROM radreply
    WHERE username = var_username
    AND attribute = 'Framed-IP-Address';

    IF EXISTS ( SELECT TRUE FROM static_ip_pool WHERE static_ip = var_static_ip AND line_id = var_line_id ) THEN
      UPDATE static_ip_pool SET is_assigned = 'FALSE', line_id = NULL
      WHERE static_ip = var_static_ip AND line_id = var_line_id;
    END IF;

    DELETE FROM radreply WHERE username = var_username;
    --DELETE FROM radcheck WHERE username = var_username;

  END IF;

  -- To Suspend an assigned device which is not expired
  IF (SELECT TRUE FROM username WHERE username LIKE var_username) THEN

    IF var_username ~ '@vzw' THEN
      IF NOT EXISTS( SELECT TRUE FROM usergroup WHERE username LIKE var_username AND groupname LIKE 'SERVICE-vzwretail_wallgarden_cnione') THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'SERVICE-vzwretail_wallgarden_cnione', 2);
      END IF;
    ELSE
      IF NOT EXISTS( SELECT TRUE FROM usergroup WHERE username LIKE var_username AND groupname LIKE '%disconnected' AND priority = 1) THEN
        INSERT INTO usergroup(username, groupname, priority)
        VALUES (var_username, 'disconnected', 1);
      END IF;
    END IF;

  END IF;

  IF EXISTS ( SELECT TRUE FROM line_equipment WHERE line_id = var_line_id AND end_date IS NULL) THEN
    UPDATE line_equipment SET end_date = current_date
    WHERE line_id = var_line_id
    AND equipment_id = var_equipment_id;

    -- UPDATE line end_date too
    UPDATE line SET end_date = current_date,
                    radius_username = null,
                    line_label = null
    WHERE line_id = var_line_id;
    IF NOT FOUND THEN
      var_return_row.result_code := false;
      var_return_row.error_message := 'Updating line.end_date failed.';
      RETURN NEXT var_return_row;
      RETURN;
    END IF;

  ELSE
    var_return_row.result_code := false;
    var_return_row.error_message := 'Line associated to the equipment has already expired.';
    RETURN NEXT var_return_row;
    RETURN;
  END IF ;


  /*connect to jbilling to cancel*/
  IF (par_bypass_jbilling = FALSE) THEN
    var_sql := 'SELECT * FROM oss.archive_equipment(' || quote_literal(par_esn_hex) || ')';
    FOR var_return_row IN
      SELECT * FROM public.dblink(fetch_jbilling_conn(), var_sql) AS rec_type (result_code boolean)
    LOOP
      IF (var_return_row.result_code = 'FALSE') THEN
        var_return_row.result_code := false;
        var_return_row.error_message := 'Jbilling Provisioning Failed.';
        RETURN NEXT var_return_row;
        RETURN;
      END IF;
    END LOOP;
  END IF;
  
  var_return_row.result_code := true;
  var_return_row.error_message := 'Line associated to the equipment is now expired';
  RETURN NEXT var_return_row;
  RETURN;

EXCEPTION
  WHEN OTHERS THEN
    var_return_row.result_code := false;
    var_return_row.error_message := 'Exception: Unknown exception happened.';
    RETURN NEXT var_return_row;
    RETURN;
END;
$_$;

CREATE OR REPLACE FUNCTION ops_api_static_ip_assign(text, text, text, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_carrier                   text := $1;
  par_vrf                       text := $2;
  par_username                  text := $3;
  par_line_id					integer := $4;
  par_billing_entity_id         integer := $5;
  var_static_ip                 text;
  var_check_if_has_range        text;
  v_numrows               		integer;

BEGIN
    SET client_min_messages TO notice;
    RAISE NOTICE 'ops_api_static_ip_assign is called: parameters => [carrier=%][vrf=%][username=%][line_id=%][billing_entity_id=%]', par_carrier, par_vrf, par_username, par_line_id, par_billing_entity_id;

	PERFORM public.set_change_log_staff_id(3);

    -- Check if the parameters are null
    IF par_carrier IS NULL
        OR par_username IS NULL
        OR par_line_id IS NULL
        OR par_billing_entity_id IS NULL
        OR par_vrf IS NULL
    THEN
        RAISE NOTICE 'All or some of the input values are null.';
        var_static_ip = 'ERROR - All or some of the input values are null.';
        RETURN var_static_ip;
    END IF;

	SELECT static_ip
	INTO var_check_if_has_range
	FROM static_ip_pool sip
	JOIN static_ip_carrier_def sid
	ON (sid.carrier_def_id = sip.carrier_id)
	WHERE groupname = par_vrf
	AND carrier LIKE '%'||par_carrier||'%'
	AND billing_entity_id = par_billing_entity_id
	--AND static_ip not like '166.%'
	ORDER BY billing_entity_id
	LIMIT 1;

    IF FOUND THEN
        RAISE NOTICE 'We found IP pool.';
        SELECT static_ip
          INTO var_static_ip
          FROM static_ip_pool sip
          JOIN static_ip_carrier_def sid
            ON (sid.carrier_def_id = sip.carrier_id)
         WHERE groupname = par_vrf
           AND is_assigned = FALSE
           AND carrier LIKE '%'||par_carrier||'%'
           AND billing_entity_id = par_billing_entity_id
         ORDER BY billing_entity_id , static_ip
         LIMIT 1
           FOR UPDATE;

        IF FOUND THEN
			RAISE NOTICE 'We found an available IP address in the IP pool. [IP=%]', var_static_ip;
			IF ( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

			  --Update rad_reply IP
			    INSERT INTO radreply (username, attribute, op, value, priority)
			    	VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
			ELSE 
	            --Update rad_reply Class
	            RAISE NOTICE 'Inserting Class attribute value into radreply table. [line_id=%]', par_line_id;
			    INSERT INTO radreply (username, attribute, op, value, priority)
			    	VALUES (par_username, 'Class', '=', par_line_id::text, 10);
				RAISE NOTICE 'Inserted Class attribute value into radreply table. [line_id=%]', par_line_id;

	             --Update rad_reply IP
	            RAISE NOTICE 'Inserting Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
			    INSERT INTO radreply (username, attribute, op, value, priority)
			    	VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
                       
            END IF; 

            RAISE NOTICE 'Updating static_ip_pool table for [IP=% / VRF=%]', var_static_ip, par_vrf;
			--Update static_ip_pool
			UPDATE static_ip_pool
			   SET is_assigned = 'TRUE'
                  ,line_id = par_line_id
			 WHERE static_ip = var_static_ip
  			   AND groupname = par_vrf;

            IF NOT FOUND THEN
               RAISE EXCEPTION 'OSS: Radreply Update Failed.';
                var_static_ip = 'ERROR - OSS: Radreply Update Failed.';
                RETURN var_static_ip;
			ELSE
			   RETURN var_static_ip;
            END IF;
	    ELSE
			RAISE EXCEPTION 'OSS: No avalible static IPs for ip block selected';
            var_static_ip = 'ERROR - OSS: No avalible static IPs for ip block selected.';
            RETURN var_static_ip;
		END IF;

	ELSE
        RAISE NOTICE 'No billing entity id path selected.';
		SELECT static_ip
		INTO var_static_ip
		FROM static_ip_pool sip
		JOIN static_ip_carrier_def sid
		 ON (sid.carrier_def_id = sip.carrier_id)
		WHERE groupname = par_vrf
		AND is_assigned = FALSE
		AND carrier LIKE '%'||par_carrier||'%'
		AND billing_entity_id is null
		ORDER BY static_ip
		LIMIT 1
		FOR UPDATE;

        IF FOUND THEN
        	RAISE NOTICE 'Processing radreply: Username: %, static_ip: %.', par_username, var_static_ip;
			IF( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

				--Update rad_reply IP
				INSERT INTO radreply (username, attribute, op, value, priority)
				              VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
				GET DIAGNOSTICS v_numrows = ROW_COUNT;
	    		IF v_numrows <> 1 then
			        RAISE NOTICE 'INSERT Failed for radreply, Framed-IP : username - %, var_static_ip - %', par_username, var_static_ip;
			        RAISE EXCEPTION  '';
			    END IF;

            ELSE 

                --Update rad_reply Class
				INSERT INTO radreply (username, attribute, op, value, priority)
							VALUES (par_username, 'Class', '=', par_line_id::text, 10);
				GET DIAGNOSTICS v_numrows = ROW_COUNT;
	    		IF v_numrows <> 1 then
			        RAISE NOTICE 'INSERT Failed for radreply Class: username - %, var_static_ip - %', par_username, var_static_ip;
			        RAISE EXCEPTION  '';
			    END IF;

				--Update rad_reply IP
				INSERT INTO radreply (username, attribute, op, value, priority)
				 			VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
				GET DIAGNOSTICS v_numrows = ROW_COUNT;
	    		IF v_numrows <> 1 then
			        RAISE NOTICE 'INSERT Failed for radreply 2nd Framed IP: username - %, var_static_ip - %', par_username, var_static_ip;
			        RAISE EXCEPTION  '';
			    END IF;
                       
            END IF; 
			--Update static_ip_pool
			RAISE NOTICE 'Update static_ip_pool for static_ip %: line_id - %, groupname - %', var_static_ip, par_line_id, par_vrf;
			UPDATE static_ip_pool
			 SET is_assigned = 'TRUE' ,
                         line_id = par_line_id
			WHERE static_ip = var_static_ip
			AND groupname = par_vrf;

            IF NOT FOUND THEN
                RAISE NOTICE 'OSS: Radreply Update Failed.';
                var_static_ip = 'ERROR:  OSS: Radreply Update Failed.';
                RETURN var_static_ip;
			ELSE
				RETURN var_static_ip;
            END IF;

		ELSE
			RAISE NOTICE 'Check for a valid range for par_vrf %, carrier %', par_vrf, par_carrier;
			--check input paramiters for a valid range
			SELECT static_ip
			INTO var_static_ip
			FROM static_ip_pool sip
			JOIN static_ip_carrier_def sid
			 ON (sid.carrier_def_id = sip.carrier_id)
			WHERE groupname = par_vrf
			AND carrier LIKE '%'||par_carrier||'%'
			AND billing_entity_id is null
			--AND static_ip NOT LIKE '166.%'
			ORDER BY static_ip
			LIMIT 1;

			RAISE NOTICE 'var_static_ip:  %', var_static_ip;
			IF (var_static_ip IS NOT NULL) THEN
                RAISE NOTICE 'OSS: No avalible static ips for ip block selected';
                var_static_ip = 'ERROR:  OSS: No avalible static ips for ip block selected.';
                RETURN var_static_ip;
			ELSE
                RAISE NOTICE 'OSS: No IP Block For given VRF/CARRIER combination.';
                var_static_ip = 'ERROR:  OSS: No IP Block For given VRF/CARRIER combination.';
                RETURN var_static_ip;
			END IF;
		END IF;
	END IF;
 END;
  $_$;

CREATE OR REPLACE FUNCTION ops_api_static_ip_assign_20171219(text, text, text, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE

  par_carrier                   text := $1;
  par_vrf                       text := $2;
  par_username                  text := $3;
  par_line_id			integer := $4;
  par_billing_entity_id         integer := $5;
  var_static_ip                 text;
  var_check_if_has_range        text;

BEGIN
    SET client_min_messages TO notice;
    RAISE NOTICE 'ops_api_static_ip_assign_20171219 is called: parameters => [carrier=%][vrf=%][username=%][line_id=%][billing_entity_id=%]', par_carrier, par_vrf, par_username, par_line_id, par_billing_entity_id;

	PERFORM public.set_change_log_staff_id(3);

	IF  par_carrier IS NULL THEN
	 RAISE EXCEPTION 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: CARRIER ID IS NULL';
	END IF;
	IF  par_username IS NULL THEN
	 RAISE EXCEPTION 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: USERNAME ID IS NULL';
	END IF;
	IF  par_line_id IS NULL THEN
	 RAISE EXCEPTION 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: LINE ID IS NULL';
	END IF;
	IF  par_billing_entity_id IS NULL THEN
	 RAISE EXCEPTION 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP : BILLING ENTITY IS NULL';
	END IF;
	IF  par_vrf IS NULL THEN
	 RAISE EXCEPTION 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP : GROUP NAME IS NULL';
	END IF;

	SELECT static_ip
	INTO var_check_if_has_range
	FROM static_ip_pool sip
	JOIN static_ip_carrier_def sid
	ON (sid.carrier_def_id = sip.carrier_id)
	WHERE groupname = par_vrf
	AND carrier LIKE '%'||par_carrier||'%'
	AND billing_entity_id = par_billing_entity_id
	--AND static_ip not like '166.%'
	ORDER BY billing_entity_id
	LIMIT 1;

	IF(var_check_if_has_range is not null)THEN
            RAISE NOTICE 'We found IP pool.';

		SELECT static_ip
		INTO var_static_ip
		FROM static_ip_pool sip
		JOIN static_ip_carrier_def sid
		ON (sid.carrier_def_id = sip.carrier_id)
		WHERE groupname = par_vrf
		AND is_assigned = FALSE
		AND carrier LIKE '%'||par_carrier||'%'
		AND billing_entity_id = par_billing_entity_id
		--AND static_ip NOT LIKE '166.%'
		ORDER BY billing_entity_id , static_ip
		LIMIT 1
		FOR UPDATE;

		     IF (var_static_ip IS NOT NULL) THEN
                         RAISE NOTICE 'We found an available IP address in the IP pool. [IP=%]', var_static_ip;

                       IF ( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

			  --Update rad_reply IP
			    INSERT INTO radreply (username, attribute, op, value, priority)
			      VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                            RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;

                       ELSE 

                            --Update rad_reply Class
                            RAISE NOTICE 'Inserting Class attribute value into radreply table. [line_id=%]', par_line_id;
			    INSERT INTO radreply (username, attribute, op, value, priority)
			      VALUES (par_username, 'Class', '=', par_line_id::text, 10);
                            RAISE NOTICE 'Inserted Class attribute value into radreply table. [line_id=%]', par_line_id;

                             --Update rad_reply IP
                            RAISE NOTICE 'Inserting Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
			    INSERT INTO radreply (username, attribute, op, value, priority)
			       VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                            RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
                       
                       END IF; 

                        RAISE NOTICE 'Updating static_ip_pool table for [IP=% / VRF=%]', var_static_ip, par_vrf;

			--Update static_ip_pool
			UPDATE static_ip_pool
			 SET is_assigned = 'TRUE' ,
                         line_id = par_line_id
			WHERE static_ip = var_static_ip
			AND groupname = par_vrf;

                        IF NOT FOUND THEN
                           RAISE EXCEPTION 'OSS: Radreply Update Failed.';
			ELSE
			   RETURN var_static_ip;
                        END IF;
		    ELSE
			RAISE EXCEPTION 'OSS: No avalible staic IPs for ip block selected';
		    END IF;

	    ELSE
		--no billing entity id
		SELECT static_ip
		INTO var_static_ip
		FROM static_ip_pool sip
		JOIN static_ip_carrier_def sid
		 ON (sid.carrier_def_id = sip.carrier_id)
		WHERE groupname = par_vrf
		AND is_assigned = FALSE
		AND carrier LIKE '%'||par_carrier||'%'
		AND billing_entity_id is null
		--AND static_ip NOT LIKE '166.%'
		ORDER BY static_ip
		LIMIT 1
		FOR UPDATE;

		IF (var_static_ip IS NOT NULL) THEN

                     IF( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

			--Update rad_reply IP
			INSERT INTO radreply (username, attribute, op, value, priority)
			 VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);

                      ELSE 

                          --Update rad_reply Class
			INSERT INTO radreply (username, attribute, op, value, priority)
			 VALUES (par_username, 'Class', '=', par_line_id::text, 10);

                           --Update rad_reply IP
			INSERT INTO radreply (username, attribute, op, value, priority)
			 VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                       
                       END IF; 
			--Update static_ip_pool
			UPDATE static_ip_pool
			 SET is_assigned = 'TRUE' ,
                         line_id = par_line_id
			WHERE static_ip = var_static_ip
			AND groupname = par_vrf;

                        IF NOT FOUND THEN
                           RAISE EXCEPTION 'OSS: Radreply Update Failed.';
			ELSE
			   RETURN var_static_ip;
                        END IF;

		ELSE
			--check input paramiters for a valid range
			SELECT static_ip
			INTO var_static_ip
			FROM static_ip_pool sip
			JOIN static_ip_carrier_def sid
			 ON (sid.carrier_def_id = sip.carrier_id)
			WHERE groupname = par_vrf
			AND carrier LIKE '%'||par_carrier||'%'
			AND billing_entity_id is null
			--AND static_ip NOT LIKE '166.%'
			ORDER BY static_ip
			LIMIT 1;

			IF (var_static_ip IS NOT NULL) THEN
				RAISE EXCEPTION 'OSS: No avalible staic ips for ip block selected';
			ELSE
				RAISE EXCEPTION 'OSS: No IP Block For given VRF/CARRIER combination.';
			END IF;

		END IF;
	END IF;

 END;
  $_$;

CREATE OR REPLACE FUNCTION ops_api_static_ip_assign_lo(text, text, text, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE

    par_carrier                   text := $1;
    par_vrf                       text := $2;
    par_username                  text := $3;
    par_line_id                   integer := $4;
    par_billing_entity_id         integer := $5;
    var_static_ip                 text;
    var_check_if_has_range        text;

BEGIN
    SET client_min_messages TO notice;
    RAISE NOTICE 'ops_api_static_ip_assign_lo is called: parameters => [carrier=%][vrf=%][username=%][line_id=%][billing_entity_id=%]', par_carrier, par_vrf, par_username, par_line_id, par_billing_entity_id;

    PERFORM public.set_change_log_staff_id(3);

    IF  par_carrier IS NULL THEN
        RAISE NOTICE 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: CARRIER ID IS NULL';
        var_static_ip = 'ERROR:  OSS - NOT ENOUGH PARAMETERS TO ASSIGN IP: CARRIER ID IS NULL';
        RETURN var_static_ip;
    END IF;
    IF  par_username IS NULL THEN
        RAISE NOTICE 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: USERNAME ID IS NULL';
        var_static_ip = 'ERROR:  OSS - NOT ENOUGH PARAMETERS TO ASSIGN IP: USERNAME ID IS NULL';
        RETURN var_static_ip;
    END IF;
    IF  par_line_id IS NULL THEN
        RAISE NOTICE 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP: LINE ID IS NULL';
        var_static_ip = 'ERROR:  OSS - NOT ENOUGH PARAMETERS TO ASSIGN IP: USERNAME ID IS NULL';
        RETURN var_static_ip;
    END IF;
    IF  par_billing_entity_id IS NULL THEN
        RAISE NOTICE 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP : BILLING ENTITY IS NULL';
        var_static_ip = 'ERROR:  OSS - NOT ENOUGH PARAMETERS TO ASSIGN IP : BILLING ENTITY IS NULL';
        RETURN var_static_ip;
    END IF;
    IF  par_vrf IS NULL THEN
        RAISE NOTICE 'OSS: NOT ENOUGH PARAMETERS TO ASSIGN IP : GROUP NAME IS NULL';
        var_static_ip = 'ERROR:  OSS - NOT ENOUGH PARAMETERS TO ASSIGN IP : GROUP NAME IS NULL';
        RETURN var_static_ip;
    END IF;

    SELECT static_ip
    INTO var_check_if_has_range
    FROM static_ip_pool sip
    JOIN static_ip_carrier_def sid
    ON (sid.carrier_def_id = sip.carrier_id)
    WHERE groupname = par_vrf
    AND carrier LIKE '%'||par_carrier||'%'
    AND billing_entity_id = par_billing_entity_id
    --AND static_ip not like '166.%'
    ORDER BY billing_entity_id
    LIMIT 1;

    IF FOUND THEN
        RAISE NOTICE 'We found IP pool.';
        SELECT static_ip
          INTO var_static_ip
          FROM static_ip_pool sip
          JOIN static_ip_carrier_def sid
            ON (sid.carrier_def_id = sip.carrier_id)
         WHERE groupname = par_vrf
           AND is_assigned = FALSE
           AND carrier LIKE '%'||par_carrier||'%'
           AND billing_entity_id = par_billing_entity_id
         ORDER BY billing_entity_id , static_ip
         LIMIT 1
           FOR UPDATE;
        IF FOUND THEN

            RAISE NOTICE 'Available address in the IP pool. [IP=%]', var_static_ip;

            IF ( SELECT TRUE 
                   FROM radreply 
                  WHERE username = par_username 
                    AND attribute = 'Class') THEN

                INSERT INTO radreply (username, attribute, op, value, priority)
                     VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;

            ELSE 

                --Update rad_reply Class
                RAISE NOTICE 'Inserting Class attribute value into radreply table. [line_id=%]', par_line_id;
                INSERT INTO radreply (username, attribute, op, value, priority)
                     VALUES (par_username, 'Class', '=', par_line_id::text, 10);
                RAISE NOTICE 'Inserted Class attribute value into radreply table. [line_id=%]', par_line_id;

                 --Update rad_reply IP
                RAISE NOTICE 'Inserting Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
                INSERT INTO radreply (username, attribute, op, value, priority)
                    VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                RAISE NOTICE 'Inserted Framed-IP-Address attribute value into radreply table. [IP=%]', var_static_ip;
                           
            END IF; 

            RAISE NOTICE 'Updating static_ip_pool table for [IP=% / VRF=%]', var_static_ip, par_vrf;

            --Update static_ip_pool
            UPDATE static_ip_pool
               SET is_assigned = 'TRUE' 
                  ,line_id = par_line_id
             WHERE static_ip = var_static_ip
               AND groupname = par_vrf;

            -- Check if static_ip is valid.
            IF NOT FOUND THEN
                RAISE NOTICE 'UPDATE failure to static_ip_pool.';
                var_static_ip = 'ERROR:  UPDATE failure to static_ip_pool.';
                RETURN var_static_ip;
            ELSE
                RETURN var_static_ip;
            END IF;
        ELSE
            RAISE NOTICE 'OSS: No avalible staic IPs for ip block selected';
            var_static_ip = 'ERROR:  No avalible static IPs for ip block selected.';
            RETURN var_static_ip;
        END IF;
    ELSE
        --no billing entity id
        SELECT static_ip
        INTO var_static_ip
        FROM static_ip_pool sip
        JOIN static_ip_carrier_def sid
         ON (sid.carrier_def_id = sip.carrier_id)
        WHERE groupname = par_vrf
        AND is_assigned = FALSE
        AND carrier LIKE '%'||par_carrier||'%'
        AND billing_entity_id is null
        --AND static_ip NOT LIKE '166.%'
        ORDER BY static_ip
        LIMIT 1
        FOR UPDATE;

        IF FOUND THEN

            IF( SELECT TRUE FROM radreply WHERE username = par_username AND attribute = 'Class') THEN

                --Update rad_reply IP
                INSERT INTO radreply (username, attribute, op, value, priority)
                     VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
            ELSE 

                --Update rad_reply Class
                INSERT INTO radreply (username, attribute, op, value, priority)
                 VALUES (par_username, 'Class', '=', par_line_id::text, 10);

                --Update rad_reply IP
                INSERT INTO radreply (username, attribute, op, value, priority)
                 VALUES (par_username, 'Framed-IP-Address', '=', var_static_ip::text, 10);
                       
            END IF; 
            --Update static_ip_pool
            UPDATE static_ip_pool
             SET is_assigned = 'TRUE' ,
                               line_id = par_line_id
            WHERE static_ip = var_static_ip
            AND groupname = par_vrf;

            IF NOT FOUND THEN
                RAISE NOTICE 'OSS: Radreply Update Failed.';
                var_static_ip = 'ERROR:  OSS: Radreply Update Failed.';
                RETURN var_static_ip;
            ELSE
               RETURN var_static_ip;
            END IF;

        ELSE
            --check input paramiters for a valid range
            SELECT static_ip
            INTO var_static_ip
            FROM static_ip_pool sip
            JOIN static_ip_carrier_def sid
             ON (sid.carrier_def_id = sip.carrier_id)
            WHERE groupname = par_vrf
            AND carrier LIKE '%'||par_carrier||'%'
            AND billing_entity_id is null
            --AND static_ip NOT LIKE '166.%'
            ORDER BY static_ip
            LIMIT 1;

            IF (var_static_ip IS NOT NULL) THEN
                RAISE NOTICE 'OSS: No avalible staic ips for ip block selected';
                var_static_ip = 'ERROR:  OSS: No avalible staic ips for ip block selected.';
                RETURN var_static_ip;
            ELSE
                RAISE NOTICE 'OSS: No IP Block For given VRF/CARRIER combination.';
                var_static_ip = 'ERROR:  OSS: No IP Block For given VRF/CARRIER combination.';
                RETURN var_static_ip;
            END IF;
        END IF;
    END IF;
END;
  $_$;

CREATE OR REPLACE FUNCTION rt_oss_rma(text, text, text, boolean) RETURNS oss_rma_retval
    LANGUAGE plpgsql
    AS $_$
declare
--
in_old_esn              text   :=$1;
in_new_esn              text   :=$2;
in_tracking_number      text   :=$3;
par_bypass_jbilling     boolean := $4;
v_static_ip             boolean;
c_staff_id              integer:=3;
v_result                integer;
v_return                text;
v_ip_return             text;
v_tab                   text;
v_in_count              integer;
v_esnhex                text;
v_username_lgth         integer;
v_old_username          text;
v_new_username          text;
v_new_groupname         text;
v_old_groupname         text;
v_rma_groupname         text;
v_old_mod_ext_id        integer;
v_new_mod_ext_id        integer;
v_beid                  integer;
v_bename                text;
v_line_id               text;
v_oequipid              integer;
v_old_model             text;
v_new_model             text;
v_nequipid              integer;
v_old_ip                text;
v_new_ip                text;
v_carrier               text;
v_priority              integer;
v_notes                 text;
v_lstrtdat              date;
v_lenddat               text;
v_lestrtdat             text;
v_leenddat              text;
v_return_text           text;
v_return_boolean        boolean;
v_old_sn                text;
v_new_sn                text;
v_numrows               integer;
v_count                 integer;
v_value                 text;
v_value2                text;
v_sql                   text;
v_retval                oss_rma_retval%ROWTYPE;
v_rma_so_num            text;
v_errmsg                text;

v_tmp                   text;

BEGIN

    SET client_min_messages to NOTICE;

    RAISE NOTICE '-----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------';

    v_errmsg:='Unable to set change_log_staff_id';
    RAISE NOTICE 'rt_oss_rma: setting change_log_staff_id';

    SELECT * INTO v_result FROM public.set_change_log_staff_id(c_staff_id);
    IF
        v_result = -1  or v_result=c_staff_id
    THEN
        RAISE NOTICE 'rt_oss_rma:  change_log_staff_id has been set';
    ELSE
        RAISE exception '';
    END IF;

--
    RAISE NOTICE 'rt_oss_rma: looking for new ESN in UI table: %',in_new_esn;
    v_errmsg:='New ESN: '||in_new_esn||' not found in UI table';
    SELECT count(*)  into v_count
    from unique_identifier ui
    where 1=1
       and  ui.unique_identifier_type = 'ESN HEX'
       and ui.value = in_new_esn;
    IF v_count = 0
    THEN
        RAISE NOTICE '%',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

--
    v_errmsg:='Replacement ESN cannot be currently active in line_equipment table';
    SELECT count(*) into v_count
        FROM unique_identifier ui
        JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
        where 1=1
           and ui.unique_identifier_type = 'ESN HEX'
           and ui.value = in_new_esn
           AND le.end_date IS NULL
    ;
    IF v_count > 0 then
         RAISE NOTICE 'TEST FAILED: %',v_errmsg;
         RAISE EXCEPTION '';
    END IF;
--
    
    v_errmsg:='Replacement ESN cannot have todays date as end_date in line_equipment table';    
    SELECT count(*) into v_count
        FROM unique_identifier ui
        JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
        where 1=1
           and ui.unique_identifier_type = 'ESN HEX'
           and ui.value = in_new_esn
           AND le.end_date = current_date;

    IF v_count > 0 then
         RAISE NOTICE 'TEST FAILED: %',v_errmsg;
         RAISE EXCEPTION '';
    END IF;
--
    v_errmsg:='Original ESN must be present in line_equipment with a null end date';
    SELECT count(*) into v_count
    FROM unique_identifier ui
    JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
    where 1=1
      and  ui.unique_identifier_type = 'ESN HEX'
      and ui.value = in_old_esn
      AND le.end_date IS NULL ;
--
    IF v_count = 0 then
       RAISE NOTICE 'TEST FAILED: %',v_errmsg;
       RAISE EXCEPTION '';
    END IF;
--
    v_errmsg:='Original ESN must be associated with an active line in line_equipment table';
    SELECT
        ui.value ,
        l.radius_username ,
        be.billing_entity_id ,
        be.name ,
        l.line_id ,
        ui.equipment_id ,
        l.start_date ,
        l.end_date ,
        le.start_date ,
        le.end_date ,
        l.notes
    INTO
       v_esnhex,v_old_username,v_beid, v_bename,v_line_id,v_oequipid,v_lstrtdat,v_lenddat,v_lestrtdat,v_leenddat,v_notes
    FROM unique_identifier ui
       JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
       JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
       JOIN line l ON (le.line_id = l.line_id)
       JOIN billing_entity be ON (l.billing_entity_id = be.billing_entity_id)
       WHERE 1 = 1
       AND ui.unique_identifier_type = 'ESN HEX'
       AND ui.value = in_old_esn
       AND le.end_date IS NULL
       AND l.end_date IS NULL
       ;
     IF NOT FOUND THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
     END IF;
     RAISE NOTICE '-------------------------------------------------------------------------------------------------';
     RAISE NOTICE 'Billing Entity: %: %', v_beid,v_bename;
     RAISE NOTICE '-------------------------------------------------------------------------------------------------';
---

     v_errmsg:='A serial number for replacement equipment must be present in UI table';
     SELECT value INTO v_old_sn
     FROM unique_identifier
     WHERE 1=1
       AND equipment_id = v_oequipid
       AND unique_identifier_type = 'SERIAL NUMBER';

    IF NOT FOUND
    THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

    RAISE NOTICE 'rt_oss_rma: Verifying groupname present for old username';
    v_errmsg:='The groupname for the username of the original equipment must be present in usergroup table';
    SELECT groupname INTO v_old_groupname
    FROM usergroup
    WHERE username = v_old_username
    order by priority desc
    LIMIT 1;
    IF NOT FOUND THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

    SELECT value INTO v_old_ip
    FROM radreply
    WHERE username = v_old_username
      AND attribute = 'Framed-IP-Address';
    IF NOT FOUND THEN
          RAISE NOTICE 'Static ip address not present for old username: %',v_old_username;
    END IF;

--
    v_errmsg:='Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table';

    SELECT ui.equipment_id INTO v_nequipid
    FROM unique_identifier ui
    JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
    WHERE 1 = 1
    AND ui.unique_identifier_type = 'ESN HEX'
    AND ui.value = in_new_esn
    ;
    IF NOT FOUND THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END if;
--
    v_errmsg:='Model ID for the new equipment id does not exist.';
    SELECT model_number1,e.equipment_model_id into v_new_model,v_new_mod_ext_id
    FROM equipment e
    JOIN equipment_model em ON (e.equipment_model_id=em.equipment_model_id)
    WHERE 1=1
       AND e.equipment_id=v_nequipid;
    IF NOT FOUND
    THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

    v_errmsg:='Serial number for new equipment does not exist.';
    SELECT value INTO v_new_sn
     FROM unique_identifier
     WHERE 1=1
       and equipment_id = v_nequipid
       and unique_identifier_type = 'SERIAL NUMBER';
    IF NOT FOUND
    THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

    v_errmsg:='Serial number for old equipment does not exist.';
    SELECT value INTO v_old_sn
    FROM unique_identifier
    WHERE 1=1
       and equipment_id = v_oequipid
       and unique_identifier_type = 'SERIAL NUMBER';
    IF NOT FOUND
    THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;
    RAISE NOTICE 'rt_oss_rma:  Serial number found for original esn: % equip id: %', in_old_esn,v_oequipid;
--
    v_errmsg:='Carrier for new equipment does not exist.';
    SELECT carrier INTO v_carrier
    FROM equipment e
    JOIN equipment_model em ON (e.equipment_model_id = em.equipment_model_id)
    WHERE 1=1
      AND e.equipment_id = v_nequipid;
    IF NOT FOUND
    THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;
--
    v_errmsg:='username for new equipment does not exist.';
    IF v_carrier != 'USCC' THEN
        select length(value) INTO v_username_lgth
          from unique_identifier ui 
         where ui.equipment_id = v_nequipid
           AND ui.unique_identifier_type = 'MDN';

        SELECT username INTO v_new_username
        FROM username u,
             unique_identifier ui
        WHERE 1=1
             AND substring(u.username FROM 1 FOR v_username_lgth) = ui.value
             AND ui.equipment_id=v_nequipid
             AND ui.unique_identifier_type = 'MDN'
--             AND u.end_date = to_date('2999-12-31','yyyy-mm-dd')
             ;
    ELSE
        select length(value) INTO v_username_lgth
          from unique_identifier ui 
         where ui.equipment_id = v_nequipid
           AND ui.unique_identifier_type = 'MIN';

        SELECT username INTO v_new_username
        FROM username u,
        unique_identifier ui
        WHERE 1=1
          AND substring(u.username FROM 1 FOR v_username_lgth) = ui.value
          AND ui.equipment_id=v_nequipid
          AND ui.unique_identifier_type = 'MIN'
--          AND u.end_date = to_date('2999-12-31','yyyy-mm-dd')
        ;
    END IF;
    IF NOT FOUND THEN
        RAISE NOTICE 'TEST FAILED: %',v_errmsg;
        RAISE EXCEPTION '';
    END IF;

    v_errmsg:='Obtain groupname for new equipment';
    SELECT groupname INTO v_new_groupname
    FROM groupname_default gd
    WHERE 1=1
      AND gd.carrier = v_carrier
      AND gd.billing_entity_id = v_beid;
--
    IF NOT FOUND THEN
       If v_carrier in ('SPRINT','USCC') THEN
           v_new_groupname:='SERVICE-private_atm';
           v_static_ip:=false;
       ELSE
           v_new_groupname:='SERVICE-vzwretail_cnione';
           v_static_ip:=true;
       END IF;
    ELSE
        v_static_ip:=true;
    END IF;

--
      RAISE NOTICE '----- Begin Function data ----------';
      RAISE NOTICE 'old ESN           : %',in_old_esn;
      RAISE NOTICE 'old ip            : %',v_old_ip;
      RAISE NOTICE 'old username      : %',v_old_username;
      RAISE NOTICE 'old groupname     : %',v_old_groupname;
      RAISE NOTICE 'old equipment id  : %',v_oequipid;
      RAISE NOTICE 'old model         : %',v_old_model;
      RAISE NOTICE 'new ESN           : %',in_new_esn;
      RAISE NOTICE 'new equipment id  : %',v_nequipid;
      RAISE NOTICE 'new model         : %',v_new_model;
      RAISE NOTICE 'carrier           : %',v_carrier;
      RAISE NOTICE 'billing entity    : %',v_beid;
      RAISE NOTICE 'billing entity nm : %',v_bename;
      RAISE NOTICE 'new username      : %',v_new_username;
      RAISE NOTICE 'new groupname     : %',v_new_groupname;
      RAISE NOTICE 'static ip?        : %',v_static_ip;
      RAISE NOTICE '----- End of Function data ----------';

      v_errmsg:='Update line equipment to set end date on Original equipment';
      RAISE NOTICE 'Update line_equipment for equipment_id: %',v_oequipid;
      UPDATE line_equipment set end_date = current_date
      where 1=1
        and equipment_id = v_oequipid
        and line_id = v_line_id
        and end_date is null;
      GET DIAGNOSTICS v_numrows = ROW_COUNT;
      IF v_numrows = 0 THEN
          RAISE NOTICE 'Update failed: %',v_errmsg;
          RAISE EXCEPTION '';
      END IF;
      RAISE NOTICE 'DIAG v_numrows: %',v_numrows;
--
      v_errmsg:='Unassign old static IP in static_ip_pool';
      IF v_old_ip IS NOT null
      THEN
          UPDATE static_ip_pool
             SET is_assigned = false,
             line_id = null
          WHERE 1=1
            AND static_ip = v_old_ip;
          GET DIAGNOSTICS v_numrows = ROW_COUNT;
          IF v_numrows = 0 THEN
              RAISE NOTICE 'Update failed: %',v_errmsg;
              RAISE EXCEPTION '';
          END IF;
     END IF;

     v_errmsg:='Delete rows from radreply for old username';
     DELETE FROM radreply
     WHERE  username = v_old_username;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     RAISE NOTICE 'Deleted % rows related to old username(%) rows from radreply % ',v_numrows,v_old_username;

     DELETE FROM radcheck WHERE  username = v_old_username;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     RAISE NOTICE 'Deleted % rows related to old username  from radcheck: % ',v_numrows;

--
     DELETE FROM radcheck WHERE  username = v_new_username;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     RAISE NOTICE 'Deleted % rows related to new username from radcheck: % ',v_numrows;

     v_rma_groupname:=
      ( CASE
           WHEN v_carrier = 'VZW'
            THEN 'SERVICE-rma_vzwretail_cnione'
           ELSE
              'SERVICE-rma_uscc_sprint'
         END
      );
      v_errmsg:='Obtaining priority for RMA groupname from groupname table';
      SELECT  priority FROM groupname INTO v_priority
      WHERE 1=1
        and groupname =v_rma_groupname ;
      IF NOT FOUND then
          RAISE NOTICE 'Select failed: %',v_errmsg;
          RAISE EXCEPTION  '';
      END IF;

--
      v_errmsg:='Update usergroup and priority for old username';
      v_sql:= 'UPDATE usergroup SET groupname ='||v_rma_groupname||' , priority='||v_priority ||' WHERE 1=1 AND username='||v_old_username;
      RAISE NOTICE 'this sql: %',v_sql;
      UPDATE usergroup SET groupname = v_rma_groupname , priority=v_priority
      WHERE 1=1
        AND username=v_old_username;
      GET DIAGNOSTICS v_numrows = ROW_COUNT;
      IF v_numrows <> 1 then
          RAISE NOTICE 'Update failed: %',v_errmsg;
          RAISE EXCEPTION  '';
      END IF;

--   get the priority for the new usergroup
      v_errmsg:='Obtaining priority for new groupname from groupname table';
      SELECT  priority FROM groupname INTO v_priority
      WHERE 1=1
        AND groupname = v_new_groupname ;

      GET DIAGNOSTICS v_numrows = ROW_COUNT;
      IF v_numrows <> 1 then
          RAISE NOTICE 'Select failed: %',v_errmsg;
          RAISE EXCEPTION  '';
      END IF;

--     Replace  new username data in usergroup table
--     First delete the old data  then insert the new data
      v_errmsg:='Replacing username data in usergroup table for new username';

      DELETE FROM usergroup
      where 1=1
        and username = v_new_username
/*
        and (
             groupname ='disconnected'
             or
             groupname like '%-inventory'
             or
             groupname like '%-private_atme
             or
             groupname like '%-private_atme
            )
*/
;
      RAISE NOTICE 'Deletion completed- now beginning insert of new usergroup data for username: %',v_new_username;

      INSERT into usergroup
            (username,groupname,priority)
      values
            (v_new_username,v_new_groupname,v_priority);
--

     v_errmsg:='Update line with new username and line_label';
     UPDATE line SET radius_username = v_new_username, line_label = in_new_esn
     WHERE line_id = v_line_id;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     IF v_numrows <> 1 THEN
          RAISE NOTICE 'UPDATE Failed: %',v_errmsg;
          RAISE EXCEPTION  '';
     END IF;

     SELECT end_date INTO v_tmp FROM line_equipment WHERE line_id = v_line_id AND equipment_id = v_oequipid;
     RAISE NOTICE '[rt_oss_rma] BEFORE INSERT into line_equipment: line_id=%, old_equipment_id=%, new_equipment_id=%, end_date=%', v_line_id, v_oequipid, v_nequipid, v_tmp;

--         INSERT into line_equipment
     v_errmsg:='INSERT FAILED for new row into line_equipment with new equipment id for line';
     INSERT INTO line_equipment
         ( SELECT v_line_id::integer,v_nequipid::integer,current_date,
                  null,billing_entity_address_id,ship_date,install_date,installed_by
           from line_equipment le
           where 1=1
             and le.line_id=v_line_id
             and le.equipment_id=v_oequipid
             and le.end_date =current_date);
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     IF v_numrows <> 1 then
          RAISE NOTICE 'INSERT Failed: %',v_errmsg;
          RAISE EXCEPTION  '';
     END IF;

    RAISE NOTICE '[rt_oss_rma] Inserted into line_equipment succeeded.';

    -- Insert csctoss.equipment_warranty record.

    RAISE NOTICE 'Processing equipment_warranty for new equipment id: %', v_nequipid;
    IF NOT EXISTS (SELECT * FROM equipment_warranty ew WHERE ew.equipment_id = v_nequipid)
    THEN
        RAISE NOTICE 'INSERT equipment_warranty: v_nequipid: %, start_date=%, model id=%'
                     , v_nequipid, v_lstrtdat, v_new_mod_ext_id;
        v_errmsg:='Insert/update failed for equipment_warranty, equipment_id';
        INSERT INTO equipment_warranty
        SELECT v_nequipid
              ,v_lstrtdat
              ,v_lstrtdat + (ewr.num_of_months::text || ' month')::interval
        FROM equipment_warranty_rule ewr
        WHERE ewr.equipment_model_id = v_new_mod_ext_id;
        GET DIAGNOSTICS v_numrows = ROW_COUNT;
        IF v_numrows <> 1 then
          RAISE NOTICE 'INSERT failed: %',v_errmsg;
          RAISE EXCEPTION  '';
        END IF;
    END IF;
--     assign a static ip if requested
    IF v_static_ip
    THEN
        RAISE NOTICE 'Calling function ops_api_static_ip(%,%,%,%,%)',v_carrier, v_new_groupname, v_new_username, v_line_id, v_beid;
        SELECT * into v_new_ip 
          from ops_api_static_ip_assign(v_carrier::text, 
                                        v_new_groupname::text, 
                                        v_new_username::text, 
                                        v_line_id::integer, 
                                        v_beid::integer);
        RAISE NOTICE 'ops_api_static_ip return: %', v_new_ip;
        IF substring(v_new_ip from 1 for 3) = 'ERR'
        THEN 
            v_errmsg := v_new_ip
            RAISE NOTICE '%', v_new_ip;
            RAISE EXCEPTION '';
        END IF;
    ELSE
       v_errmsg:='Insert into radreply with config variables';
       INSERT INTO radreply(username, attribute, op, value, priority) VALUES (v_new_username, 'Class', '=', v_line_id, 10);
       GET DIAGNOSTICS v_numrows = ROW_COUNT;
       IF v_numrows <> 1 then
          RAISE NOTICE 'INSERT failed: %',v_errmsg;
          RAISE EXCEPTION  '';
       END IF;

    END IF;

    IF v_carrier = 'SPRINT' THEN
        v_value:='';
        v_value2:='ClearText-Password';
    ELSIF
        v_carrier = 'USCC' THEN
        v_value:='CP@11U$ers';
        v_value2:='ClearText-Password';
    ELSIF
        v_carrier = 'VZW' THEN
        v_value:='Accept';
        v_value2:='Auth-Type';
    ELSIF
        v_carrier = 'VODAFONE' THEN
        v_value:='Accept';
        v_value2:='Auth-Type';
    ELSE
        v_errmsg:='Determine config for radcheck table';
        RAISE NOTICE 'Failed: %',v_errmsg;
        RAISE EXCEPTION  '';
    END IF;

    v_errmsg:='Insert radius config data into radcheck for new_username';
    INSERT into radcheck (username,attribute,op,value) VALUES (v_new_username,v_value2,':=',v_value);
    GET DIAGNOSTICS v_numrows = ROW_COUNT;
    IF v_numrows <> 1 then
        RAISE NOTICE 'INSERT Failed: %',v_errmsg;
        RAISE EXCEPTION  '';
    END IF;

    v_errmsg:='Insert radius config data into radcheck for old_username';
    INSERT into radcheck (username,attribute,op,value) VALUES (v_old_username,v_value2,':=',v_value);
    GET DIAGNOSTICS v_numrows = ROW_COUNT;
    IF v_numrows <> 1 then
        RAISE NOTICE 'INSERT Failed: %',v_errmsg;
        RAISE EXCEPTION  '';
    END IF;

    v_errmsg:='Set billing entity for old usename to 2';
    UPDATE username
        SET billing_entity_id = 2,
--            end_date=current_date ,
            enabled=false
    WHERE 1=1
     AND username = v_old_username;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     IF v_numrows <> 1
     then
        RAISE NOTICE 'UPDATE Failed: %',v_errmsg;
        RAISE EXCEPTION  '';
     END IF;
--
    v_errmsg:='Update username for new equipment';
    UPDATE username
           SET  billing_entity_id=v_beid,
                notes=v_notes,
                primary_service=false,
                enabled=true
    WHERE 1=1
      AND username = v_new_username;
     GET DIAGNOSTICS v_numrows = ROW_COUNT;
     IF v_numrows = 0 THEN
        RAISE NOTICE 'UPDATE Failed: %',v_errmsg;
        RAISE EXCEPTION  '';
     END IF;
    RAISE NOTICE 'rt_oss_rma: Sucessfully updated new username  ';

    SELECT model_number1 into v_old_model
    FROM equipment e
    JOIN equipment_model em ON (e.equipment_model_id=em.equipment_model_id)
    WHERE 1=1
    AND e.equipment_id=v_oequipid;

     --
    IF (par_bypass_jbilling = FALSE) THEN
        RAISE NOTICE 'Calling Jbilling to get Product Name (internal number) from item table.';

        v_sql:= 'SELECT * from oss.rt_jbilling_rma('
                    || v_beid
                    ||' , '
                    || v_new_mod_ext_id
                    ||' , '
                    ||quote_literal(in_old_esn)
                    ||' , '
                    ||quote_literal(in_new_esn)
                    ||' , '
                    ||quote_literal(v_new_sn)
                    ||' , '
                    ||quote_literal(v_new_username)
                    ||','
                    ||v_line_id
                    ||','
                    ||quote_literal(in_tracking_number)
                    ||')'  ;

        RAISE NOTICE '-----------  calling jbilling_rma ------------------------------------- ';
        RAISE NOTICE ' the sql to call jbilling_rma: %', v_sql;
        v_errmsg:='Failure within or when calling the rt_jbilling_rma() function';
    --
        SELECT rec_type.so_number INTO v_rma_so_num
        FROM public.dblink(fetch_jbilling_conn(), v_sql) AS rec_type (so_number text);
--
        RAISE NOTICE 'rt_oss_rma: Returned from Jbilling: %', v_rma_so_num ;
    END IF;

    v_retval.old_model:=v_old_model;
    v_retval.old_sn:=v_old_sn;
    v_retval.new_sn:=v_new_sn;
    v_retval.billing_entity_id:=v_beid;
    v_retval.old_equip_id:=v_oequipid;
    v_retval.new_equip_id:=v_nequipid;
    v_retval.new_model:=v_new_model;
    v_retval.rma_so_num:=v_rma_so_num;
    v_retval.line_id:=v_line_id;
    v_retval.carrier:=v_carrier;
    v_retval.username:=v_new_username;
    v_retval.old_username:=v_old_username;
    v_retval.groupname:=v_new_groupname;
    v_retval.message:='Success';

----

    RETURN v_retval;
    RAISE NOTICE '-----------  exiting rt_oss_rma function now  ---------------------------';
EXCEPTION
        WHEN raise_exception THEN
           v_retval.message:=v_errmsg;
           RAISE NOTICE 'rt_oss_rma: when raise_exception:  % ',v_errmsg;
           RETURN v_retval;

        WHEN others THEN
           v_retval.message:=v_errmsg;
           RAISE NOTICE 'rt_oss_rma: when others:  ';
           RAISE NOTICE 'rt_oss_rma: % ',v_errmsg;
           RETURN v_retval;
END;
$_$;

CREATE OR REPLACE FUNCTION username_check() RETURNS SETOF my_type2
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  c_staff_id              	integer:=3;
  var_myrow					my_type1%ROWTYPE;
  var_myrow2				my_type2%ROWTYPE;
  var_equipment_id			int;
  var_min_value				text;
  var_status				int;
  v_result                	integer;
  v_numrows               	integer;

BEGIN

--select * INTO v_result public.set_change_log_staff_id(c_staff_id);

FOR var_myrow IN 
  SELECT DISTINCT ui.equipment_id
      ,substring(l.radius_username,1,(position('@' IN l.radius_username) - 1))
      ,uim.value 
  FROM line l
  JOIN line_equipment le ON le.line_id = l.line_id
  JOIN unique_identifier ui ON le.equipment_id = ui.equipment_id
  JOIN unique_identifier uim ON le.equipment_id = uim.equipment_id AND uim.unique_identifier_type = 'MIN'
 WHERE l.end_date is NULL
   AND l.radius_username LIKE '%@uscc.net'
   AND substring(l.radius_username,1,(position('@' IN l.radius_username) - 1)) <> uim.value
 ORDER BY 2

	LOOP

		RAISE NOTICE 'EQUIPMENT_ID:    %', var_myrow.equip_id;
		RAISE NOTICE 'Username    :    %', var_myrow.rad_username;
		RAISE NOTICE 'UIM Value   :    %', var_myrow.uim_value;

		select equipment_id 
		      ,value
		  INTO var_equipment_id
		      ,var_min_value 
		  from unique_identifier 
		 where unique_identifier_type = 'MIN' 
		   and value = var_myrow.rad_username;

		var_myrow2.upd_equip_id 	:= var_myrow.equip_id;
		var_myrow2.correct_min		:= var_myrow.rad_username;
		var_myrow2.exist_min		:= var_myrow.uim_value;
		var_myrow2.related_equip_id := var_equipment_id;
		var_myrow2.related_min		:= var_min_value;

		RETURN NEXT var_myrow2;

	END LOOP;

RAISE NOTICE 'Finished Function';
RETURN;
END ;
$$;

CREATE TRIGGER _csctoss_repl_logtrigger_1270
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1270', 'kvvvvvvvvvv');

CREATE TRIGGER billing_entity_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1150
	AFTER INSERT OR UPDATE OR DELETE ON equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1150', 'kvvvvvvv');

CREATE TRIGGER equipment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1080
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1080', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER equipment_model_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_model
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1930
	AFTER INSERT OR UPDATE OR DELETE ON line
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1930', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER line_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON line
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER line_pre_delete_trig
	BEFORE DELETE ON line
	FOR EACH ROW
	EXECUTE PROCEDURE line_pre_delete();

CREATE TRIGGER line_pre_insert_trig
	BEFORE INSERT ON line
	FOR EACH ROW
	EXECUTE PROCEDURE line_pre_insert();

CREATE TRIGGER _csctoss_repl_logtrigger_1940
	AFTER INSERT OR UPDATE OR DELETE ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1940', 'kkvvvvvv');

CREATE TRIGGER line_equipment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER line_equipment_pre_insert_trig
	BEFORE INSERT ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE line_equipment_pre_insert();

CREATE TRIGGER line_equipment_pre_update_trig
	BEFORE UPDATE ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE line_equipment_pre_update();

CREATE TRIGGER _csctoss_repl_logtrigger_2480
	AFTER INSERT OR UPDATE OR DELETE ON location_labels
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2480', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1850
	AFTER INSERT OR UPDATE OR DELETE ON radreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1850', 'kvvvvv');

CREATE TRIGGER radreply_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON radreply
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER radreply_pre_insert_update_trig
	BEFORE INSERT OR UPDATE ON radreply
	FOR EACH ROW
	EXECUTE PROCEDURE radreply_pre_insert_update();

CREATE TRIGGER _csctoss_repl_logtrigger_1200
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1200', 'kkvvvv');

CREATE TRIGGER unique_identifier_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON unique_identifier
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1800
	AFTER INSERT OR UPDATE OR DELETE ON usergroup
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1800', 'kvvv');

CREATE TRIGGER usergroup_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON usergroup
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1250
	AFTER INSERT OR UPDATE OR DELETE ON address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1250', 'kvvvvvvvvv');

CREATE TRIGGER address_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON address
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1210
	AFTER INSERT OR UPDATE OR DELETE ON address_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1210', 'kv');

CREATE TRIGGER address_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON address_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2610
	AFTER INSERT OR UPDATE OR DELETE ON agreement_table
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2610', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1900
	AFTER INSERT OR UPDATE OR DELETE ON alert_activity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1900', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1870
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1870', 'kvvvvvvvvvvvvvvvv');

CREATE TRIGGER alert_definition_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON alert_definition
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1880
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_contact
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1880', 'kkvvvv');

CREATE TRIGGER alert_definition_contact_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON alert_definition_contact
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1890
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_snmp
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1890', 'kvvv');

CREATE TRIGGER alert_definition_snmp_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON alert_definition_snmp
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2340
	AFTER INSERT OR UPDATE OR DELETE ON alert_priority
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2340', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1860
	AFTER INSERT OR UPDATE OR DELETE ON alert_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1860', 'kvvvv');

CREATE TRIGGER alert_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON alert_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2350
	AFTER INSERT OR UPDATE OR DELETE ON alert_usage_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2350', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2360
	AFTER INSERT OR UPDATE OR DELETE ON alerts
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2360', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2140
	AFTER INSERT OR UPDATE OR DELETE ON api_device_login
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2140', 'kvvvvv');

CREATE TRIGGER api_device_login_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON api_device_login
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2150
	AFTER INSERT OR UPDATE OR DELETE ON api_device_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2150', 'kk');

CREATE TRIGGER api_device_parser_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON api_device_parser
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1370
	AFTER INSERT OR UPDATE OR DELETE ON api_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1370', 'kvvv');

CREATE TRIGGER api_key_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON api_key
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2160
	AFTER INSERT OR UPDATE OR DELETE ON api_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2160', 'kvvvvv');

CREATE TRIGGER api_parser_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON api_parser
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1380
	AFTER INSERT OR UPDATE OR DELETE ON api_request_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1380', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2170
	AFTER INSERT OR UPDATE OR DELETE ON api_supported_device
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2170', 'kvv');

CREATE TRIGGER api_supported_device_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON api_supported_device
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1140
	AFTER INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1140', 'kvvvv');

CREATE TRIGGER app_config_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1910
	AFTER INSERT OR UPDATE OR DELETE ON atm_processor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1910', 'kv');

CREATE TRIGGER atm_processor_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON atm_processor
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1760
	AFTER INSERT OR UPDATE OR DELETE ON attribute
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1760', 'kvv');

CREATE TRIGGER attribute_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON attribute
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1750
	AFTER INSERT OR UPDATE OR DELETE ON attribute_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1750', 'kv');

CREATE TRIGGER attribute_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON attribute_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1330
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1330', 'kkv');

CREATE TRIGGER billing_entity_address_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON billing_entity_address
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1710
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_download
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1710', 'kkvvvvvv');

CREATE TRIGGER billing_entity_download_changelog
	BEFORE INSERT OR UPDATE ON billing_entity_download
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1430
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_location_label
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1430', 'kkvv');

CREATE TRIGGER billing_entity_location_label_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON billing_entity_location_label
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1360
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1360', 'kkvv');

CREATE TRIGGER billing_entity_product_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON billing_entity_product
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1260
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1260', 'kv');

CREATE TRIGGER billing_entity_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON billing_entity_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1600
	AFTER INSERT OR UPDATE OR DELETE ON bp_aggregate_usage_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1600', 'kvvvvvvv');

CREATE TRIGGER bp_aggregate_usage_plan_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_aggregate_usage_plan
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1590
	AFTER INSERT OR UPDATE OR DELETE ON bp_allotment_adjustment_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1590', 'kkkvvv');

CREATE TRIGGER bp_allotment_adjustment_history_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_allotment_adjustment_history
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1480
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_calendar
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1480', 'kv');

CREATE TRIGGER bp_billing_calendar_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_calendar
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1490
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_period
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1490', 'kvvvv');

CREATE TRIGGER bp_billing_period_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_period
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER bp_billing_period_pre_insert_update_trig
	BEFORE INSERT OR UPDATE ON bp_billing_period
	FOR EACH ROW
	EXECUTE PROCEDURE bp_billing_period_pre_insert_update();

CREATE TRIGGER _csctoss_repl_logtrigger_1540
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1540', 'kvvvvvvvvvv');

CREATE TRIGGER bp_billing_charge_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER bp_billing_charge_pre_update_delete_trig
	BEFORE UPDATE OR DELETE ON bp_billing_charge
	FOR EACH ROW
	EXECUTE PROCEDURE bp_billing_charge_pre_update_delete();

CREATE TRIGGER _csctoss_repl_logtrigger_1610
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_discount
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1610', 'kvvvvvvv');

CREATE TRIGGER bp_billing_charge_discount_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_discount
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1560
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_onetime
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1560', 'kvv');

CREATE TRIGGER bp_billing_charge_onetime_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_onetime
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1550
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_static
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1550', 'kvvvvv');

CREATE TRIGGER bp_billing_charge_static_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_static
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1440
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1440', 'kv');

CREATE TRIGGER bp_billing_charge_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1450
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_unit
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1450', 'kv');

CREATE TRIGGER bp_billing_charge_unit_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_unit
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1570
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_usage
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1570', 'kvvvvv');

CREATE TRIGGER bp_billing_charge_usage_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_charge_usage
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER bp_billing_charge_usage_pre_insert_update_trig
	BEFORE INSERT OR UPDATE ON bp_billing_charge_usage
	FOR EACH ROW
	EXECUTE PROCEDURE bp_billing_charge_usage_pre_insert_update();

CREATE TRIGGER _csctoss_repl_logtrigger_1520
	AFTER INSERT OR UPDATE OR DELETE ON bp_master_billing_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1520', 'kvvvvvvv');

CREATE TRIGGER bp_master_billing_plan_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_master_billing_plan
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1460
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_discount_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1460', 'kv');

CREATE TRIGGER bp_billing_discount_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_discount_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1530
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_entity_preferences
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1530', 'kvvvvvvvvvvv');

CREATE TRIGGER bp_billing_entity_preferences_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_entity_preferences
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1630
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1630', 'kvvvvvv');

CREATE TRIGGER bp_billing_equipment_assignment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER bp_billing_equipment_assignment_pre_insert_trig
	BEFORE INSERT ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE bp_billing_equipment_assignment_pre_insert();

CREATE TRIGGER bp_billing_equipment_assignment_pre_update_trig
	BEFORE UPDATE ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE bp_billing_equipment_assignment_pre_update();

CREATE TRIGGER _csctoss_repl_logtrigger_1470
	AFTER INSERT OR UPDATE OR DELETE ON bp_charge_frequency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1470', 'kv');

CREATE TRIGGER bp_charge_frequency_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_charge_frequency
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1620
	AFTER INSERT OR UPDATE OR DELETE ON bp_past_due_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1620', 'kvvvvvv');

CREATE TRIGGER bp_past_due_charge_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_past_due_charge
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1640
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_billing_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1640', 'kvvvv');

CREATE TRIGGER bp_period_billing_summary_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_period_billing_summary
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1660
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_change_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1660', 'kkv');

CREATE TRIGGER bp_period_change_summary_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_period_change_summary
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1650
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_charge_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1650', 'kvvvvvvvv');

CREATE TRIGGER bp_period_charge_summary_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_period_charge_summary
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1680
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_status_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1680', 'kkvvv');

CREATE TRIGGER bp_period_status_summary_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_period_status_summary
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1670
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1670', 'kvvvvvv');

CREATE TRIGGER bp_period_usage_summary_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_period_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1580
	AFTER INSERT OR UPDATE OR DELETE ON bp_usage_allotment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1580', 'kvvvv');

CREATE TRIGGER bp_usage_allotment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON bp_usage_allotment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2060
	AFTER INSERT OR UPDATE OR DELETE ON branding_button
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2060', 'kkvvvvv');

CREATE TRIGGER branding_button_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON branding_button
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2070
	AFTER INSERT OR UPDATE OR DELETE ON branding_content
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2070', 'kvvvvvvvvvvvvv');

CREATE TRIGGER branding_content_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON branding_content
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2080
	AFTER INSERT OR UPDATE OR DELETE ON branding_presentation
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2080', 'kvvvvv');

CREATE TRIGGER branding_presentation_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON branding_presentation
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1740
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1740', 'kvvvvvvvvv');

CREATE TRIGGER broadcast_message_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON broadcast_message
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1720
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1720', 'kvvvv');

CREATE TRIGGER broadcast_message_level_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON broadcast_message_level
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1730
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1730', 'kv');

CREATE TRIGGER broadcast_message_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON broadcast_message_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1390
	AFTER INSERT OR UPDATE OR DELETE ON plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1390', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER plan_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON plan
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER plan_log_pre_update
	BEFORE UPDATE ON plan
	FOR EACH ROW
	EXECUTE PROCEDURE plan_log_pre_update();

CREATE TRIGGER _csctoss_repl_logtrigger_1350
	AFTER INSERT OR UPDATE OR DELETE ON product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1350', 'kvvvvvvvvv');

CREATE TRIGGER product_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON product
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1510
	AFTER INSERT OR UPDATE OR DELETE ON carrier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1510', 'kvv');

CREATE TRIGGER carrier_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON carrier
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2240
	AFTER INSERT OR UPDATE OR DELETE ON carrier_api_activity_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2240', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2050
	AFTER INSERT OR UPDATE OR DELETE ON carrier_domain
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2050', 'kkv');

CREATE TRIGGER carrier_domain_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON carrier_domain
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2000
	AFTER INSERT OR UPDATE OR DELETE ON cc_auth_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2000', 'kvvvvvvv');

CREATE TRIGGER cc_auth_log_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON cc_auth_log
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2010
	AFTER INSERT OR UPDATE OR DELETE ON cc_encrypt_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2010', 'kvvvv');

CREATE TRIGGER cc_encrypt_key_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON cc_encrypt_key
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1030
	AFTER INSERT OR UPDATE OR DELETE ON change_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1030', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2510
	AFTER INSERT OR UPDATE OR DELETE ON config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2510', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2520
	AFTER INSERT OR UPDATE OR DELETE ON config_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2520', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1300
	AFTER INSERT OR UPDATE OR DELETE ON contact
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1300', 'kvvvvvvvvvvvvv');

CREATE TRIGGER contact_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON contact
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1340
	AFTER INSERT OR UPDATE OR DELETE ON contact_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1340', 'kkv');

CREATE TRIGGER contact_address_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON contact_address
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1280
	AFTER INSERT OR UPDATE OR DELETE ON contact_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1280', 'kv');

CREATE TRIGGER contact_level_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON contact_level
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1290
	AFTER INSERT OR UPDATE OR DELETE ON contact_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1290', 'kv');

CREATE TRIGGER contact_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON contact_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1500
	AFTER INSERT OR UPDATE OR DELETE ON currency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1500', 'kvvv');

CREATE TRIGGER currency_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON currency
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2500
	AFTER INSERT OR UPDATE OR DELETE ON device_monitor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2500', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1700
	AFTER INSERT OR UPDATE OR DELETE ON download_file_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1700', 'kv');

CREATE TRIGGER download_file_type_changelog
	BEFORE INSERT OR UPDATE ON download_file_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2180', 'kvvvvv');

CREATE TRIGGER equipment_credential_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_credential
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER equipment_credential_pre_insert_update_trig
	BEFORE INSERT OR UPDATE ON equipment_credential
	FOR EACH ROW
	EXECUTE PROCEDURE equipment_credential_pre_insert_update();

CREATE TRIGGER _csctoss_repl_logtrigger_2190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_firmware
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2190', 'kvvv');

CREATE TRIGGER equipment_firmware_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_firmware
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1160
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1160', 'kkv');

CREATE TRIGGER equipment_info_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_info
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1070
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1070', 'kvv');

CREATE TRIGGER equipment_info_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_info_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2200
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2200', 'kkvvvv');

CREATE TRIGGER emod_credential_pre_insert_update_trig
	BEFORE INSERT OR UPDATE ON equipment_model_credential
	FOR EACH ROW
	EXECUTE PROCEDURE emod_credential_pre_insert_update();

CREATE TRIGGER equipment_model_credential_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_model_credential
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2370
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2370', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1170
	AFTER INSERT OR UPDATE OR DELETE ON equipment_note
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1170', 'kkvvvv');

CREATE TRIGGER equipment_note_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_note
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1180', 'kkvvv');

CREATE TRIGGER equipment_software_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_software
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1190', 'kvvv');

CREATE TRIGGER equipment_status_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_status
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1110
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1110', 'kv');

CREATE TRIGGER equipment_status_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_status_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1100
	AFTER INSERT OR UPDATE OR DELETE ON equipment_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1100', 'kvvvv');

CREATE TRIGGER equipment_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1780
	AFTER INSERT OR UPDATE OR DELETE ON username
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1780', 'kvvvvvvvv');

CREATE TRIGGER username_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON username
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2560
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2560', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2580
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty_rule
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2580', 'kv');

CREATE TRIGGER equipment_warranty_rule_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON equipment_warranty_rule
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2530
	AFTER INSERT OR UPDATE OR DELETE ON firmware
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2530', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2540
	AFTER INSERT OR UPDATE OR DELETE ON firmware_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2540', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1790
	AFTER INSERT OR UPDATE OR DELETE ON groupname
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1790', 'kvvvvv');

CREATE TRIGGER groupname_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON groupname
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2250
	AFTER INSERT OR UPDATE OR DELETE ON groupname_default
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2250', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1040
	AFTER INSERT OR UPDATE OR DELETE ON last_change_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1040', 'vvk');

CREATE TRIGGER _csctoss_repl_logtrigger_2260
	AFTER INSERT OR UPDATE OR DELETE ON line_alert
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2260', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2270
	AFTER INSERT OR UPDATE OR DELETE ON line_alert_email
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2270', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1920
	AFTER INSERT OR UPDATE OR DELETE ON line_assignment_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1920', 'kv');

CREATE TRIGGER line_assignment_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON line_assignment_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1950
	AFTER INSERT OR UPDATE OR DELETE ON line_terminal
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1950', 'kvv');

CREATE TRIGGER line_terminal_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON line_terminal
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1970
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_day
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1970', 'kvkvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2330
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_day_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2330', 'kvkvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1980
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_month
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1980', 'kkkvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2280
	AFTER INSERT OR UPDATE OR DELETE ON line_usage_overage_calc
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2280', 'kvkvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2230
	AFTER INSERT OR UPDATE OR DELETE ON lns_lookup
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2230', 'kvvvv');

CREATE TRIGGER lns_lookup_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON lns_lookup
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1220
	AFTER INSERT OR UPDATE OR DELETE ON location_label_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1220', 'kv');

CREATE TRIGGER location_label_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON location_label_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1310
	AFTER INSERT OR UPDATE OR DELETE ON login_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1310', 'kkkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_7000
	AFTER INSERT OR UPDATE OR DELETE ON master_radpostauth
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '7000', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1960
	AFTER INSERT OR UPDATE OR DELETE ON mrad_duplicate
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1960', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1810
	AFTER INSERT OR UPDATE OR DELETE ON nas
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1810', 'kvvvvvvv');

CREATE TRIGGER nas_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON nas
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2570
	AFTER INSERT OR UPDATE OR DELETE ON soup_config_info
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2570', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2490
	AFTER INSERT OR UPDATE OR DELETE ON oss_jbill_billing_entity_mapping
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2490', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_5300
	AFTER INSERT OR UPDATE OR DELETE ON otaps_monthly_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5300', 'kvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5310
	AFTER INSERT OR UPDATE OR DELETE ON otaps_product_code_translation
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5310', 'vkvkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2550
	AFTER INSERT OR UPDATE OR DELETE ON otaps_service_line_number
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2550', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2040
	AFTER INSERT OR UPDATE OR DELETE ON parser_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2040', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2020
	AFTER INSERT OR UPDATE OR DELETE ON plan_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2020', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1230
	AFTER INSERT OR UPDATE OR DELETE ON plan_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1230', 'kv');

CREATE TRIGGER plan_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON plan_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1690
	AFTER INSERT OR UPDATE OR DELETE ON portal_properties
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1690', 'kv');

CREATE TRIGGER portal_properties_changelog
	BEFORE INSERT OR UPDATE ON portal_properties
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2290
	AFTER INSERT OR UPDATE OR DELETE ON product_overage_threshold
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2290', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2130
	AFTER INSERT OR UPDATE OR DELETE ON purchase_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2130', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1820
	AFTER INSERT OR UPDATE OR DELETE ON radcheck
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1820', 'kvvvv');

CREATE TRIGGER radcheck_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON radcheck
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1830
	AFTER INSERT OR UPDATE OR DELETE ON radgroupcheck
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1830', 'kvvvv');

CREATE TRIGGER radgroupcheck_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON radgroupcheck
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1840
	AFTER INSERT OR UPDATE OR DELETE ON radgroupreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1840', 'kvvvv');

CREATE TRIGGER radgroupreply_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON radgroupreply
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2590
	AFTER INSERT OR UPDATE OR DELETE ON radius_operator
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2590', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1120
	AFTER INSERT OR UPDATE OR DELETE ON receiving_lot
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1120', 'kvvvvvvvvvvv');

CREATE TRIGGER receiving_lot_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON receiving_lot
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1060
	AFTER INSERT OR UPDATE OR DELETE ON replication_failure
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1060', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1400
	AFTER INSERT OR UPDATE OR DELETE ON report
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1400', 'kvvvvvvvvvvv');

CREATE TRIGGER report_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON report
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2600
	AFTER INSERT OR UPDATE OR DELETE ON rma_form
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2600', 'kvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1990
	AFTER INSERT OR UPDATE OR DELETE ON sales_order
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1990', 'kv');

CREATE TRIGGER sales_order_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON sales_order
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1320
	AFTER INSERT OR UPDATE OR DELETE ON security_roles
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1320', 'kvv');

CREATE TRIGGER security_roles_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON security_roles
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1410
	AFTER INSERT OR UPDATE OR DELETE ON shipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1410', 'kvvvvvvvvvvvv');

CREATE TRIGGER shipment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON shipment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1420
	AFTER INSERT OR UPDATE OR DELETE ON shipment_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1420', 'kkvv');

CREATE TRIGGER shipment_equipment_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON shipment_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1130
	AFTER INSERT OR UPDATE OR DELETE ON software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1130', 'kvvvv');

CREATE TRIGGER software_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON software
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2300
	AFTER INSERT OR UPDATE OR DELETE ON soup_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2300', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2090
	AFTER INSERT OR UPDATE OR DELETE ON soup_device
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2090', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2310
	AFTER INSERT OR UPDATE OR DELETE ON soup_dirnames
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2310', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2320
	AFTER INSERT OR UPDATE OR DELETE ON sprint_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2320', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2400
	AFTER INSERT OR UPDATE OR DELETE ON sprint_csa
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2400', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_8000
	AFTER INSERT OR UPDATE OR DELETE ON sprint_master_radacct
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '8000', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2390
	AFTER INSERT OR UPDATE OR DELETE ON sprint_msl
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2390', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1010
	AFTER INSERT OR UPDATE OR DELETE ON staff
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1010', 'kvvv');

CREATE TRIGGER staff_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON staff
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1020
	AFTER INSERT OR UPDATE OR DELETE ON staff_access
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1020', 'kk');

CREATE TRIGGER staff_access_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON staff_access
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_1240
	AFTER INSERT OR UPDATE OR DELETE ON state_code
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1240', 'kvv');

CREATE TRIGGER state_code_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON state_code
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2410
	AFTER INSERT OR UPDATE OR DELETE ON static_ip_carrier_def
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2410', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2380
	AFTER INSERT OR UPDATE OR DELETE ON static_ip_pool
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2380', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1000
	AFTER INSERT OR UPDATE OR DELETE ON system_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1000', 'kvvvvvvvvv');

CREATE TRIGGER system_parameter_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON system_parameter
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2110
	AFTER INSERT OR UPDATE OR DELETE ON throw_away_minutes
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2110', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1050
	AFTER INSERT OR UPDATE OR DELETE ON timezone
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1050', 'kvv');

CREATE TRIGGER timezone_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON timezone
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2420
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2420', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1090
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1090', 'kvv');

CREATE TRIGGER unique_identifier_type_changelog
	BEFORE INSERT OR UPDATE OR DELETE ON unique_identifier_type
	FOR EACH ROW
	EXECUTE PROCEDURE public.change_log('change_log', ',');

CREATE TRIGGER _csctoss_repl_logtrigger_2120
	AFTER INSERT OR UPDATE OR DELETE ON usergroup_error_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2120', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2470
	AFTER INSERT OR UPDATE OR DELETE ON userlevels
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2470', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2430
	AFTER INSERT OR UPDATE OR DELETE ON webui_users
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2430', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE VIEW active_lines_vw AS
	SELECT be.billing_entity_id, be.name AS billing_entity_name, line.line_id, line.radius_username, (line.start_date)::date AS line_start_date, (line.end_date)::date AS line_end_date, le.equipment_id, le.start_date AS equip_start_date, le.end_date AS equip_end_date, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text))) AS sn, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'MDN'::text))) AS mdn, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'MIN'::text))) AS min, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'ESN HEX'::text))) AS esn_hex, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'ESN DEC'::text))) AS esn_dec, em.model_number1 AS equipment_model, em.model_note, em.vendor, loc.id AS location_id, loc."owner" AS location_owner, loc.name AS location_name, loc.address AS location_address, loc.processor AS location_processor, array_to_string(ARRAY(SELECT usergroup.groupname FROM usergroup WHERE ((usergroup.username)::text = line.radius_username)), ':'::text) AS groupname, (SELECT radreply.value FROM radreply WHERE (((radreply.username)::text = line.radius_username) AND ((radreply.attribute)::text = 'Framed-IP-Address'::text))) AS static_ip_address, timezone('EST'::text, mrad.last_connected_timestamp_for_last30_days_est) AS last_connected_timestamp_for_last30_days_est, mrad.usage_mb_for_last30_days FROM ((((((billing_entity be JOIN line ON ((be.billing_entity_id = line.billing_entity_id))) JOIN line_equipment le ON ((line.line_id = le.line_id))) JOIN equipment eq ON ((le.equipment_id = eq.equipment_id))) JOIN equipment_model em ON ((eq.equipment_model_id = em.equipment_model_id))) LEFT JOIN location_labels loc ON ((loc.line_id = line.line_id))) LEFT JOIN public.dblink((SELECT fetch_csctlog_conn.fetch_csctlog_conn FROM fetch_csctlog_conn()), '\012SET TimeZone TO EST5EDT;\012SELECT\012  username,\012  MAX(acctstarttime::timestamp(0)) AS last_connected_timestamp_for_last30_days_est,\012  TRUNC(SUM(acctinputoctets + acctoutputoctets) / 1024 / 1024, 2) AS usage_mb_for_last30_days\012FROM csctlog.master_radacct mrad\012WHERE 1 = 1\012AND acctstarttime >= (now() - ''30 days''::INTERVAL)\012GROUP BY username\012'::text) mrad(username text, last_connected_timestamp_for_last30_days_est timestamp with time zone, usage_mb_for_last30_days numeric) ON ((line.radius_username = mrad.username))) WHERE (((1 = 1) AND (line.end_date IS NULL)) AND (le.end_date IS NULL));

CREATE VIEW device_monitor_vw AS
	SELECT be.billing_entity_id, be.name AS billing_entity_name, line.line_id, line.radius_username, (line.start_date)::date AS line_start_date, (line.end_date)::date AS line_end_date, le.equipment_id, le.start_date AS equip_start_date, le.end_date AS equip_end_date, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text))) AS sn, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'MDN'::text))) AS mdn, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'MIN'::text))) AS min, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'ESN HEX'::text))) AS esn_hex, (SELECT unique_identifier.value FROM unique_identifier WHERE ((le.equipment_id = unique_identifier.equipment_id) AND (unique_identifier.unique_identifier_type = 'ESN DEC'::text))) AS esn_dec, em.model_number1 AS equipment_model, em.model_note, em.vendor, loc.id AS location_id, loc."owner" AS location_owner, loc.name AS location_name, loc.address AS location_address, loc.processor AS location_processor, ARRAY(SELECT usergroup.groupname FROM usergroup WHERE ((usergroup.username)::text = line.radius_username)) AS groupname, (SELECT radreply.value FROM radreply WHERE (((radreply.username)::text = line.radius_username) AND ((radreply.attribute)::text = 'Framed-IP-Address'::text))) AS static_ip_address, mrad.total_usage_bytes_data_for_last30days AS last_connected_timestamp_for_last30days FROM ((((((billing_entity be JOIN line ON ((be.billing_entity_id = line.billing_entity_id))) JOIN line_equipment le ON ((line.line_id = le.line_id))) JOIN equipment eq ON ((le.equipment_id = eq.equipment_id))) JOIN equipment_model em ON ((eq.equipment_model_id = em.equipment_model_id))) LEFT JOIN location_labels loc ON ((loc.line_id = line.line_id))) LEFT JOIN public.dblink((SELECT fetch_csctlog_conn.fetch_csctlog_conn FROM fetch_csctlog_conn()), '\012SELECT\012  username,\012  MAX(acctstarttime::timestamp(0)) AS last_connected_timestamp,\012  SUM(acctinputoctets + acctoutputoctets) AS total_usage_data_for_last30days\012FROM csctlog.master_radacct mrad\012WHERE 1 = 1\012AND acctstarttime >= (now() - ''30 days''::INTERVAL)\012GROUP BY username\012'::text) mrad(username text, last_connected_timestamp timestamp with time zone, total_usage_bytes_data_for_last30days bigint) ON ((line.radius_username = mrad.username))) WHERE ((1 = 1) AND (eq.equipment_id IN (SELECT unique_identifier.equipment_id FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AND (unique_identifier.value IN (SELECT device_monitor.serial_number FROM device_monitor))))));

CREATE VIEW oss_jbill_plan_comparison_vw AS
	SELECT be.billing_entity_id AS oss_billing_entity_id, be.name AS oss_billing_entity_name, line.line_id, line.radius_username AS oss_radius_username, line.start_date AS line_start_date, line.end_date AS line_end_date, prd.product_code AS oss_product_code, jbill.internal_number AS jbill_product_code, jbill.public_number AS jbill_public_number, jbill.order_internal_number FROM (((((billing_entity be JOIN line ON ((be.billing_entity_id = line.billing_entity_id))) JOIN line_equipment le ON ((line.line_id = le.line_id))) JOIN plan ON ((line.line_id = plan.line_id))) JOIN product prd ON ((prd.product_id = plan.product_id))) LEFT JOIN public.dblink((SELECT fetch_jbilling_conn.fetch_jbilling_conn FROM fetch_jbilling_conn()), '\012SELECT\012  pl.line_id,\012  pl.item_id,\012  item.internal_number,\012  po.public_number,\012  (SELECT internal_number FROM order_line ol\012   JOIN item i ON (ol.item_id = i.id)\012   JOIN item_type_map itm2 ON (itm2.item_id = ol.item_id)\012   WHERE ol.order_id = po.id\012   AND itm2.type_id = 301\012   AND i.internal_number LIKE ''MRC-%'') AS order_internal_number\012FROM purchase_order po\012JOIN prov_line pl ON (po.id = pl.order_id)\012JOIN item ON (pl.item_id = item.id)\012JOIN item_type_map itm ON (item.id = itm.item_id)\012WHERE 1 = 1\012AND itm.type_id = 301\012AND archived is null\012'::text) jbill(line_id integer, item_id integer, internal_number text, public_number text, order_internal_number text) ON ((line.line_id = jbill.line_id))) WHERE ((1 = 1) AND (le.end_date IS NULL)) ORDER BY be.billing_entity_id, line.line_id;

CREATE VIEW oss_sync_ip_activity_vw AS
	SELECT rec_type.acctstarttime, rec_type.acctstoptime, rec_type.framedipaddress, rec_type."class" FROM public.dblink((SELECT fetch_csctlog_conn.fetch_csctlog_conn FROM fetch_csctlog_conn()), 'select acctstarttime::timestamp, acctstoptime::timestamp, framedipaddress, class\012                          from csctlog.master_radacct\012                         where acctstarttime  > current_timestamp - interval ''26 hours''\012                           and (  acctstarttime > current_timestamp - interval ''2 hours''\012                               or acctstoptime  > current_timestamp - interval ''2 hours''\012                               or acctstoptime is null\012                               )\012                      order by acctstarttime'::text) rec_type(acctstarttime timestamp without time zone, acctstoptime timestamp without time zone, framedipaddress inet, "class" character varying);

CREATE VIEW oss_sync_line_mrac_vw AS
	SELECT rec_type.master_radacctid, rec_type."class", rec_type.acctstarttime, rec_type.acctstoptime, rec_type.framedipaddress FROM public.dblink((SELECT fetch_csctlog_conn.fetch_csctlog_conn FROM fetch_csctlog_conn()), 'select master_radacctid, class::integer, acctstarttime, acctstoptime, framedipaddress\012                          from csctlog.master_radacct\012                         where master_radacctid in\012                               (select max(master_radacctid)\012                                  from master_radacct\012                                 where class > ''0''\012                                   and class <> ''classtest''\012                                   and connectinfo_start is not null\012                                   and acctstarttime >= current_date-2\012                                   and acctstarttime <= current_date+1\012                              group by class)'::text) rec_type(master_radacctid bigint, "class" integer, acctstarttime timestamp with time zone, acctstoptime timestamp with time zone, framedipaddress inet);

CREATE VIEW portal_active_lines_vw AS
	SELECT line.line_id, (line.start_date)::date AS line_start_date, (line.end_date)::date AS line_end_date, line.radius_username, em.model_number1 AS equipment_model_number, em.carrier AS equipment_carrier, em.make AS equipment_maker, em.vendor AS equipment_vendor, prd.product_code, plan."comment" AS sales_order_number, (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'ESN HEX'::text) AND (unique_identifier.equipment_id = lieq.equipment_id))) AS esn_hex, (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AND (unique_identifier.equipment_id = lieq.equipment_id))) AS serial_number, liloc."owner" AS location_owner, liloc.id AS location_id, liloc.address AS location_address, liloc.name AS location_name, liloc.processor AS location_processor, (SELECT soup_cellsignal.cellsignal FROM soup_cellsignal WHERE ((soup_cellsignal.esn1 = (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'ESN HEX'::text) AND (unique_identifier.equipment_id = lieq.equipment_id)))) OR (soup_cellsignal.esn2 = (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'ESN HEX'::text) AND (unique_identifier.equipment_id = lieq.equipment_id))))) ORDER BY soup_cellsignal."timestamp" DESC LIMIT 1) AS cellsignal, CASE WHEN (line.radius_username IS NOT NULL) THEN (COALESCE((SELECT radreply.value FROM radreply WHERE (((radreply.attribute)::text = 'Framed-IP-Address'::text) AND ((radreply.username)::text = line.radius_username))), ('N/A'::text)::character varying))::text ELSE 'IP Not Avalible'::text END AS static_ip_address, be.name, (SELECT ops_get_connection_status.ops_get_connection_status FROM ops_get_connection_status(line.radius_username)) AS connection_status, COALESCE((SELECT (max(master_radacct.acctstarttime))::text AS max FROM master_radacct WHERE ((master_radacct.username)::text = line.radius_username) GROUP BY master_radacct.username), 'No connections in last 3 months'::text) AS last_connected_timestamp, (SELECT soup_device_stats_table.firmware FROM soup_device_stats_table WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AND (unique_identifier.equipment_id = lieq.equipment_id)))) ORDER BY soup_device_stats_table.datetime DESC LIMIT 1) AS firmware_version, (ew.warranty_start_date)::date AS warranty_start_date, (ew.warranty_end_date)::date AS warranty_end_date, CASE WHEN ((ew.warranty_end_date)::date >= ('now'::text)::date) THEN 'In warranty'::text ELSE 'Out of warranty'::text END AS warranty_status, sci.config_name AS soup_config_name, (SELECT CASE WHEN ((SELECT count(*) AS count FROM master_radacct WHERE ((master_radacct.username)::text = line.radius_username)) = 0) THEN 'NO'::text ELSE CASE WHEN ((SELECT count(*) AS count FROM master_radacct mrad WHERE (((((mrad.username)::text = line.radius_username) AND (mrad.acctstarttime >= (('now'::text)::timestamp(6) with time zone - '1 mon'::interval))) AND (mrad.master_radacctid = (SELECT max(mrad2.master_radacctid) AS max FROM master_radacct mrad2 WHERE ((mrad2.username)::text = (mrad.username)::text)))) AND (mrad.acctstoptime IS NULL))) = 1) THEN 'YES'::text ELSE 'NO'::text END END AS "case") AS is_connected, (SELECT ops_get_config_status.ops_get_config_status FROM ops_get_config_status(sci.config_name)) AS config_status, (SELECT ops_get_firmware_status.ops_get_firmware_status FROM ops_get_firmware_status((SELECT soup_device_stats_table.firmware FROM soup_device_stats_table WHERE (soup_device_stats_table.serial_number = (SELECT unique_identifier.value FROM unique_identifier WHERE ((unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AND (unique_identifier.equipment_id = lieq.equipment_id)))) ORDER BY soup_device_stats_table.datetime DESC LIMIT 1))) AS firmware_status, be.billing_entity_id, be.parent_billing_entity_id FROM ((((((((((line JOIN billing_entity be ON ((line.billing_entity_id = be.billing_entity_id))) LEFT JOIN plan ON ((line.line_id = plan.line_id))) LEFT JOIN product prd ON ((plan.product_id = prd.product_id))) LEFT JOIN line_equipment lieq ON ((line.line_id = lieq.line_id))) LEFT JOIN equipment eq ON ((lieq.equipment_id = eq.equipment_id))) LEFT JOIN equipment_model em ON ((eq.equipment_model_id = em.equipment_model_id))) LEFT JOIN location_labels liloc ON ((line.line_id = liloc.line_id))) LEFT JOIN usergroup ug ON ((((ug.username)::text = line.radius_username) AND ((ug.groupname)::text = 'userdisconnected'::text)))) LEFT JOIN equipment_warranty ew ON ((eq.equipment_id = ew.equipment_id))) LEFT JOIN soup_config_info sci ON ((sci.equipment_id = eq.equipment_id))) WHERE ((((1 = 1) AND (lieq.end_date IS NULL)) AND (line.end_date IS NULL)) AND (line.radius_username IS NOT NULL));

CREATE VIEW session_history_last30days_vw AS
	SELECT be.name AS billing_entity_name, line.radius_username AS username, mrad.acctterminatecause, sum(mrad.num_of_conn) AS num_of_conn FROM ((billing_entity be JOIN line ON ((be.billing_entity_id = line.billing_entity_id))) JOIN public.dblink((SELECT fetch_csctlog_conn.fetch_csctlog_conn FROM fetch_csctlog_conn()), '\012SELECT\012  username, acctterminatecause, COUNT(*) AS num_of_conn\012FROM csctlog.master_radacct\012WHERE 1 = 1\012AND acctstarttime >= (current_timestamp - ''30 days''::interval)\012GROUP BY username, acctterminatecause\012'::text) mrad(username text, acctterminatecause text, num_of_conn bigint) ON ((line.radius_username = mrad.username))) GROUP BY be.name, line.radius_username, mrad.acctterminatecause ORDER BY be.name, line.radius_username, mrad.acctterminatecause;

SET search_path = invoice, pg_catalog;

DROP TRIGGER _csctoss_repl_denyaccess_2440 ON app_config;

DROP TRIGGER _csctoss_repl_denyaccess_2450 ON billing_entity;

DROP TRIGGER _csctoss_repl_denyaccess_2460 ON file_system;

ALTER TABLE app_config
	ALTER COLUMN app_config_id SET DEFAULT nextval('invoice.app_config_app_config_id_seq'::text);

ALTER TABLE billing_entity
	ALTER COLUMN billing_entity_id SET DEFAULT nextval('invoice.billing_entity_billing_entity_id_seq'::text);

ALTER TABLE file_system
	ALTER COLUMN document_id SET DEFAULT nextval('invoice.file_system_document_id_seq'::text);

CREATE TRIGGER _csctoss_repl_logtrigger_2440
	AFTER INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2440', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2450
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2450', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2460
	AFTER INSERT OR UPDATE OR DELETE ON file_system
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2460', 'kvvvvvv');

SET search_path = rt3, pg_catalog;

DROP TRIGGER _csctoss_repl_denyaccess_5000 ON acl;

DROP TRIGGER _csctoss_repl_denyaccess_5010 ON attachments;

DROP TRIGGER _csctoss_repl_denyaccess_5020 ON attributes;

DROP TRIGGER _csctoss_repl_denyaccess_5030 ON cachedgroupmembers;

DROP TRIGGER _csctoss_repl_denyaccess_5040 ON customfields;

DROP TRIGGER _csctoss_repl_denyaccess_5050 ON customfieldvalues;

DROP TRIGGER _csctoss_repl_denyaccess_5060 ON groupmembers;

DROP TRIGGER _csctoss_repl_denyaccess_5070 ON groups;

DROP TRIGGER _csctoss_repl_denyaccess_5080 ON links;

DROP TRIGGER _csctoss_repl_denyaccess_5090 ON objectcustomfields;

DROP TRIGGER _csctoss_repl_denyaccess_5100 ON objectcustomfieldvalues;

DROP TRIGGER _csctoss_repl_denyaccess_5110 ON principals;

DROP TRIGGER _csctoss_repl_denyaccess_5120 ON queues;

DROP TRIGGER _csctoss_repl_denyaccess_5180 ON tickets;

DROP TRIGGER _csctoss_repl_denyaccess_5200 ON users;

DROP TRIGGER _csctoss_repl_denyaccess_5130 ON scripactions;

DROP TRIGGER _csctoss_repl_denyaccess_5140 ON scripconditions;

DROP TRIGGER _csctoss_repl_denyaccess_5150 ON scrips;

DROP TRIGGER _csctoss_repl_denyaccess_5160 ON sessions;

DROP TRIGGER _csctoss_repl_denyaccess_5170 ON templates;

DROP TRIGGER _csctoss_repl_denyaccess_5190 ON transactions;

ALTER TABLE acl
	ALTER COLUMN id SET DEFAULT nextval('acl_id_seq'::text);

ALTER TABLE attachments
	ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::text);

ALTER TABLE attributes
	ALTER COLUMN id SET DEFAULT nextval('attributes_id_seq'::text);

ALTER TABLE cachedgroupmembers
	ALTER COLUMN id SET DEFAULT nextval('cachedgroupmembers_id_seq'::text);

ALTER TABLE customfields
	ALTER COLUMN id SET DEFAULT nextval('customfields_id_seq'::text);

ALTER TABLE customfieldvalues
	ALTER COLUMN id SET DEFAULT nextval('customfieldvalues_id_seq'::text);

ALTER TABLE groupmembers
	ALTER COLUMN id SET DEFAULT nextval('groupmembers_id_seq'::text);

ALTER TABLE groups
	ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::text);

ALTER TABLE links
	ALTER COLUMN id SET DEFAULT nextval('links_id_seq'::text);

ALTER TABLE objectcustomfields
	ALTER COLUMN id SET DEFAULT nextval('objectcustomfields_id_s'::text);

ALTER TABLE objectcustomfieldvalues
	ALTER COLUMN id SET DEFAULT nextval('objectcustomfieldvalues_id_s'::text);

ALTER TABLE principals
	ALTER COLUMN id SET DEFAULT nextval('principals_id_seq'::text);

ALTER TABLE queues
	ALTER COLUMN id SET DEFAULT nextval('queues_id_seq'::text);

ALTER TABLE tickets
	ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::text);

ALTER TABLE users
	ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::text);

ALTER TABLE scripactions
	ALTER COLUMN id SET DEFAULT nextval('scripactions_id_seq'::text);

ALTER TABLE scripconditions
	ALTER COLUMN id SET DEFAULT nextval('scripconditions_id_seq'::text);

ALTER TABLE scrips
	ALTER COLUMN id SET DEFAULT nextval('scrips_id_seq'::text);

ALTER TABLE templates
	ALTER COLUMN id SET DEFAULT nextval('templates_id_seq'::text);

ALTER TABLE transactions
	ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::text);

CREATE TRIGGER _csctoss_repl_logtrigger_5000
	AFTER INSERT OR UPDATE OR DELETE ON acl
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5000', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5010
	AFTER INSERT OR UPDATE OR DELETE ON attachments
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5010', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5020
	AFTER INSERT OR UPDATE OR DELETE ON attributes
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5020', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5030
	AFTER INSERT OR UPDATE OR DELETE ON cachedgroupmembers
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5030', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5040
	AFTER INSERT OR UPDATE OR DELETE ON customfields
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5040', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5050
	AFTER INSERT OR UPDATE OR DELETE ON customfieldvalues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5050', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5060
	AFTER INSERT OR UPDATE OR DELETE ON groupmembers
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5060', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5070
	AFTER INSERT OR UPDATE OR DELETE ON groups
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5070', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5080
	AFTER INSERT OR UPDATE OR DELETE ON links
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5080', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5090
	AFTER INSERT OR UPDATE OR DELETE ON objectcustomfields
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5090', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5100
	AFTER INSERT OR UPDATE OR DELETE ON objectcustomfieldvalues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5100', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5110
	AFTER INSERT OR UPDATE OR DELETE ON principals
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5110', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5120
	AFTER INSERT OR UPDATE OR DELETE ON queues
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5120', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5180
	AFTER INSERT OR UPDATE OR DELETE ON tickets
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5180', 'kvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5200
	AFTER INSERT OR UPDATE OR DELETE ON users
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5200', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5130
	AFTER INSERT OR UPDATE OR DELETE ON scripactions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5130', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5140
	AFTER INSERT OR UPDATE OR DELETE ON scripconditions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5140', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5150
	AFTER INSERT OR UPDATE OR DELETE ON scrips
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5150', 'kvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5160
	AFTER INSERT OR UPDATE OR DELETE ON sessions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5160', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5170
	AFTER INSERT OR UPDATE OR DELETE ON templates
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5170', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_5190
	AFTER INSERT OR UPDATE OR DELETE ON transactions
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '5190', 'kvvvvvvvvvvvvv');
