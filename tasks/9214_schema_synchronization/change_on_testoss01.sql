
CREATE SCHEMA _csctoss_repl;

SET search_path = _csctoss_repl, pg_catalog;

CREATE SEQUENCE sl_action_seq
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

COMMENT ON SEQUENCE sl_action_seq IS 'The sequence to number statements in the transaction logs, so that the replication engines can figure out the "agreeable" order of statements.';

CREATE SEQUENCE sl_event_seq
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

COMMENT ON SEQUENCE sl_event_seq IS 'The sequence for numbering events originating from this node.';

CREATE SEQUENCE sl_local_node_id
	INCREMENT BY 1
	NO MAXVALUE
	MINVALUE -1
	CACHE 1;

COMMENT ON SEQUENCE sl_local_node_id IS 'The local node ID is initialized to -1, meaning that this node is not initialized yet.';

CREATE SEQUENCE sl_log_status
	INCREMENT BY 1
	MAXVALUE 3
	MINVALUE 0
	CACHE 1;

COMMENT ON SEQUENCE sl_log_status IS '
Bit 0x01 determines the currently active log table
Bit 0x02 tells if the engine needs to read both logs
after switching until the old log is clean and truncated.

Possible values:
	0		sl_log_1 active, sl_log_2 clean
	1		sl_log_2 active, sl_log_1 clean
	2		sl_log_1 active, sl_log_2 unknown - cleanup
	3		sl_log_2 active, sl_log_1 unknown - cleanup

This is not yet in use.
';

CREATE SEQUENCE sl_nodelock_nl_conncnt_seq
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

CREATE SEQUENCE sl_rowid_seq
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1;

COMMENT ON SEQUENCE sl_rowid_seq IS 'Application tables that do not have a natural primary key must be modified and an int8 column added that serves as a rowid for us.  The values are assigned with a default from this sequence.';

CREATE TABLE sl_archive_counter (
	ac_num bigint,
	ac_timestamp timestamp without time zone
);

COMMENT ON TABLE sl_archive_counter IS 'Table used to generate the log shipping archive number.
';

COMMENT ON COLUMN sl_archive_counter.ac_num IS 'Counter of SYNC ID used in log shipping as the archive number';

COMMENT ON COLUMN sl_archive_counter.ac_timestamp IS 'Time at which the archive log was generated on the subscriber';

CREATE TABLE sl_config_lock (
	dummy integer
);

COMMENT ON TABLE sl_config_lock IS 'This table exists solely to prevent overlapping execution of configuration change procedures and the resulting possible deadlocks.
';

COMMENT ON COLUMN sl_config_lock.dummy IS 'No data ever goes in this table so the contents never matter.  Indeed, this column does not really need to exist.';

CREATE TABLE sl_confirm (
	con_origin integer,
	con_received integer,
	con_seqno bigint,
	con_timestamp timestamp without time zone DEFAULT (timeofday())::timestamp without time zone
);

COMMENT ON TABLE sl_confirm IS 'Holds confirmation of replication events.  After a period of time, Slony removes old confirmed events from both this table and the sl_event table.';

COMMENT ON COLUMN sl_confirm.con_origin IS 'The ID # (from sl_node.no_id) of the source node for this event';

COMMENT ON COLUMN sl_confirm.con_seqno IS 'The ID # for the event';

COMMENT ON COLUMN sl_confirm.con_timestamp IS 'When this event was confirmed';

CREATE TABLE sl_event (
	ev_origin integer NOT NULL,
	ev_seqno bigint NOT NULL,
	ev_timestamp timestamp without time zone,
	ev_minxid xxid,
	ev_maxxid xxid,
	ev_xip text,
	ev_type text,
	ev_data1 text,
	ev_data2 text,
	ev_data3 text,
	ev_data4 text,
	ev_data5 text,
	ev_data6 text,
	ev_data7 text,
	ev_data8 text
);

COMMENT ON TABLE sl_event IS 'Holds information about replication events.  After a period of time, Slony removes old confirmed events from both this table and the sl_confirm table.';

COMMENT ON COLUMN sl_event.ev_origin IS 'The ID # (from sl_node.no_id) of the source node for this event';

COMMENT ON COLUMN sl_event.ev_seqno IS 'The ID # for the event';

COMMENT ON COLUMN sl_event.ev_timestamp IS 'When this event record was created';

COMMENT ON COLUMN sl_event.ev_minxid IS 'Earliest XID on provider node for this event';

COMMENT ON COLUMN sl_event.ev_maxxid IS 'Latest XID on provider node for this event';

COMMENT ON COLUMN sl_event.ev_xip IS 'List of XIDs, in order, that are part of this event';

COMMENT ON COLUMN sl_event.ev_type IS 'The type of event this record is for.  
				SYNC				= Synchronise
				STORE_NODE			=
				ENABLE_NODE			=
				DROP_NODE			=
				STORE_PATH			=
				DROP_PATH			=
				STORE_LISTEN		=
				DROP_LISTEN			=
				STORE_SET			=
				DROP_SET			=
				MERGE_SET			=
				SET_ADD_TABLE		=
				SET_ADD_SEQUENCE	=
				STORE_TRIGGER		=
				DROP_TRIGGER		=
				MOVE_SET			=
				ACCEPT_SET			=
				SET_DROP_TABLE			=
				SET_DROP_SEQUENCE		=
				SET_MOVE_TABLE			=
				SET_MOVE_SEQUENCE		=
				FAILOVER_SET		=
				SUBSCRIBE_SET		=
				ENABLE_SUBSCRIPTION	=
				UNSUBSCRIBE_SET		=
				DDL_SCRIPT			=
				ADJUST_SEQ			=
				RESET_CONFIG		=
';

COMMENT ON COLUMN sl_event.ev_data1 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data2 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data3 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data4 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data5 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data6 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data7 IS 'Data field containing an argument needed to process the event';

COMMENT ON COLUMN sl_event.ev_data8 IS 'Data field containing an argument needed to process the event';

CREATE TABLE sl_listen (
	li_origin integer NOT NULL,
	li_provider integer NOT NULL,
	li_receiver integer NOT NULL
);

COMMENT ON TABLE sl_listen IS 'Indicates how nodes listen to events from other nodes in the Slony-I network.';

COMMENT ON COLUMN sl_listen.li_origin IS 'The ID # (from sl_node.no_id) of the node this listener is operating on';

COMMENT ON COLUMN sl_listen.li_provider IS 'The ID # (from sl_node.no_id) of the source node for this listening event';

COMMENT ON COLUMN sl_listen.li_receiver IS 'The ID # (from sl_node.no_id) of the target node for this listening event';

CREATE TABLE sl_log_1 (
	log_origin integer,
	log_xid xxid,
	log_tableid integer,
	log_actionseq bigint,
	log_cmdtype character(1),
	log_cmddata text
);

COMMENT ON TABLE sl_log_1 IS 'Stores each change to be propagated to subscriber nodes';

COMMENT ON COLUMN sl_log_1.log_origin IS 'Origin node from which the change came';

COMMENT ON COLUMN sl_log_1.log_xid IS 'Transaction ID on the origin node';

COMMENT ON COLUMN sl_log_1.log_tableid IS 'The table ID (from sl_table.tab_id) that this log entry is to affect';

COMMENT ON COLUMN sl_log_1.log_cmdtype IS 'Replication action to take. U = Update, I = Insert, D = DELETE';

COMMENT ON COLUMN sl_log_1.log_cmddata IS 'The data needed to perform the log action';

CREATE TABLE sl_log_2 (
	log_origin integer,
	log_xid xxid,
	log_tableid integer,
	log_actionseq bigint,
	log_cmdtype character(1),
	log_cmddata text
);

COMMENT ON TABLE sl_log_2 IS 'Stores each change to be propagated to subscriber nodes';

COMMENT ON COLUMN sl_log_2.log_origin IS 'Origin node from which the change came';

COMMENT ON COLUMN sl_log_2.log_xid IS 'Transaction ID on the origin node';

COMMENT ON COLUMN sl_log_2.log_tableid IS 'The table ID (from sl_table.tab_id) that this log entry is to affect';

COMMENT ON COLUMN sl_log_2.log_cmdtype IS 'Replication action to take. U = Update, I = Insert, D = DELETE';

COMMENT ON COLUMN sl_log_2.log_cmddata IS 'The data needed to perform the log action';

CREATE TABLE sl_node (
	no_id integer NOT NULL,
	no_active boolean,
	no_comment text,
	no_spool boolean
);

COMMENT ON TABLE sl_node IS 'Holds the list of nodes associated with this namespace.';

COMMENT ON COLUMN sl_node.no_id IS 'The unique ID number for the node';

COMMENT ON COLUMN sl_node.no_active IS 'Is the node active in replication yet?';

COMMENT ON COLUMN sl_node.no_comment IS 'A human-oriented description of the node';

COMMENT ON COLUMN sl_node.no_spool IS 'Is the node being used for log shipping?';

CREATE TABLE sl_nodelock (
	nl_nodeid integer NOT NULL,
	nl_conncnt integer DEFAULT nextval('_csctoss_repl.sl_nodelock_nl_conncnt_seq'::text) NOT NULL,
	nl_backendpid integer
);

COMMENT ON TABLE sl_nodelock IS 'Used to prevent multiple slon instances and to identify the backends to kill in terminateNodeConnections().';

COMMENT ON COLUMN sl_nodelock.nl_nodeid IS 'Clients node_id';

COMMENT ON COLUMN sl_nodelock.nl_conncnt IS 'Clients connection number';

COMMENT ON COLUMN sl_nodelock.nl_backendpid IS 'PID of database backend owning this lock';

CREATE TABLE sl_path (
	pa_server integer NOT NULL,
	pa_client integer NOT NULL,
	pa_conninfo text NOT NULL,
	pa_connretry integer
);

COMMENT ON TABLE sl_path IS 'Holds connection information for the paths between nodes, and the synchronisation delay';

COMMENT ON COLUMN sl_path.pa_server IS 'The Node ID # (from sl_node.no_id) of the data source';

COMMENT ON COLUMN sl_path.pa_client IS 'The Node ID # (from sl_node.no_id) of the data target';

COMMENT ON COLUMN sl_path.pa_conninfo IS 'The PostgreSQL connection string used to connect to the source node.';

COMMENT ON COLUMN sl_path.pa_connretry IS 'The synchronisation delay, in seconds';

CREATE TABLE sl_registry (
	reg_key text NOT NULL,
	reg_int4 integer,
	reg_text text,
	reg_timestamp timestamp without time zone
);

COMMENT ON TABLE sl_registry IS 'Stores miscellaneous runtime data';

COMMENT ON COLUMN sl_registry.reg_key IS 'Unique key of the runtime option';

COMMENT ON COLUMN sl_registry.reg_int4 IS 'Option value if type int4';

COMMENT ON COLUMN sl_registry.reg_text IS 'Option value if type text';

COMMENT ON COLUMN sl_registry.reg_timestamp IS 'Option value if type timestamp';

CREATE TABLE sl_sequence (
	seq_id integer NOT NULL,
	seq_reloid oid NOT NULL,
	seq_relname name NOT NULL,
	seq_nspname name NOT NULL,
	seq_set integer,
	seq_comment text
);

COMMENT ON TABLE sl_sequence IS 'Similar to sl_table, each entry identifies a sequence being replicated.';

COMMENT ON COLUMN sl_sequence.seq_id IS 'An internally-used ID for Slony-I to use in its sequencing of updates';

COMMENT ON COLUMN sl_sequence.seq_reloid IS 'The OID of the sequence object';

COMMENT ON COLUMN sl_sequence.seq_relname IS 'The name of the sdequence in pg_catalog.pg_class.relname used to recover from a dump/restore cycle';

COMMENT ON COLUMN sl_sequence.seq_nspname IS 'The name of the schema in pg_catalog.pg_namespace.nspname used to recover from a dump/restore cycle';

COMMENT ON COLUMN sl_sequence.seq_set IS 'Indicates which replication set the object is in';

COMMENT ON COLUMN sl_sequence.seq_comment IS 'A human-oriented comment';

CREATE TABLE sl_set (
	set_id integer NOT NULL,
	set_origin integer,
	set_locked xxid,
	set_comment text
);

COMMENT ON TABLE sl_set IS 'Holds definitions of replication sets.';

COMMENT ON COLUMN sl_set.set_id IS 'A unique ID number for the set.';

COMMENT ON COLUMN sl_set.set_origin IS 'The ID number of the source node for the replication set.';

COMMENT ON COLUMN sl_set.set_locked IS 'Indicates whether or not the set is locked.';

COMMENT ON COLUMN sl_set.set_comment IS 'A human-oriented description of the set.';

CREATE TABLE sl_seqlog (
	seql_seqid integer,
	seql_origin integer,
	seql_ev_seqno bigint,
	seql_last_value bigint
);

COMMENT ON TABLE sl_seqlog IS 'Log of Sequence updates';

COMMENT ON COLUMN sl_seqlog.seql_seqid IS 'Sequence ID';

COMMENT ON COLUMN sl_seqlog.seql_origin IS 'Publisher node at which the sequence originates';

COMMENT ON COLUMN sl_seqlog.seql_ev_seqno IS 'Slony-I Event with which this sequence update is associated';

COMMENT ON COLUMN sl_seqlog.seql_last_value IS 'Last value published for this sequence';

CREATE TABLE sl_setsync (
	ssy_setid integer NOT NULL,
	ssy_origin integer,
	ssy_seqno bigint,
	ssy_minxid xxid,
	ssy_maxxid xxid,
	ssy_xip text,
	ssy_action_list text
);

COMMENT ON TABLE sl_setsync IS 'SYNC information';

COMMENT ON COLUMN sl_setsync.ssy_setid IS 'ID number of the replication set';

COMMENT ON COLUMN sl_setsync.ssy_origin IS 'ID number of the node';

COMMENT ON COLUMN sl_setsync.ssy_seqno IS 'Slony-I sequence number';

COMMENT ON COLUMN sl_setsync.ssy_minxid IS 'Earliest XID in provider system affected by SYNC';

COMMENT ON COLUMN sl_setsync.ssy_maxxid IS 'Latest XID in provider system affected by SYNC';

COMMENT ON COLUMN sl_setsync.ssy_xip IS 'Contains the list of XIDs in progress at SYNC time';

COMMENT ON COLUMN sl_setsync.ssy_action_list IS 'action list used during the subscription process. At the time a subscriber copies over data from the origin, it sees all tables in a state somewhere between two SYNC events. Therefore this list must contains all XIDs that are visible at that time, whose operations have therefore already been included in the data copied at the time the initial data copy is done.  Those actions may therefore be filtered out of the first SYNC done after subscribing.';

CREATE TABLE sl_subscribe (
	sub_set integer NOT NULL,
	sub_provider integer,
	sub_receiver integer NOT NULL,
	sub_forward boolean,
	sub_active boolean
);

COMMENT ON TABLE sl_subscribe IS 'Holds a list of subscriptions on sets';

COMMENT ON COLUMN sl_subscribe.sub_set IS 'ID # (from sl_set) of the set being subscribed to';

COMMENT ON COLUMN sl_subscribe.sub_provider IS 'ID# (from sl_node) of the node providing data';

COMMENT ON COLUMN sl_subscribe.sub_receiver IS 'ID# (from sl_node) of the node receiving data from the provider';

COMMENT ON COLUMN sl_subscribe.sub_forward IS 'Does this provider keep data in sl_log_1/sl_log_2 to allow it to be a provider for other nodes?';

COMMENT ON COLUMN sl_subscribe.sub_active IS 'Has this subscription been activated?  This is not set on the subscriber until AFTER the subscriber has received COPY data from the provider';

CREATE TABLE sl_table (
	tab_id integer NOT NULL,
	tab_reloid oid NOT NULL,
	tab_relname name NOT NULL,
	tab_nspname name NOT NULL,
	tab_set integer,
	tab_idxname name NOT NULL,
	tab_altered boolean NOT NULL,
	tab_comment text
);

COMMENT ON TABLE sl_table IS 'Holds information about the tables being replicated.';

COMMENT ON COLUMN sl_table.tab_id IS 'Unique key for Slony-I to use to identify the table';

COMMENT ON COLUMN sl_table.tab_reloid IS 'The OID of the table in pg_catalog.pg_class.oid';

COMMENT ON COLUMN sl_table.tab_relname IS 'The name of the table in pg_catalog.pg_class.relname used to recover from a dump/restore cycle';

COMMENT ON COLUMN sl_table.tab_nspname IS 'The name of the schema in pg_catalog.pg_namespace.nspname used to recover from a dump/restore cycle';

COMMENT ON COLUMN sl_table.tab_set IS 'ID of the replication set the table is in';

COMMENT ON COLUMN sl_table.tab_idxname IS 'The name of the primary index of the table';

COMMENT ON COLUMN sl_table.tab_altered IS 'Has the table been modified for replication?';

COMMENT ON COLUMN sl_table.tab_comment IS 'Human-oriented description of the table';

CREATE TABLE sl_trigger (
	trig_tabid integer NOT NULL,
	trig_tgname name NOT NULL
);

COMMENT ON TABLE sl_trigger IS 'Holds information about triggers on tables managed using Slony-I';

COMMENT ON COLUMN sl_trigger.trig_tabid IS 'Slony-I ID number of table the trigger is on';

COMMENT ON COLUMN sl_trigger.trig_tgname IS 'Indicates the name of a trigger';

ALTER SEQUENCE sl_nodelock_nl_conncnt_seq
	OWNED BY sl_nodelock.nl_conncnt;

CREATE OR REPLACE FUNCTION xxidin(cstring) RETURNS xxid
    LANGUAGE c STRICT
    AS '$libdir/xxid', '_Slony_I_xxidin';

CREATE OR REPLACE FUNCTION xxidout(xxid) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/xxid', '_Slony_I_xxidout';

CREATE OR REPLACE FUNCTION xxid_snapshot_in(cstring) RETURNS xxid_snapshot
    LANGUAGE c STRICT
    AS '$libdir/xxid', '_Slony_I_xxid_snapshot_in';

CREATE OR REPLACE FUNCTION xxid_snapshot_out(xxid_snapshot) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/xxid', '_Slony_I_xxid_snapshot_out';

CREATE OR REPLACE FUNCTION add_empty_table_to_replication(integer, integer, text, text, text, text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
  p_set_id alias for $1;
  p_tab_id alias for $2;
  p_nspname alias for $3;
  p_tabname alias for $4;
  p_idxname alias for $5;
  p_comment alias for $6;

  prec record;
  v_origin int4;
  v_isorigin boolean;
  v_fqname text;
  v_query text;
  v_rows integer;
  v_idxname text;

begin
-- Need to validate that the set exists; the set will tell us if this is the origin
  select set_origin into v_origin from "_csctoss_repl".sl_set where set_id = p_set_id;
  if not found then
	raise exception 'add_empty_table_to_replication: set % not found!', p_set_id;
  end if;

-- Need to be aware of whether or not this node is origin for the set
   v_isorigin := ( v_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl') );

   v_fqname := '"' || p_nspname || '"."' || p_tabname || '"';
-- Take out a lock on the table
   v_query := 'lock ' || v_fqname || ';';
   execute v_query;

   if v_isorigin then
	-- On the origin, verify that the table is empty, failing if it has any tuples
        v_query := 'select 1 as tuple from ' || v_fqname || ' limit 1;';
	execute v_query into prec;
        GET DIAGNOSTICS v_rows = ROW_COUNT;
	if v_rows = 0 then
		raise notice 'add_empty_table_to_replication: table % empty on origin - OK', v_fqname;
	else
		raise exception 'add_empty_table_to_replication: table % contained tuples on origin node %', v_fqname, v_origin;
	end if;
   else
	-- On other nodes, TRUNCATE the table
		perform "_csctoss_repl".TruncateOnlyTable(v_fqname);
   end if;
-- If p_idxname is NULL, then look up the PK index, and RAISE EXCEPTION if one does not exist
   if p_idxname is NULL then
	select c2.relname into prec from pg_catalog.pg_index i, pg_catalog.pg_class c1, pg_catalog.pg_class c2, pg_catalog.pg_namespace n where i.indrelid = c1.oid and i.indexrelid = c2.oid and c1.relname = p_tabname and i.indisprimary and n.nspname = p_nspname and n.oid = c1.relnamespace;
	if not found then
		raise exception 'add_empty_table_to_replication: table % has no primary key and no candidate specified!', v_fqname;
	else
		v_idxname := prec.relname;
	end if;
   else
	v_idxname := p_idxname;
   end if;
   perform "_csctoss_repl".setAddTable_int(p_set_id, p_tab_id, v_fqname, v_idxname, p_comment);
   return "_csctoss_repl".alterTableRestore(p_tab_id);
end
$_$;

COMMENT ON FUNCTION add_empty_table_to_replication(integer, integer, text, text, text, text) IS 'Verify that a table is empty, and add it to replication.  
tab_idxname is optional - if NULL, then we use the primary key.';

CREATE OR REPLACE FUNCTION add_missing_table_field(text, text, text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
  p_namespace alias for $1;
  p_table     alias for $2;
  p_field     alias for $3;
  p_type      alias for $4;
  v_row       record;
  v_query     text;
BEGIN
  select 1 into v_row from pg_namespace n, pg_class c, pg_attribute a
     where "_csctoss_repl".slon_quote_brute(n.nspname) = p_namespace and 
         c.relnamespace = n.oid and
         "_csctoss_repl".slon_quote_brute(c.relname) = p_table and
         a.attrelid = c.oid and
         "_csctoss_repl".slon_quote_brute(a.attname) = p_field;
  if not found then
    raise notice 'Upgrade table %.% - add field %', p_namespace, p_table, p_field;
    v_query := 'alter table ' || p_namespace || '.' || p_table || ' add column ';
    v_query := v_query || p_field || ' ' || p_type || ';';
    execute v_query;
    return 't';
  else
    return 'f';
  end if;
END;$_$;

COMMENT ON FUNCTION add_missing_table_field(text, text, text, text) IS 'Add a column of a given type to a table if it is missing';

CREATE OR REPLACE FUNCTION addpartiallogindices() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_current_status	int4;
	v_log			int4;
	v_dummy		record;
	v_dummy2	record;
	idef 		text;
	v_count		int4;
        v_iname         text;
BEGIN
	v_count := 0;
	select last_value into v_current_status from "_csctoss_repl".sl_log_status;

	-- If status is 2 or 3 --> in process of cleanup --> unsafe to create indices
	if v_current_status in (2, 3) then
		return 0;
	end if;

	if v_current_status = 0 then   -- Which log should get indices?
		v_log := 2;
	else
		v_log := 1;
	end if;
--                                       PartInd_test_db_sl_log_2-node-1
	-- Add missing indices...
	for v_dummy in select distinct set_origin from "_csctoss_repl".sl_set loop
            v_iname := 'PartInd_csctoss_repl_sl_log_' || v_log::text || '-node-' || v_dummy.set_origin::text;
	    -- raise notice 'Consider adding partial index % on sl_log_%', v_iname, v_log;
	    -- raise notice 'schema: [_csctoss_repl] tablename:[sl_log_%]', v_log;
            select * into v_dummy2 from pg_catalog.pg_indexes where tablename = 'sl_log_' || v_log::text and  indexname = v_iname;
            if not found then
		-- raise notice 'index was not found - add it!';
		idef := 'create index "PartInd_csctoss_repl_sl_log_' || v_log::text || '-node-' || v_dummy.set_origin::text ||
                        '" on "_csctoss_repl".sl_log_' || v_log::text || ' USING btree(log_xid "_csctoss_repl".xxid_ops) where (log_origin = ' || v_dummy.set_origin::text || ');';
		execute idef;
		v_count := v_count + 1;
            else
                -- raise notice 'Index % already present - skipping', v_iname;
            end if;
	end loop;

	-- Remove unneeded indices...
	for v_dummy in select indexname from pg_catalog.pg_indexes i where i.tablename = 'sl_log_' || v_log::text and
                       i.indexname like ('PartInd_csctoss_repl_sl_log_' || v_log::text || '-node-%') and
                       not exists (select 1 from "_csctoss_repl".sl_set where
				i.indexname = 'PartInd_csctoss_repl_sl_log_' || v_log::text || '-node-' || set_origin::text)
	loop
		-- raise notice 'Dropping obsolete index %d', v_dummy.indexname;
		idef := 'drop index "_csctoss_repl"."' || v_dummy.indexname || '";';
		execute idef;
		v_count := v_count - 1;
	end loop;
	return v_count;
END
$$;

COMMENT ON FUNCTION addpartiallogindices() IS 'Add partial indexes, if possible, to the unused sl_log_? table for
all origin nodes, and drop any that are no longer needed.

This function presently gets run any time set origins are manipulated
(FAILOVER, STORE SET, MOVE SET, DROP SET), as well as each time the
system switches between sl_log_1 and sl_log_2.';

CREATE OR REPLACE FUNCTION altertableforreplication(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id			alias for $1;
	v_no_id				int4;
	v_tab_row			record;
	v_tab_fqname		text;
	v_tab_attkind		text;
	v_n					int4;
	v_trec	record;
	v_tgbad	boolean;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get our local node ID
	-- ----
	v_no_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');

	-- ----
	-- Get the sl_table row and the current origin of the table. 
	-- Verify that the table currently is NOT in altered state.
	-- ----
	select T.tab_reloid, T.tab_set, T.tab_idxname, T.tab_altered,
			S.set_origin, PGX.indexrelid,
			"_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) as tab_fqname
			into v_tab_row
			from "_csctoss_repl".sl_table T, "_csctoss_repl".sl_set S,
				"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_index PGX, "pg_catalog".pg_class PGXC
			where T.tab_id = p_tab_id
				and T.tab_set = S.set_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid
				and PGX.indrelid = T.tab_reloid
				and PGX.indexrelid = PGXC.oid
				and PGXC.relname = T.tab_idxname
				for update;
	if not found then
		raise exception 'Slony-I: alterTableForReplication(): Table with id % not found', p_tab_id;
	end if;
	v_tab_fqname = v_tab_row.tab_fqname;
	if v_tab_row.tab_altered then
		raise exception 'Slony-I: alterTableForReplication(): Table % is already in altered state',
				v_tab_fqname;
	end if;

	v_tab_attkind := "_csctoss_repl".determineAttKindUnique(v_tab_row.tab_fqname, 
						v_tab_row.tab_idxname);

	execute 'lock table ' || v_tab_fqname || ' in access exclusive mode';

	-- ----
	-- Procedures are different on origin and subscriber
	-- ----
	if v_no_id = v_tab_row.set_origin then
		-- ----
		-- On the Origin we add the log trigger to the table and done
		-- ----
		execute 'create trigger "_csctoss_repl_logtrigger_' || 
				p_tab_id::text || '" after insert or update or delete on ' ||
				v_tab_fqname || ' for each row execute procedure
				"_csctoss_repl".logTrigger (''_csctoss_repl'', ''' || 
					p_tab_id::text || ''', ''' || 
					v_tab_attkind || ''');';
	else
		-- ----
		-- On the subscriber the thing is a bit more difficult. We want
		-- to disable all user- and foreign key triggers and rules.
		-- ----


		-- ----
		-- Check to see if there are any trigger conflicts...
		-- ----
		v_tgbad := 'false';
		for v_trec in 
			select pc.relname, tg1.tgname from
			"pg_catalog".pg_trigger tg1, 
			"pg_catalog".pg_trigger tg2,
			"pg_catalog".pg_class pc,
			"pg_catalog".pg_index pi,
			"_csctoss_repl".sl_table tab
			where 
			 tg1.tgname = tg2.tgname and        -- Trigger names match
			 tg1.tgrelid = tab.tab_reloid and   -- trigger 1 is on the table
			 pi.indexrelid = tg2.tgrelid and    -- trigger 2 is on the index
			 pi.indrelid = tab.tab_reloid and   -- indexes table is this table
			 pc.oid = tab.tab_reloid
                loop
			raise notice 'Slony-I: alterTableForReplication(): multiple instances of trigger % on table %',
				v_trec.tgname, v_trec.relname;
			v_tgbad := 'true';
		end loop;
		if v_tgbad then
			raise exception 'Slony-I: Unable to disable triggers';
		end if;  		

		-- ----
		-- Disable all existing triggers
		-- ----
		update "pg_catalog".pg_trigger
				set tgrelid = v_tab_row.indexrelid
				where tgrelid = v_tab_row.tab_reloid
				and not exists (
						select true from "_csctoss_repl".sl_table TAB,
								"_csctoss_repl".sl_trigger TRIG
								where TAB.tab_reloid = tgrelid
								and TAB.tab_id = TRIG.trig_tabid
								and TRIG.trig_tgname = tgname
					);
		get diagnostics v_n = row_count;
		if (v_n > 0) and exists (select 1 from information_schema.columns where table_name = 'pg_class' and table_schema = 'pg_catalog' and column_name = 'reltriggers') then
			update "pg_catalog".pg_class
					set reltriggers = reltriggers - v_n
					where oid = v_tab_row.tab_reloid;
		end if;

		-- ----
		-- Disable all existing rules
		-- ----
		update "pg_catalog".pg_rewrite
				set ev_class = v_tab_row.indexrelid
				where ev_class = v_tab_row.tab_reloid;
		get diagnostics v_n = row_count;
		if v_n > 0 then
			update "pg_catalog".pg_class
					set relhasrules = false
					where oid = v_tab_row.tab_reloid;
		end if;

		-- ----
		-- Add the trigger that denies write access to replicated tables
		-- ----
		execute 'create trigger "_csctoss_repl_denyaccess_' || 
				p_tab_id::text || '" before insert or update or delete on ' ||
				v_tab_fqname || ' for each row execute procedure
				"_csctoss_repl".denyAccess (''_csctoss_repl'');';
	end if;

	-- ----
	-- Mark the table altered in our configuration
	-- ----
	update "_csctoss_repl".sl_table
			set tab_altered = true where tab_id = p_tab_id;

	return p_tab_id;
end;
$_$;

COMMENT ON FUNCTION altertableforreplication(integer) IS 'alterTableForReplication(tab_id)

Sets up a table for replication.
On the origin, this involves adding the "logTrigger()" trigger to the
table.

On a subscriber node, this involves disabling triggers and rules, and
adding in the trigger that denies write access to replicated tables.';

CREATE OR REPLACE FUNCTION altertablerestore(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id			alias for $1;
	v_no_id				int4;
	v_tab_row			record;
	v_tab_fqname		text;
	v_n					int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get our local node ID
	-- ----
	v_no_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');

	-- ----
	-- Get the sl_table row and the current tables origin. Check
	-- that the table currently IS in altered state.
	-- ----
	select T.tab_reloid, T.tab_set, T.tab_altered,
			S.set_origin, PGX.indexrelid,
			"_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) as tab_fqname
			into v_tab_row
			from "_csctoss_repl".sl_table T, "_csctoss_repl".sl_set S,
				"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_index PGX, "pg_catalog".pg_class PGXC
			where T.tab_id = p_tab_id
				and T.tab_set = S.set_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid
				and PGX.indrelid = T.tab_reloid
				and PGX.indexrelid = PGXC.oid
				and PGXC.relname = T.tab_idxname
				for update;
	if not found then
		raise exception 'Slony-I: alterTableRestore(): Table with id % not found', p_tab_id;
	end if;
	v_tab_fqname = v_tab_row.tab_fqname;
	if not v_tab_row.tab_altered then
		raise exception 'Slony-I: alterTableRestore(): Table % is not in altered state',
				v_tab_fqname;
	end if;

	execute 'lock table ' || v_tab_fqname || ' in access exclusive mode';

	-- ----
	-- Procedures are different on origin and subscriber
	-- ----
	if v_no_id = v_tab_row.set_origin then
		-- ----
		-- On the Origin we just drop the trigger we originally added
		-- ----
		execute 'drop trigger "_csctoss_repl_logtrigger_' || 
				p_tab_id::text || '" on ' || v_tab_fqname;
	else
		-- ----
		-- On the subscriber drop the denyAccess trigger
		-- ----
		execute 'drop trigger "_csctoss_repl_denyaccess_' || 
				p_tab_id::text || '" on ' || v_tab_fqname;
				
		-- ----
		-- Restore all original triggers
		-- ----
		update "pg_catalog".pg_trigger
				set tgrelid = v_tab_row.tab_reloid
				where tgrelid = v_tab_row.indexrelid;
		get diagnostics v_n = row_count;
		if (v_n > 0) and exists (select 1 from information_schema.columns where table_name = 'pg_class' and table_schema = 'pg_catalog' and column_name = 'reltriggers') then
			update "pg_catalog".pg_class
					set reltriggers = reltriggers + v_n
					where oid = v_tab_row.tab_reloid;
		end if;

		-- ----
		-- Restore all original rewrite rules
		-- ----
		update "pg_catalog".pg_rewrite
				set ev_class = v_tab_row.tab_reloid
				where ev_class = v_tab_row.indexrelid;
		get diagnostics v_n = row_count;
		if v_n > 0 then
			update "pg_catalog".pg_class
					set relhasrules = true
					where oid = v_tab_row.tab_reloid;
		end if;

	end if;

	-- ----
	-- Mark the table not altered in our configuration
	-- ----
	update "_csctoss_repl".sl_table
			set tab_altered = false where tab_id = p_tab_id;

	return p_tab_id;
end;
$_$;

COMMENT ON FUNCTION altertablerestore(integer) IS 'alterTableRestore (tab_id)

Restores table tab_id from being replicated.

On the origin, this simply involves dropping the "logtrigger" trigger.

On subscriber nodes, this involves dropping the "denyaccess" trigger,
and restoring user triggers and rules.';

CREATE OR REPLACE FUNCTION btxxidcmp(xxid, xxid) RETURNS integer
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_btxxidcmp';

CREATE OR REPLACE FUNCTION checkmoduleversion() RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  moduleversion	text;
begin
  select into moduleversion "_csctoss_repl".getModuleVersion();
  if moduleversion <> '1.2.23' then
      raise exception 'Slonik version: 1.2.23 != Slony-I version in PG build %',
             moduleversion;
  end if;
  return null;
end;$$;

COMMENT ON FUNCTION checkmoduleversion() IS 'Inline test function that verifies that slonik request for STORE
NODE/INIT CLUSTER is being run against a conformant set of
schema/functions.';

CREATE OR REPLACE FUNCTION cleanupevent() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	v_max_row	record;
	v_min_row	record;
	v_max_sync	int8;
begin
	-- ----
	-- First remove all but the oldest confirm row per origin,receiver pair
	-- ----
	delete from "_csctoss_repl".sl_confirm
				where con_origin not in (select no_id from "_csctoss_repl".sl_node);
	delete from "_csctoss_repl".sl_confirm
				where con_received not in (select no_id from "_csctoss_repl".sl_node);
	-- ----
	-- Next remove all but the oldest confirm row per origin,receiver pair.
	-- Ignore confirmations that are younger than 10 minutes. We currently
	-- have an not confirmed suspicion that a possibly lost transaction due
	-- to a server crash might have been visible to another session, and
	-- that this led to log data that is needed again got removed.
	-- ----
	for v_max_row in select con_origin, con_received, max(con_seqno) as con_seqno
				from "_csctoss_repl".sl_confirm
				where con_timestamp < (CURRENT_TIMESTAMP - '10 min'::interval)
				group by con_origin, con_received
	loop
		delete from "_csctoss_repl".sl_confirm
				where con_origin = v_max_row.con_origin
				and con_received = v_max_row.con_received
				and con_seqno < v_max_row.con_seqno;
	end loop;

	-- ----
	-- Then remove all events that are confirmed by all nodes in the
	-- whole cluster up to the last SYNC
	-- ----
	for v_min_row in select con_origin, min(con_seqno) as con_seqno
				from "_csctoss_repl".sl_confirm
				group by con_origin
	loop
		select coalesce(max(ev_seqno), 0) into v_max_sync
				from "_csctoss_repl".sl_event
				where ev_origin = v_min_row.con_origin
				and ev_seqno <= v_min_row.con_seqno
				and ev_type = 'SYNC';
		if v_max_sync > 0 then
			delete from "_csctoss_repl".sl_event
					where ev_origin = v_min_row.con_origin
					and ev_seqno < v_max_sync;
		end if;
	end loop;

	-- ----
	-- If cluster has only one node, then remove all events up to
	-- the last SYNC - Bug #1538
        -- http://gborg.postgresql.org/project/slony1/bugs/bugupdate.php?1538
	-- ----

	select * into v_min_row from "_csctoss_repl".sl_node where
			no_id <> "_csctoss_repl".getLocalNodeId('_csctoss_repl') limit 1;
	if not found then
		select ev_origin, ev_seqno into v_min_row from "_csctoss_repl".sl_event
		where ev_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl')
		order by ev_origin desc, ev_seqno desc limit 1;
		raise notice 'Slony-I: cleanupEvent(): Single node - deleting events < %', v_min_row.ev_seqno;
			delete from "_csctoss_repl".sl_event
			where
				ev_origin = v_min_row.ev_origin and
				ev_seqno < v_min_row.ev_seqno;

        end if;

	if exists (select * from "pg_catalog".pg_class c, "pg_catalog".pg_namespace n, "pg_catalog".pg_attribute a where c.relname = 'sl_seqlog' and n.oid = c.relnamespace and a.attrelid = c.oid and a.attname = 'oid') then
                execute 'alter table "_csctoss_repl".sl_seqlog set without oids;';
	end if;		
	-- ----
	-- Also remove stale entries from the nodelock table.
	-- ----
	perform "_csctoss_repl".cleanupNodelock();

	return 0;
end;
$$;

COMMENT ON FUNCTION cleanupevent() IS 'cleaning old data out of sl_confirm, sl_event.  Removes all but the
last sl_confirm row per (origin,receiver), and then removes all events
that are confirmed by all nodes in the whole cluster up to the last
SYNC.  ';

CREATE OR REPLACE FUNCTION cleanupnodelock() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	v_row		record;
begin
	for v_row in select nl_nodeid, nl_conncnt, nl_backendpid
			from "_csctoss_repl".sl_nodelock
			for update
	loop
		if "_csctoss_repl".killBackend(v_row.nl_backendpid, 'NULL') < 0 then
			raise notice 'Slony-I: cleanup stale sl_nodelock entry for pid=%',
					v_row.nl_backendpid;
			delete from "_csctoss_repl".sl_nodelock where
					nl_nodeid = v_row.nl_nodeid and
					nl_conncnt = v_row.nl_conncnt;
		end if;
	end loop;

	return 0;
end;
$$;

COMMENT ON FUNCTION cleanupnodelock() IS 'Clean up stale entries when restarting slon';

CREATE OR REPLACE FUNCTION copyfields(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
	result text;
	prefix text;
	prec record;
begin
	result := '';
	prefix := '(';   -- Initially, prefix is the opening paren

	for prec in select "_csctoss_repl".slon_quote_input(a.attname) as column from "_csctoss_repl".sl_table t, pg_catalog.pg_attribute a where t.tab_id = $1 and t.tab_reloid = a.attrelid and a.attnum > 0 and a.attisdropped = false order by attnum
	loop
		result := result || prefix || prec.column;
		prefix := ',';   -- Subsequently, prepend columns with commas
	end loop;
	result := result || ')';
	return result;
end;
$_$;

COMMENT ON FUNCTION copyfields(integer) IS 'Return a string consisting of what should be appended to a COPY statement
to specify fields for the passed-in tab_id.  

In PG versions > 7.3, this looks like (field1,field2,...fieldn)';

CREATE OR REPLACE FUNCTION createevent(name, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION createevent(name, text, text, text, text, text, text, text, text, text) RETURNS bigint
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_createEvent';

COMMENT ON FUNCTION createevent(name, text, text, text, text, text, text, text, text, text) IS 'FUNCTION createEvent (cluster_name, ev_type [, ev_data [...]])

Create an sl_event entry';

CREATE OR REPLACE FUNCTION ddlscript_complete(integer, text, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_script			alias for $2;
	p_only_on_node		alias for $3;
	v_set_origin		int4;
begin
	perform "_csctoss_repl".updateRelname(p_set_id, p_only_on_node);
	if p_only_on_node = -1 then
		perform "_csctoss_repl".alterTableForReplication(tab_id) from "_csctoss_repl".sl_table where tab_set in (select set_id from "_csctoss_repl".sl_set where set_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl'));

		return  "_csctoss_repl".createEvent('_csctoss_repl', 'DDL_SCRIPT', 
			p_set_id::text, p_script::text, p_only_on_node::text);
	else
		perform "_csctoss_repl".alterTableForReplication(tab_id) from "_csctoss_repl".sl_table;
	end if;
	return NULL;
end;
$_$;

COMMENT ON FUNCTION ddlscript_complete(integer, text, integer) IS 'ddlScript_complete(set_id, script, only_on_node)

After script has run on origin, this fixes up relnames, restores
triggers, and generates a DDL_SCRIPT event to request it to be run on
replicated slaves.';

CREATE OR REPLACE FUNCTION ddlscript_complete_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_only_on_node		alias for $2;
	v_row				record;
begin
	-- ----
	-- Put all tables back into replicated mode
	-- ----
	for v_row in select * from "_csctoss_repl".sl_table
	loop
		perform "_csctoss_repl".alterTableForReplication(v_row.tab_id);
	end loop;

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION ddlscript_complete_int(integer, integer) IS 'ddlScript_complete_int(set_id, script, only_on_node)

Complete processing the DDL_SCRIPT event.  This puts tables back into
replicated mode.';

CREATE OR REPLACE FUNCTION ddlscript_prepare(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_only_on_node		alias for $2;
	v_set_origin		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	
	-- ----
	-- Check that the set exists and originates here
	-- unless only_on_node was specified (then it can be applied to
	-- that node because that is what the user wanted)
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;

	if p_only_on_node = -1 then
		if v_set_origin <> "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
			raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
		end if;
		-- ----
		-- Create a SYNC event, run the script and generate the DDL_SCRIPT event
		-- ----
		perform "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC', NULL);
		perform "_csctoss_repl".alterTableRestore(tab_id) from "_csctoss_repl".sl_table where tab_set in (select set_id from "_csctoss_repl".sl_set where set_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl'));
	else
		-- ----
		-- If doing "only on one node" - restore ALL tables irrespective of set
		-- ----
		perform "_csctoss_repl".alterTableRestore(tab_id) from "_csctoss_repl".sl_table;
	end if;
	return 1;
end;
$_$;

COMMENT ON FUNCTION ddlscript_prepare(integer, integer) IS 'Prepare for DDL script execution on origin';

CREATE OR REPLACE FUNCTION ddlscript_prepare_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_only_on_node		alias for $2;
	v_set_origin		int4;
	v_no_id				int4;
	v_row				record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that we either are the set origin or a current
	-- subscriber of the set.
	-- ----
	v_no_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_set_origin <> v_no_id
			and not exists (select 1 from "_csctoss_repl".sl_subscribe
						where sub_set = p_set_id
						and sub_receiver = v_no_id)
	then
		return 0;
	end if;

	-- ----
	-- If execution on only one node is requested, check that
	-- we are that node.
	-- ----
	if p_only_on_node > 0 and p_only_on_node <> v_no_id then
		return 0;
	end if;

	-- ----
	-- Restore all original triggers and rules of all sets
	-- ----
	for v_row in select * from "_csctoss_repl".sl_table
	loop
		perform "_csctoss_repl".alterTableRestore(v_row.tab_id);
	end loop;
	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION ddlscript_prepare_int(integer, integer) IS 'ddlScript_prepare_int (set_id, only_on_node)

Do preparatory work for a DDL script, restoring 
triggers/rules to original state.';

CREATE OR REPLACE FUNCTION denyaccess() RETURNS "trigger"
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_denyAccess';

COMMENT ON FUNCTION denyaccess() IS 'Trigger function to prevent modifications to a table on a subscriber';

CREATE OR REPLACE FUNCTION determineattkindserial(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	v_attkind		text default '';
	v_attrow		record;
	v_have_serial	bool default 'f';
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	--
	-- Loop over the attributes of this relation
	-- and add a "v" for every user column, and a "k"
	-- if we find the Slony-I special serial column.
	--
	for v_attrow in select PGA.attnum, PGA.attname
			from "pg_catalog".pg_class PGC,
			    "pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_attribute PGA
			where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			    "_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
				and PGN.oid = PGC.relnamespace
				and PGA.attrelid = PGC.oid
				and not PGA.attisdropped
				and PGA.attnum > 0
			order by attnum
	loop
		if v_attrow.attname = '_Slony-I_csctoss_repl_rowID' then
		    v_attkind := v_attkind || 'k';
			v_have_serial := 't';
		else
			v_attkind := v_attkind || 'v';
		end if;
	end loop;
	
	--
	-- A table must have at least one attribute, so not finding
	-- anything means the table does not exist.
	--
	if not found then
		raise exception 'Slony-I: table % not found', v_tab_fqname_quoted;
	end if;

	--
	-- If it does not have the special serial column, we
	-- should not have been called in the first place.
	--
	if not v_have_serial then
		raise exception 'Slony-I: table % does not have the serial key',
				v_tab_fqname_quoted;
	end if;

	execute 'update ' || v_tab_fqname_quoted ||
		' set "_Slony-I_csctoss_repl_rowID" =' ||
		' "pg_catalog".nextval(''"_csctoss_repl".sl_rowid_seq'');';
	execute 'alter table only ' || v_tab_fqname_quoted ||
		' add unique ("_Slony-I_csctoss_repl_rowID");';
	execute 'alter table only ' || v_tab_fqname_quoted ||
		' alter column "_Slony-I_csctoss_repl_rowID" ' ||
		' set not null;';

	--
	-- Return the resulting Slony-I attkind
	--
	return v_attkind;
end;
$_$;

COMMENT ON FUNCTION determineattkindserial(text) IS 'determineAttKindSerial (tab_fqname)

A table was that was specified without a primary key is added to the
replication. Assume that tableAddKey() was called before and finish
the creation of the serial column. The return an attkind according to
that.';

CREATE OR REPLACE FUNCTION determineattkindunique(text, name) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	p_idx_name		alias for $2;
	v_idx_name_quoted	text;
	v_idxrow		record;
	v_attrow		record;
	v_i				integer;
	v_attno			int2;
	v_attkind		text default '';
	v_attfound		bool;
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	v_idx_name_quoted := "_csctoss_repl".slon_quote_brute(p_idx_name);
	--
	-- Ensure that the table exists
	--
	if (select PGC.relname
				from "pg_catalog".pg_class PGC,
					"pg_catalog".pg_namespace PGN
				where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
					"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
					and PGN.oid = PGC.relnamespace) is null then
		raise exception 'Slony-I: table % not found', v_tab_fqname_quoted;
	end if;

	--
	-- Lookup the tables primary key or the specified unique index
	--
	if p_idx_name isnull then
		raise exception 'Slony-I: index name must be specified';
	else
		select PGXC.relname, PGX.indexrelid, PGX.indkey
				into v_idxrow
				from "pg_catalog".pg_class PGC,
					"pg_catalog".pg_namespace PGN,
					"pg_catalog".pg_index PGX,
					"pg_catalog".pg_class PGXC
				where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
					"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
					and PGN.oid = PGC.relnamespace
					and PGX.indrelid = PGC.oid
					and PGX.indexrelid = PGXC.oid
					and PGX.indisunique
					and "_csctoss_repl".slon_quote_brute(PGXC.relname) = v_idx_name_quoted;
		if not found then
			raise exception 'Slony-I: table % has no unique index %',
					v_tab_fqname_quoted, v_idx_name_quoted;
		end if;
	end if;

	--
	-- Loop over the tables attributes and check if they are
	-- index attributes. If so, add a "k" to the return value,
	-- otherwise add a "v".
	--
	for v_attrow in select PGA.attnum, PGA.attname
			from "pg_catalog".pg_class PGC,
			    "pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_attribute PGA
			where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			    "_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
				and PGN.oid = PGC.relnamespace
				and PGA.attrelid = PGC.oid
				and not PGA.attisdropped
				and PGA.attnum > 0
			order by attnum
	loop
		v_attfound = 'f';

		v_i := 0;
		loop
			select indkey[v_i] into v_attno from "pg_catalog".pg_index
					where indexrelid = v_idxrow.indexrelid;
			if v_attno isnull or v_attno = 0 then
				exit;
			end if;
			if v_attrow.attnum = v_attno then
				v_attfound = 't';
				exit;
			end if;
			v_i := v_i + 1;
		end loop;

		if v_attfound then
			v_attkind := v_attkind || 'k';
		else
			v_attkind := v_attkind || 'v';
		end if;
	end loop;

	--
	-- Return the resulting attkind
	--
	return v_attkind;
end;
$_$;

COMMENT ON FUNCTION determineattkindunique(text, name) IS 'determineAttKindUnique (tab_fqname, indexname)

Given a tablename, return the Slony-I specific attkind (used for the
log trigger) of the table. Use the specified unique index or the
primary key (if indexname is NULL).';

CREATE OR REPLACE FUNCTION determineidxnameserial(text) RETURNS name
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	v_row			record;
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	--
	-- Lookup the table name alone
	--
	select PGC.relname
			into v_row
			from "pg_catalog".pg_class PGC,
				"pg_catalog".pg_namespace PGN
			where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
				"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
				and PGN.oid = PGC.relnamespace;
	if not found then
		raise exception 'Slony-I: table % not found',
				v_tab_fqname_quoted;
	end if;

	--
	-- Return the found index name
	--
	return v_row.relname || '__Slony-I_csctoss_repl_rowID_key';
end;
$_$;

COMMENT ON FUNCTION determineidxnameserial(text) IS 'determineIdxnameSerial (tab_fqname)

Given a tablename, construct the index name of the serial column.';

CREATE OR REPLACE FUNCTION determineidxnameunique(text, name) RETURNS name
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	p_idx_name		alias for $2;
	v_idxrow		record;
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	--
	-- Ensure that the table exists
	--
	if (select PGC.relname
				from "pg_catalog".pg_class PGC,
					"pg_catalog".pg_namespace PGN
				where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
					"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
					and PGN.oid = PGC.relnamespace) is null then
		raise exception 'Slony-I: determineIdxnameUnique(): table % not found', v_tab_fqname_quoted;
	end if;

	--
	-- Lookup the tables primary key or the specified unique index
	--
	if p_idx_name isnull then
		select PGXC.relname
				into v_idxrow
				from "pg_catalog".pg_class PGC,
					"pg_catalog".pg_namespace PGN,
					"pg_catalog".pg_index PGX,
					"pg_catalog".pg_class PGXC
				where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
					"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
					and PGN.oid = PGC.relnamespace
					and PGX.indrelid = PGC.oid
					and PGX.indexrelid = PGXC.oid
					and PGX.indisprimary;
		if not found then
			raise exception 'Slony-I: table % has no primary key',
					v_tab_fqname_quoted;
		end if;
	else
		select PGXC.relname
				into v_idxrow
				from "pg_catalog".pg_class PGC,
					"pg_catalog".pg_namespace PGN,
					"pg_catalog".pg_index PGX,
					"pg_catalog".pg_class PGXC
				where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
					"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
					and PGN.oid = PGC.relnamespace
					and PGX.indrelid = PGC.oid
					and PGX.indexrelid = PGXC.oid
					and PGX.indisunique
					and "_csctoss_repl".slon_quote_brute(PGXC.relname) = "_csctoss_repl".slon_quote_input(p_idx_name);
		if not found then
			raise exception 'Slony-I: table % has no unique index %',
					v_tab_fqname_quoted, p_idx_name;
		end if;
	end if;

	--
	-- Return the found index name
	--
	return v_idxrow.relname;
end;
$_$;

COMMENT ON FUNCTION determineidxnameunique(text, name) IS 'FUNCTION determineIdxnameUnique (tab_fqname, indexname)

Given a tablename, tab_fqname, check that the unique index, indexname,
exists or return the primary key index name for the table.  If there
is no unique index, it raises an exception.';

CREATE OR REPLACE FUNCTION disablenode(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
begin
	-- **** TODO ****
	raise exception 'Slony-I: disableNode() not implemented';
end;
$_$;

COMMENT ON FUNCTION disablenode(integer) IS 'process DISABLE_NODE event for node no_id

NOTE: This is not yet implemented!';

CREATE OR REPLACE FUNCTION disablenode_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
begin
	-- **** TODO ****
	raise exception 'Slony-I: disableNode_int() not implemented';
end;
$_$;

CREATE OR REPLACE FUNCTION drop_if_exists(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
  p_function alias for $1;
  p_args alias for $2;
  v_drop text;
begin
  if exists (select 1 from information_schema.routines where routine_schema = '_csctoss_repl' and routine_name = p_function) then
	v_drop := 'drop function "_csctoss_repl".' || p_function || '(' || p_args || ');';
	execute v_drop;
	return 1;
  end if;
  return 0;
end
$_$;

COMMENT ON FUNCTION drop_if_exists(text, text) IS 'Emulate DROP FUNCTION IF EXISTS, which does not exist in 7.4, 8.0, 8.1';

CREATE OR REPLACE FUNCTION droplisten(integer, integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_li_origin		alias for $1;
	p_li_provider	alias for $2;
	p_li_receiver	alias for $3;
begin
	perform "_csctoss_repl".dropListen_int(p_li_origin, 
			p_li_provider, p_li_receiver);
	
	return  "_csctoss_repl".createEvent ('_csctoss_repl', 'DROP_LISTEN',
			p_li_origin::text, p_li_provider::text, p_li_receiver::text);
end;
$_$;

COMMENT ON FUNCTION droplisten(integer, integer, integer) IS 'dropListen (li_origin, li_provider, li_receiver)

Generate the DROP_LISTEN event.';

CREATE OR REPLACE FUNCTION droplisten_int(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_li_origin		alias for $1;
	p_li_provider	alias for $2;
	p_li_receiver	alias for $3;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	delete from "_csctoss_repl".sl_listen
			where li_origin = p_li_origin
			and li_provider = p_li_provider
			and li_receiver = p_li_receiver;
	if found then
		return 1;
	else
		return 0;
	end if;
end;
$_$;

COMMENT ON FUNCTION droplisten_int(integer, integer, integer) IS 'dropListen (li_origin, li_provider, li_receiver)

Process the DROP_LISTEN event, deleting the sl_listen entry for
the indicated (origin,provider,receiver) combination.';

CREATE OR REPLACE FUNCTION dropnode(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	v_node_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that this got called on a different node
	-- ----
	if p_no_id = "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: DROP_NODE cannot initiate on the dropped node';
	end if;

	select * into v_node_row from "_csctoss_repl".sl_node
			where no_id = p_no_id
			for update;
	if not found then
		raise exception 'Slony-I: unknown node ID %', p_no_id;
	end if;

	-- ----
	-- Make sure we do not break other nodes subscriptions with this
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe
			where sub_provider = p_no_id)
	then
		raise exception 'Slony-I: Node % is still configured as a data provider',
				p_no_id;
	end if;

	-- ----
	-- Make sure no set originates there any more
	-- ----
	if exists (select true from "_csctoss_repl".sl_set
			where set_origin = p_no_id)
	then
		raise exception 'Slony-I: Node % is still origin of one or more sets',
				p_no_id;
	end if;

	-- ----
	-- Call the internal drop functionality and generate the event
	-- ----
	perform "_csctoss_repl".dropNode_int(p_no_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'DROP_NODE',
									p_no_id::text);
end;
$_$;

COMMENT ON FUNCTION dropnode(integer) IS 'generate DROP_NODE event to drop node node_id from replication';

CREATE OR REPLACE FUNCTION dropnode_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	v_tab_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- If the dropped node is a remote node, clean the configuration
	-- from all traces for it.
	-- ----
	if p_no_id <> "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		delete from "_csctoss_repl".sl_subscribe
				where sub_receiver = p_no_id;
		delete from "_csctoss_repl".sl_listen
				where li_origin = p_no_id
					or li_provider = p_no_id
					or li_receiver = p_no_id;
		delete from "_csctoss_repl".sl_path
				where pa_server = p_no_id
					or pa_client = p_no_id;
		delete from "_csctoss_repl".sl_confirm
				where con_origin = p_no_id
					or con_received = p_no_id;
		delete from "_csctoss_repl".sl_event
				where ev_origin = p_no_id;
		delete from "_csctoss_repl".sl_node
				where no_id = p_no_id;

		return p_no_id;
	end if;

	-- ----
	-- This is us ... deactivate the node for now, the daemon
	-- will call uninstallNode() in a separate transaction.
	-- ----
	update "_csctoss_repl".sl_node
			set no_active = false
			where no_id = p_no_id;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	return p_no_id;
end;
$_$;

COMMENT ON FUNCTION dropnode_int(integer) IS 'internal function to process DROP_NODE event to drop node node_id from replication';

CREATE OR REPLACE FUNCTION droppath(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_pa_server		alias for $1;
	p_pa_client		alias for $2;
	v_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- There should be no existing subscriptions. Auto unsubscribing
	-- is considered too dangerous. 
	-- ----
	for v_row in select sub_set, sub_provider, sub_receiver
			from "_csctoss_repl".sl_subscribe
			where sub_provider = p_pa_server
			and sub_receiver = p_pa_client
	loop
		raise exception 
			'Slony-I: Path cannot be dropped, subscription of set % needs it',
			v_row.sub_set;
	end loop;

	-- ----
	-- Drop all sl_listen entries that depend on this path
	-- ----
	for v_row in select li_origin, li_provider, li_receiver
			from "_csctoss_repl".sl_listen
			where li_provider = p_pa_server
			and li_receiver = p_pa_client
	loop
		perform "_csctoss_repl".dropListen(
				v_row.li_origin, v_row.li_provider, v_row.li_receiver);
	end loop;

	-- ----
	-- Now drop the path and create the event
	-- ----
	perform "_csctoss_repl".dropPath_int(p_pa_server, p_pa_client);

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	return  "_csctoss_repl".createEvent ('_csctoss_repl', 'DROP_PATH',
			p_pa_server::text, p_pa_client::text);
end;
$_$;

COMMENT ON FUNCTION droppath(integer, integer) IS 'Generate DROP_PATH event to drop path from pa_server to pa_client';

CREATE OR REPLACE FUNCTION droppath_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_pa_server		alias for $1;
	p_pa_client		alias for $2;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Remove any dangling sl_listen entries with the server
	-- as provider and the client as receiver. This must have
	-- been cleared out before, but obviously was not.
	-- ----
	delete from "_csctoss_repl".sl_listen
			where li_provider = p_pa_server
			and li_receiver = p_pa_client;

	delete from "_csctoss_repl".sl_path
			where pa_server = p_pa_server
			and pa_client = p_pa_client;

	if found then
		-- Rewrite sl_listen table
		perform "_csctoss_repl".RebuildListenEntries();

		return 1;
	else
		-- Rewrite sl_listen table
		perform "_csctoss_repl".RebuildListenEntries();

		return 0;
	end if;
end;
$_$;

COMMENT ON FUNCTION droppath_int(integer, integer) IS 'Process DROP_PATH event to drop path from pa_server to pa_client';

CREATE OR REPLACE FUNCTION dropset(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	v_origin			int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	-- ----
	-- Check that the set exists and originates here
	-- ----
	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
	end if;

	-- ----
	-- Call the internal drop set functionality and generate the event
	-- ----
	perform "_csctoss_repl".dropSet_int(p_set_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'DROP_SET', 
			p_set_id::text);
end;
$_$;

COMMENT ON FUNCTION dropset(integer) IS 'Process DROP_SET event to drop replication of set set_id.  This involves:
- Restoring original triggers and rules
- Removing all traces of the set configuration, including sequences, tables, subscribers, syncs, and the set itself';

CREATE OR REPLACE FUNCTION dropset_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	v_tab_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	-- ----
	-- Restore all tables original triggers and rules and remove
	-- our replication stuff.
	-- ----
	for v_tab_row in select tab_id from "_csctoss_repl".sl_table
			where tab_set = p_set_id
			order by tab_id
	loop
		perform "_csctoss_repl".alterTableRestore(v_tab_row.tab_id);
		perform "_csctoss_repl".tableDropKey(v_tab_row.tab_id);
	end loop;

	-- ----
	-- Remove all traces of the set configuration
	-- ----
	delete from "_csctoss_repl".sl_sequence
			where seq_set = p_set_id;
	delete from "_csctoss_repl".sl_table
			where tab_set = p_set_id;
	delete from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id;
	delete from "_csctoss_repl".sl_setsync
			where ssy_setid = p_set_id;
	delete from "_csctoss_repl".sl_set
			where set_id = p_set_id;

	-- Regenerate sl_listen since we revised the subscriptions
	perform "_csctoss_repl".RebuildListenEntries();

	-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
	perform "_csctoss_repl".addPartialLogIndices();

	return p_set_id;
end;
$_$;

CREATE OR REPLACE FUNCTION droptrigger(integer, name) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_trig_tabid		alias for $1;
	p_trig_tgname		alias for $2;
begin
	perform "_csctoss_repl".dropTrigger_int(p_trig_tabid, p_trig_tgname);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'DROP_TRIGGER',
			p_trig_tabid::text, p_trig_tgname::text);
end;
$_$;

COMMENT ON FUNCTION droptrigger(integer, name) IS 'dropTrigger (trig_tabid, trig_tgname)

Submits DROP_TRIGGER event to indicate that trigger trig_tgname on
replicated table trig_tabid WILL be disabled.';

CREATE OR REPLACE FUNCTION droptrigger_int(integer, name) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_trig_tabid		alias for $1;
	p_trig_tgname		alias for $2;
	v_tab_altered		boolean;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get the current table status (altered or not)
	-- ----
	select tab_altered into v_tab_altered
			from "_csctoss_repl".sl_table where tab_id = p_trig_tabid;
	if not found then
		-- ----
		-- Not found is no hard error here, because that might
		-- mean that we are not subscribed to that set
		-- ----
		return 0;
	end if;

	-- ----
	-- If the table is modified for replication, restore the original state
	-- ----
	if v_tab_altered then
		perform "_csctoss_repl".alterTableRestore(p_trig_tabid);
	end if;

	-- ----
	-- Remove the entry from sl_trigger
	-- ----
	delete from "_csctoss_repl".sl_trigger
			where trig_tabid = p_trig_tabid
			  and trig_tgname = p_trig_tgname;

	-- ----
	-- Put the table back into replicated state if it was
	-- ----
	if v_tab_altered then
		perform "_csctoss_repl".alterTableForReplication(p_trig_tabid);
	end if;

	return p_trig_tabid;
end;
$_$;

COMMENT ON FUNCTION droptrigger_int(integer, name) IS 'dropTrigger_int (trig_tabid, trig_tgname)

Processes DROP_TRIGGER event to make sure that trigger trig_tgname on
replicated table trig_tabid IS disabled.';

CREATE OR REPLACE FUNCTION enablenode(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	v_local_node_id	int4;
	v_node_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that we are the node to activate and that we are
	-- currently disabled.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select * into v_node_row
			from "_csctoss_repl".sl_node
			where no_id = p_no_id
			for update;
	if not found then 
		raise exception 'Slony-I: node % not found', p_no_id;
	end if;
	if v_node_row.no_active then
		raise exception 'Slony-I: node % is already active', p_no_id;
	end if;

	-- ----
	-- Activate this node and generate the ENABLE_NODE event
	-- ----
	perform "_csctoss_repl".enableNode_int (p_no_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'ENABLE_NODE',
									p_no_id::text);
end;
$_$;

COMMENT ON FUNCTION enablenode(integer) IS 'no_id - Node ID #

Generate the ENABLE_NODE event for node no_id';

CREATE OR REPLACE FUNCTION enablenode_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	v_local_node_id	int4;
	v_node_row		record;
	v_sub_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that the node is inactive
	-- ----
	select * into v_node_row
			from "_csctoss_repl".sl_node
			where no_id = p_no_id
			for update;
	if not found then 
		raise exception 'Slony-I: node % not found', p_no_id;
	end if;
	if v_node_row.no_active then
		return p_no_id;
	end if;

	-- ----
	-- Activate the node and generate sl_confirm status rows for it.
	-- ----
	update "_csctoss_repl".sl_node
			set no_active = 't'
			where no_id = p_no_id;
	insert into "_csctoss_repl".sl_confirm
			(con_origin, con_received, con_seqno)
			select no_id, p_no_id, 0 from "_csctoss_repl".sl_node
				where no_id != p_no_id
				and no_active;
	insert into "_csctoss_repl".sl_confirm
			(con_origin, con_received, con_seqno)
			select p_no_id, no_id, 0 from "_csctoss_repl".sl_node
				where no_id != p_no_id
				and no_active;

	-- ----
	-- Generate ENABLE_SUBSCRIPTION events for all sets that
	-- origin here and are subscribed by the just enabled node.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	for v_sub_row in select SUB.sub_set, SUB.sub_provider from
			"_csctoss_repl".sl_set S,
			"_csctoss_repl".sl_subscribe SUB
			where S.set_origin = v_local_node_id
			and S.set_id = SUB.sub_set
			and SUB.sub_receiver = p_no_id
			for update of S
	loop
		perform "_csctoss_repl".enableSubscription (v_sub_row.sub_set,
				v_sub_row.sub_provider, p_no_id);
	end loop;

	return p_no_id;
end;
$_$;

COMMENT ON FUNCTION enablenode_int(integer) IS 'no_id - Node ID #

Internal function to process the ENABLE_NODE event for node no_id';

CREATE OR REPLACE FUNCTION enablesubscription(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_provider		alias for $2;
	p_sub_receiver		alias for $3;
begin
	return  "_csctoss_repl".enableSubscription_int (p_sub_set, 
			p_sub_provider, p_sub_receiver);
end;
$_$;

COMMENT ON FUNCTION enablesubscription(integer, integer, integer) IS 'enableSubscription (sub_set, sub_provider, sub_receiver)

Indicates that sub_receiver intends subscribing to set sub_set from
sub_provider.  Work is all done by the internal function
enableSubscription_int (sub_set, sub_provider, sub_receiver).';

CREATE OR REPLACE FUNCTION enablesubscription_int(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_provider		alias for $2;
	p_sub_receiver		alias for $3;
	v_n					int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- The real work is done in the replication engine. All
	-- we have to do here is remembering that it happened.
	-- ----

	-- ----
	-- Well, not only ... we might be missing an important event here
	-- ----
	if not exists (select true from "_csctoss_repl".sl_path
			where pa_server = p_sub_provider
			and pa_client = p_sub_receiver)
	then
		insert into "_csctoss_repl".sl_path
				(pa_server, pa_client, pa_conninfo, pa_connretry)
				values 
				(p_sub_provider, p_sub_receiver, 
				'<event pending>', 10);
	end if;

	update "_csctoss_repl".sl_subscribe
			set sub_active = 't'
			where sub_set = p_sub_set
			and sub_receiver = p_sub_receiver;
	get diagnostics v_n = row_count;
	if v_n = 0 then
		insert into "_csctoss_repl".sl_subscribe
				(sub_set, sub_provider, sub_receiver,
				sub_forward, sub_active)
				values
				(p_sub_set, p_sub_provider, p_sub_receiver,
				false, true);
	end if;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	return p_sub_set;
end;
$_$;

COMMENT ON FUNCTION enablesubscription_int(integer, integer, integer) IS 'enableSubscription_int (sub_set, sub_provider, sub_receiver)

Internal function to enable subscription of node sub_receiver to set
sub_set via node sub_provider.

slon does most of the work; all we need do here is to remember that it
happened.  The function updates sl_subscribe, indicating that the
subscription has become active.';

CREATE OR REPLACE FUNCTION failednode(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_failed_node		alias for $1;
	p_backup_node		alias for $2;
	v_row				record;
	v_row2				record;
	v_n					int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- All consistency checks first
	-- Check that every node that has a path to the failed node
	-- also has a path to the backup node.
	-- ----
	for v_row in select P.pa_client
			from "_csctoss_repl".sl_path P
			where P.pa_server = p_failed_node
				and P.pa_client <> p_backup_node
				and not exists (select true from "_csctoss_repl".sl_path PP
							where PP.pa_server = p_backup_node
								and PP.pa_client = P.pa_client)
	loop
		raise notice 'Slony-I: Warning: node % has no path to the backup node',
				v_row.pa_client;
	end loop;

	-- ----
	-- Check all sets originating on the failed node
	-- ----
	for v_row in select set_id
			from "_csctoss_repl".sl_set
			where set_origin = p_failed_node
	loop
		-- ----
		-- Check that the backup node is subscribed to all sets
		-- that originate on the failed node
		-- ----
		select into v_row2 sub_forward, sub_active
				from "_csctoss_repl".sl_subscribe
				where sub_set = v_row.set_id
					and sub_receiver = p_backup_node;
		if not found then
			raise exception 'Slony-I: cannot failover - node % is not subscribed to set %',
					p_backup_node, v_row.set_id;
		end if;

		-- ----
		-- Check that the subscription is active
		-- ----
		if not v_row2.sub_active then
			raise exception 'Slony-I: cannot failover - subscription for set % is not active',
					v_row.set_id;
		end if;

		-- ----
		-- If there are other subscribers, the backup node needs to
		-- be a forwarder too.
		-- ----
		select into v_n count(*)
				from "_csctoss_repl".sl_subscribe
				where sub_set = v_row.set_id
					and sub_receiver <> p_backup_node;
		if v_n > 0 and not v_row2.sub_forward then
			raise exception 'Slony-I: cannot failover - node % is not a forwarder of set %',
					p_backup_node, v_row.set_id;
		end if;
	end loop;

	-- ----
	-- Terminate all connections of the failed node the hard way
	-- ----
	perform "_csctoss_repl".terminateNodeConnections(p_failed_node);

	-- ----
	-- Move the sets
	-- ----
	for v_row in select S.set_id, (select count(*)
					from "_csctoss_repl".sl_subscribe SUB
					where S.set_id = SUB.sub_set
						and SUB.sub_receiver <> p_backup_node
						and SUB.sub_provider = p_failed_node)
					as num_direct_receivers 
			from "_csctoss_repl".sl_set S
			where S.set_origin = p_failed_node
			for update
	loop
		-- ----
		-- If the backup node is the only direct subscriber ...
		-- ----
		if v_row.num_direct_receivers = 0 then
		        raise notice 'failedNode: set % has no other direct receivers - move now', v_row.set_id;
			-- ----
			-- backup_node is the only direct subscriber, move the set
			-- right now. On the backup node itself that includes restoring
			-- all user mode triggers, removing the protection trigger,
			-- adding the log trigger, removing the subscription and the
			-- obsolete setsync status.
			-- ----
			if p_backup_node = "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
				for v_row2 in select * from "_csctoss_repl".sl_table
						where tab_set = v_row.set_id
				loop
					perform "_csctoss_repl".alterTableRestore(v_row2.tab_id);
				end loop;

				update "_csctoss_repl".sl_set set set_origin = p_backup_node
						where set_id = v_row.set_id;

				delete from "_csctoss_repl".sl_setsync
						where ssy_setid = v_row.set_id;

				for v_row2 in select * from "_csctoss_repl".sl_table
						where tab_set = v_row.set_id
				loop
					perform "_csctoss_repl".alterTableForReplication(v_row2.tab_id);
				end loop;
			end if;

			delete from "_csctoss_repl".sl_subscribe
					where sub_set = v_row.set_id
						and sub_receiver = p_backup_node;
		else
			raise notice 'failedNode: set % has other direct receivers - change providers only', v_row.set_id;
			-- ----
			-- Backup node is not the only direct subscriber or not
			-- a direct subscriber at all. 
			-- This means that at this moment, we redirect all possible
			-- direct subscribers to receive from the backup node, and the
			-- backup node itself to receive from another one.
			-- The admin utility will wait for the slon engine to
			-- restart and then call failedNode2() on the node with
			-- the highest SYNC and redirect this to it on
			-- backup node later.
			-- ----
			update "_csctoss_repl".sl_subscribe
					set sub_provider = (select min(SS.sub_receiver)
							from "_csctoss_repl".sl_subscribe SS
							where SS.sub_set = v_row.set_id
								and SS.sub_receiver <> p_backup_node
								and SS.sub_forward
								and exists (
									select 1 from "_csctoss_repl".sl_path
										where pa_server = SS.sub_receiver
										  and pa_client = p_backup_node
								))
					where sub_set = v_row.set_id
						and sub_receiver = p_backup_node;
			update "_csctoss_repl".sl_subscribe
					set sub_provider = (select min(SS.sub_receiver)
							from "_csctoss_repl".sl_subscribe SS
							where SS.sub_set = v_row.set_id
								and SS.sub_receiver <> p_failed_node
								and SS.sub_forward
								and exists (
									select 1 from "_csctoss_repl".sl_path
										where pa_server = SS.sub_receiver
										  and pa_client = "_csctoss_repl".sl_subscribe.sub_receiver
								))
					where sub_set = v_row.set_id
						and sub_receiver <> p_backup_node;
			update "_csctoss_repl".sl_subscribe
					set sub_provider = p_backup_node
					where sub_set = v_row.set_id
						and sub_receiver <> p_backup_node
						and exists (
							select 1 from "_csctoss_repl".sl_path
								where pa_server = p_backup_node
								  and pa_client = "_csctoss_repl".sl_subscribe.sub_receiver
						);
		end if;
	end loop;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
	perform "_csctoss_repl".addPartialLogIndices();

	-- ----
	-- Make sure the node daemon will restart
	-- ----
	notify "_csctoss_repl_Restart";

	-- ----
	-- That is it - so far.
	-- ----
	return p_failed_node;
end;
$_$;

COMMENT ON FUNCTION failednode(integer, integer) IS 'Initiate failover from failed_node to backup_node.  This function must be called on all nodes, 
and then waited for the restart of all node daemons.';

CREATE OR REPLACE FUNCTION failednode2(integer, integer, integer, bigint, bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_failed_node		alias for $1;
	p_backup_node		alias for $2;
	p_set_id			alias for $3;
	p_ev_seqno			alias for $4;
	p_ev_seqfake		alias for $5;
	v_row				record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	select * into v_row
			from "_csctoss_repl".sl_event
			where ev_origin = p_failed_node
			and ev_seqno = p_ev_seqno;
	if not found then
		raise exception 'Slony-I: event %,% not found',
				p_failed_node, p_ev_seqno;
	end if;

	insert into "_csctoss_repl".sl_event
			(ev_origin, ev_seqno, ev_timestamp,
			ev_minxid, ev_maxxid, ev_xip,
			ev_type, ev_data1, ev_data2, ev_data3)
			values 
			(p_failed_node, p_ev_seqfake, CURRENT_TIMESTAMP,
			v_row.ev_minxid, v_row.ev_maxxid, v_row.ev_xip,
			'FAILOVER_SET', p_failed_node::text, p_backup_node::text,
			p_set_id::text);
	insert into "_csctoss_repl".sl_confirm
			(con_origin, con_received, con_seqno, con_timestamp)
			values
			(p_failed_node, "_csctoss_repl".getLocalNodeId('_csctoss_repl'),
			p_ev_seqfake, CURRENT_TIMESTAMP);
	notify "_csctoss_repl_Event";
	notify "_csctoss_repl_Confirm";
	notify "_csctoss_repl_Restart";

	perform "_csctoss_repl".failoverSet_int(p_failed_node,
			p_backup_node, p_set_id, p_ev_seqfake);

	return p_ev_seqfake;
end;
$_$;

COMMENT ON FUNCTION failednode2(integer, integer, integer, bigint, bigint) IS 'FUNCTION failedNode2 (failed_node, backup_node, set_id, ev_seqno, ev_seqfake)

On the node that has the highest sequence number of the failed node,
fake the FAILOVER_SET event.';

CREATE OR REPLACE FUNCTION failoverset_int(integer, integer, integer, bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_failed_node		alias for $1;
	p_backup_node		alias for $2;
	p_set_id			alias for $3;
	p_wait_seqno		alias for $4;
	v_row				record;
	v_last_sync			int8;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Change the origin of the set now to the backup node.
	-- On the backup node this includes changing all the
	-- trigger and protection stuff
	-- ----
	if p_backup_node = "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		for v_row in select * from "_csctoss_repl".sl_table
				where tab_set = p_set_id
		loop
			perform "_csctoss_repl".alterTableRestore(v_row.tab_id);
		end loop;

		delete from "_csctoss_repl".sl_setsync
				where ssy_setid = p_set_id;
		delete from "_csctoss_repl".sl_subscribe
				where sub_set = p_set_id
					and sub_receiver = p_backup_node;
		update "_csctoss_repl".sl_set
				set set_origin = p_backup_node
				where set_id = p_set_id;

		for v_row in select * from "_csctoss_repl".sl_table
				where tab_set = p_set_id
		loop
			perform "_csctoss_repl".alterTableForReplication(v_row.tab_id);
		end loop;
		insert into "_csctoss_repl".sl_event
				(ev_origin, ev_seqno, ev_timestamp,
				ev_minxid, ev_maxxid, ev_xip,
				ev_type, ev_data1, ev_data2, ev_data3, ev_data4)
				values
				(p_backup_node, "pg_catalog".nextval('"_csctoss_repl".sl_event_seq'), CURRENT_TIMESTAMP,
				'0', '0', '',
				'ACCEPT_SET', p_set_id::text,
				p_failed_node::text, p_backup_node::text,
				p_wait_seqno::text);
	else
		delete from "_csctoss_repl".sl_subscribe
				where sub_set = p_set_id
					and sub_receiver = p_backup_node;
		update "_csctoss_repl".sl_set
				set set_origin = p_backup_node
				where set_id = p_set_id;
	end if;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	-- ----
	-- If we are a subscriber of the set ourself, change our
	-- setsync status to reflect the new set origin.
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id
				and sub_receiver = "_csctoss_repl".getLocalNodeId(
						'_csctoss_repl'))
	then
		delete from "_csctoss_repl".sl_setsync
				where ssy_setid = p_set_id;

		select coalesce(max(ev_seqno), 0) into v_last_sync
				from "_csctoss_repl".sl_event
				where ev_origin = p_backup_node
					and ev_type = 'SYNC';
		if v_last_sync > 0 then
			insert into "_csctoss_repl".sl_setsync
					(ssy_setid, ssy_origin, ssy_seqno,
					ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
					select p_set_id, p_backup_node, v_last_sync,
					ev_minxid, ev_maxxid, ev_xip, NULL
					from "_csctoss_repl".sl_event
					where ev_origin = p_backup_node
						and ev_seqno = v_last_sync;
		else
			insert into "_csctoss_repl".sl_setsync
					(ssy_setid, ssy_origin, ssy_seqno,
					ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
					values (p_set_id, p_backup_node, '0',
					'0', '0', '', NULL);
		end if;
				
	end if;

	return p_failed_node;
end;
$_$;

COMMENT ON FUNCTION failoverset_int(integer, integer, integer, bigint) IS 'FUNCTION failoverSet_int (failed_node, backup_node, set_id, wait_seqno)

Finish failover for one set.';

CREATE OR REPLACE FUNCTION finishtableaftercopy(integer) RETURNS integer
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
	-- Reenable indexes and reindex the table.
	-- ----
	update pg_class set relhasindex = 't' where oid = v_tab_oid;
	execute 'reindex table ' || "_csctoss_repl".slon_quote_input(v_tab_fqname);

	return 1;
end;
$_$;

COMMENT ON FUNCTION finishtableaftercopy(integer) IS 'Reenable index maintenance and reindex the table';

CREATE OR REPLACE FUNCTION forwardconfirm(integer, integer, bigint, timestamp without time zone) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_con_origin	alias for $1;
	p_con_received	alias for $2;
	p_con_seqno		alias for $3;
	p_con_timestamp	alias for $4;
	v_max_seqno		bigint;
begin
	select into v_max_seqno coalesce(max(con_seqno), 0)
			from "_csctoss_repl".sl_confirm
			where con_origin = p_con_origin
			and con_received = p_con_received;
	if v_max_seqno < p_con_seqno then
		insert into "_csctoss_repl".sl_confirm 
				(con_origin, con_received, con_seqno, con_timestamp)
				values (p_con_origin, p_con_received, p_con_seqno,
					p_con_timestamp);
		notify "_csctoss_repl_Confirm";
		v_max_seqno = p_con_seqno;
	end if;

	return v_max_seqno;
end;
$_$;

COMMENT ON FUNCTION forwardconfirm(integer, integer, bigint, timestamp without time zone) IS 'forwardConfirm (p_con_origin, p_con_received, p_con_seqno, p_con_timestamp)

Confirms (recorded in sl_confirm) that items from p_con_origin up to
p_con_seqno have been received by node p_con_received as of
p_con_timestamp, and raises an event to forward this confirmation.';

CREATE OR REPLACE FUNCTION generate_sync_event(interval) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_interval     alias for $1;
	v_node_row     record;

BEGIN
	select 1 into v_node_row from "_csctoss_repl".sl_event 
       	  where ev_type = 'SYNC' and ev_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl')
          and ev_timestamp > now() - p_interval limit 1;
	if not found then
		-- If there has been no SYNC in the last interval, then push one
		perform "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC', NULL);
		return 1;
	else
		return 0;
	end if;
end;
$_$;

COMMENT ON FUNCTION generate_sync_event(interval) IS 'Generate a sync event if there has not been one in the requested interval.';

CREATE OR REPLACE FUNCTION getcurrentxid() RETURNS xxid
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_getCurrentXid';

CREATE OR REPLACE FUNCTION getlocalnodeid(name) RETURNS integer
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_getLocalNodeId';

COMMENT ON FUNCTION getlocalnodeid(name) IS 'Returns the node ID of the node being serviced on the local database';

CREATE OR REPLACE FUNCTION getmaxxid() RETURNS xxid
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_getMaxXid';

CREATE OR REPLACE FUNCTION getminxid() RETURNS xxid
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_getMinXid';

CREATE OR REPLACE FUNCTION getmoduleversion() RETURNS text
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_getModuleVersion';

COMMENT ON FUNCTION getmoduleversion() IS 'Returns the compiled-in version number of the Slony-I shared object';

CREATE OR REPLACE FUNCTION getsessionrole(name) RETURNS text
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_getSessionRole';

COMMENT ON FUNCTION getsessionrole(name) IS 'not yet documented';

CREATE OR REPLACE FUNCTION initializelocalnode(integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_local_node_id		alias for $1;
	p_comment			alias for $2;
	v_old_node_id		int4;
	v_first_log_no		int4;
	v_event_seq			int8;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Make sure this node is uninitialized or got reset
	-- ----
	select last_value::int4 into v_old_node_id from "_csctoss_repl".sl_local_node_id;
	if v_old_node_id != -1 then
		raise exception 'Slony-I: This node is already initialized';
	end if;

	-- ----
	-- Set sl_local_node_id to the requested value and add our
	-- own system to sl_node.
	-- ----
	perform setval('"_csctoss_repl".sl_local_node_id', p_local_node_id);
	perform setval('"_csctoss_repl".sl_rowid_seq', 
			p_local_node_id::int8 * '1000000000000000'::int8);
	perform "_csctoss_repl".storeNode_int (p_local_node_id, p_comment, false);
	
	return p_local_node_id;
end;
$_$;

COMMENT ON FUNCTION initializelocalnode(integer, text) IS 'no_id - Node ID #
no_comment - Human-oriented comment

Initializes the new node, no_id';

CREATE OR REPLACE FUNCTION killbackend(integer, text) RETURNS integer
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_killBackend';

COMMENT ON FUNCTION killbackend(integer, text) IS 'Send a signal to a postgres process. Requires superuser rights';

CREATE OR REPLACE FUNCTION lockedset() RETURNS "trigger"
    LANGUAGE c
    AS '$libdir/slony1_funcs', '_Slony_I_lockedSet';

COMMENT ON FUNCTION lockedset() IS 'Trigger function to prevent modifications to a table before and after a moveSet()';

CREATE OR REPLACE FUNCTION lockset(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	v_local_node_id		int4;
	v_set_row			record;
	v_tab_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that the set exists and that we are the origin
	-- and that it is not already locked.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select * into v_set_row from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_set_row.set_origin <> v_local_node_id then
		raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
	end if;
	if v_set_row.set_locked notnull then
		raise exception 'Slony-I: set % is already locked', p_set_id;
	end if;

	-- ----
	-- Place the lockedSet trigger on all tables in the set.
	-- ----
	for v_tab_row in select T.tab_id,
			"_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) as tab_fqname
			from "_csctoss_repl".sl_table T,
				"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
			where T.tab_set = p_set_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid
			order by tab_id
	loop
		execute 'create trigger "_csctoss_repl_lockedset_' || 
				v_tab_row.tab_id || 
				'" before insert or update or delete on ' ||
				v_tab_row.tab_fqname || ' for each row execute procedure
				"_csctoss_repl".lockedSet (''_csctoss_repl'');';
	end loop;

	-- ----
	-- Remember our snapshots xmax as for the set locking
	-- ----
	update "_csctoss_repl".sl_set
			set set_locked = "_csctoss_repl".getMaxXid()
			where set_id = p_set_id;

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION lockset(integer) IS 'lockSet(set_id)

Add a special trigger to all tables of a set that disables access to
it.';

CREATE OR REPLACE FUNCTION logswitch_finish() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_current_status	int4;
	v_dummy				record;
BEGIN
	-- ----
	-- Grab the central configuration lock to prevent race conditions
	-- while changing the sl_log_status sequence value.
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get the current log status.
	-- ----
	select last_value into v_current_status from "_csctoss_repl".sl_log_status;

	-- ----
	-- status value 0 or 1 means that there is no log switch in progress
	-- ----
	if v_current_status = 0 or v_current_status = 1 then
		return 0;
	end if;

	-- ----
	-- status = 2: sl_log_1 active, cleanup sl_log_2
	-- ----
	if v_current_status = 2 then
		-- ----
		-- The cleanup thread calls us after it did the delete and
		-- vacuum of both log tables. If sl_log_2 is empty now, we
		-- can truncate it and the log switch is done.
		-- ----
		for v_dummy in select 1 from "_csctoss_repl".sl_log_2 loop
			-- ----
			-- Found a row ... log switch is still in progress.
			-- ----
			raise notice 'Slony-I: log switch to sl_log_1 still in progress - sl_log_2 not truncated';
			return -1;
		end loop;

		raise notice 'Slony-I: log switch to sl_log_1 complete - truncate sl_log_2';
		truncate "_csctoss_repl".sl_log_2;
		if exists (select * from "pg_catalog".pg_class c, "pg_catalog".pg_namespace n, "pg_catalog".pg_attribute a where c.relname = 'sl_log_2' and n.oid = c.relnamespace and a.attrelid = c.oid and a.attname = 'oid') then
	                execute 'alter table "_csctoss_repl".sl_log_2 set without oids;';
		end if;		
		perform "pg_catalog".setval('"_csctoss_repl".sl_log_status', 0);
		-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
		perform "_csctoss_repl".addPartialLogIndices();

		return 1;
	end if;

	-- ----
	-- status = 3: sl_log_2 active, cleanup sl_log_1
	-- ----
	if v_current_status = 3 then
		-- ----
		-- The cleanup thread calls us after it did the delete and
		-- vacuum of both log tables. If sl_log_2 is empty now, we
		-- can truncate it and the log switch is done.
		-- ----
		for v_dummy in select 1 from "_csctoss_repl".sl_log_1 loop
			-- ----
			-- Found a row ... log switch is still in progress.
			-- ----
			raise notice 'Slony-I: log switch to sl_log_2 still in progress - sl_log_1 not truncated';
			return -1;
		end loop;

		raise notice 'Slony-I: log switch to sl_log_2 complete - truncate sl_log_1';
		truncate "_csctoss_repl".sl_log_1;
		if exists (select * from "pg_catalog".pg_class c, "pg_catalog".pg_namespace n, "pg_catalog".pg_attribute a where c.relname = 'sl_log_1' and n.oid = c.relnamespace and a.attrelid = c.oid and a.attname = 'oid') then
	                execute 'alter table "_csctoss_repl".sl_log_1 set without oids;';
		end if;		
		perform "pg_catalog".setval('"_csctoss_repl".sl_log_status', 1);
		-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
		perform "_csctoss_repl".addPartialLogIndices();
		return 2;
	end if;
END;
$$;

COMMENT ON FUNCTION logswitch_finish() IS 'logswitch_finish()

Attempt to finalize a log table switch in progress';

CREATE OR REPLACE FUNCTION logswitch_start() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_current_status	int4;
BEGIN
	-- ----
	-- Grab the central configuration lock to prevent race conditions
	-- while changing the sl_log_status sequence value.
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get the current log status.
	-- ----
	select last_value into v_current_status from "_csctoss_repl".sl_log_status;

	-- ----
	-- status = 0: sl_log_1 active, sl_log_2 clean
	-- Initiate a switch to sl_log_2.
	-- ----
	if v_current_status = 0 then
		perform "pg_catalog".setval('"_csctoss_repl".sl_log_status', 3);
		perform "_csctoss_repl".registry_set_timestamp(
				'logswitch.laststart', now()::timestamp);
		raise notice 'Slony-I: Logswitch to sl_log_2 initiated';
		return 2;
	end if;

	-- ----
	-- status = 1: sl_log_2 active, sl_log_1 clean
	-- Initiate a switch to sl_log_1.
	-- ----
	if v_current_status = 1 then
		perform "pg_catalog".setval('"_csctoss_repl".sl_log_status', 2);
		perform "_csctoss_repl".registry_set_timestamp(
				'logswitch.laststart', now()::timestamp);
		raise notice 'Slony-I: Logswitch to sl_log_1 initiated';
		return 1;
	end if;

	raise exception 'Previous logswitch still in progress';
END;
$$;

COMMENT ON FUNCTION logswitch_start() IS 'logswitch_start()

Initiate a log table switch if none is in progress';

CREATE OR REPLACE FUNCTION logswitch_weekly() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	v_now			timestamp;
	v_now_dow		int4;
	v_auto_dow		int4;
	v_auto_time		time;
	v_auto_ts		timestamp;
	v_lastrun		timestamp;
	v_laststart		timestamp;
	v_days_since	int4;
BEGIN
	-- ----
	-- Check that today is the day to run at all
	-- ----
	v_auto_dow := "_csctoss_repl".registry_get_int4(
			'logswitch_weekly.dow', 0);
	v_now := "pg_catalog".now();
	v_now_dow := extract (DOW from v_now);
	if v_now_dow <> v_auto_dow then
		perform "_csctoss_repl".registry_set_timestamp(
				'logswitch_weekly.lastrun', v_now);
		return 0;
	end if;

	-- ----
	-- Check that the last run of this procedure was before and now is
	-- after the time we should automatically switch logs.
	-- ----
	v_auto_time := "_csctoss_repl".registry_get_text(
			'logswitch_weekly.time', '02:00');
	v_auto_ts := current_date + v_auto_time;
	v_lastrun := "_csctoss_repl".registry_get_timestamp(
			'logswitch_weekly.lastrun', 'epoch');
	if v_lastrun >= v_auto_ts or v_now < v_auto_ts then
		perform "_csctoss_repl".registry_set_timestamp(
				'logswitch_weekly.lastrun', v_now);
		return 0;
	end if;

	-- ----
	-- This is the moment configured in dow+time. Check that the
	-- last logswitch was done more than 2 days ago.
	-- ----
	v_laststart := "_csctoss_repl".registry_get_timestamp(
			'logswitch.laststart', 'epoch');
	v_days_since := extract (days from (v_now - v_laststart));
	if v_days_since < 2 then
		perform "_csctoss_repl".registry_set_timestamp(
				'logswitch_weekly.lastrun', v_now);
		return 0;
	end if;

	-- ----
	-- Fire off an automatic logswitch
	-- ----
	perform "_csctoss_repl".logswitch_start();
	perform "_csctoss_repl".registry_set_timestamp(
			'logswitch_weekly.lastrun', v_now);
	return 1;
END;
$$;

COMMENT ON FUNCTION logswitch_weekly() IS 'logswitch_weekly()

Ensure a logswitch is done at least weekly';

CREATE OR REPLACE FUNCTION logtrigger() RETURNS "trigger"
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_logTrigger';

COMMENT ON FUNCTION logtrigger() IS 'This is the trigger that is executed on the origin node that causes
updates to be recorded in sl_log_1/sl_log_2.';

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

CREATE OR REPLACE FUNCTION mergeset(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_add_id			alias for $2;
	v_origin			int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	-- ----
	-- Check that both sets exist and originate here
	-- ----
	if p_set_id = p_add_id then
		raise exception 'Slony-I: merged set ids cannot be identical';
	end if;
	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
	end if;

	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = p_add_id;
	if not found then
		raise exception 'Slony-I: set % not found', p_add_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				p_add_id;
	end if;

	-- ----
	-- Check that both sets are subscribed by the same set of nodes
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = p_set_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = p_add_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				p_set_id, p_add_id;
	end if;

	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = p_add_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = p_set_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				p_add_id, p_set_id;
	end if;

	-- ----
	-- Check that all ENABLE_SUBSCRIPTION events for the set are confirmed
	-- ----
	if exists (select true from "_csctoss_repl".sl_event
			where ev_type = 'ENABLE_SUBSCRIPTION'
			and ev_data1 = p_add_id::text
			and ev_seqno > (select max(con_seqno) from "_csctoss_repl".sl_confirm
					where con_origin = ev_origin
					and con_received::text = ev_data3))
	then
		raise exception 'Slony-I: set % has subscriptions in progress - cannot merge',
				p_add_id;
	end if;
			  

	-- ----
	-- Create a SYNC event, merge the sets, create a MERGE_SET event
	-- ----
	perform "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC', NULL);
	perform "_csctoss_repl".mergeSet_int(p_set_id, p_add_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'MERGE_SET', 
			p_set_id::text, p_add_id::text);
end;
$_$;

COMMENT ON FUNCTION mergeset(integer, integer) IS 'Generate MERGE_SET event to request that sets be merged together.

Both sets must exist, and originate on the same node.  They must be
subscribed by the same set of nodes.';

CREATE OR REPLACE FUNCTION mergeset_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_add_id			alias for $2;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	update "_csctoss_repl".sl_sequence
			set seq_set = p_set_id
			where seq_set = p_add_id;
	update "_csctoss_repl".sl_table
			set tab_set = p_set_id
			where tab_set = p_add_id;
	delete from "_csctoss_repl".sl_subscribe
			where sub_set = p_add_id;
	delete from "_csctoss_repl".sl_setsync
			where ssy_setid = p_add_id;
	delete from "_csctoss_repl".sl_set
			where set_id = p_add_id;

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION mergeset_int(integer, integer) IS 'mergeSet_int(set_id, add_id) - Perform MERGE_SET event, merging all objects from 
set add_id into set set_id.';

CREATE OR REPLACE FUNCTION moveset(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_new_origin		alias for $2;
	v_local_node_id		int4;
	v_set_row			record;
	v_sub_row			record;
	v_sync_seqno		int8;
	v_lv_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that the set is locked and that this locking
	-- happened long enough ago.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select * into v_set_row from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_set_row.set_origin <> v_local_node_id then
		raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
	end if;
	if v_set_row.set_locked isnull then
		raise exception 'Slony-I: set % is not locked', p_set_id;
	end if;
	if v_set_row.set_locked > "_csctoss_repl".getMinXid() then
		raise exception 'Slony-I: cannot move set % yet, transactions < % are still in progress',
				p_set_id, v_set_row.set_locked;
	end if;

	-- ----
	-- Unlock the set
	-- ----
	perform "_csctoss_repl".unlockSet(p_set_id);

	-- ----
	-- Check that the new_origin is an active subscriber of the set
	-- ----
	select * into v_sub_row from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id
			and sub_receiver = p_new_origin;
	if not found then
		raise exception 'Slony-I: set % is not subscribed by node %',
				p_set_id, p_new_origin;
	end if;
	if not v_sub_row.sub_active then
		raise exception 'Slony-I: subsctiption of node % for set % is inactive',
				p_new_origin, p_set_id;
	end if;

	-- ----
	-- Reconfigure everything
	-- ----
	perform "_csctoss_repl".moveSet_int(p_set_id, v_local_node_id,
			p_new_origin, 0);

	perform "_csctoss_repl".RebuildListenEntries();

	-- ----
	-- At this time we hold access exclusive locks for every table
	-- in the set. But we did move the set to the new origin, so the
	-- createEvent() we are doing now will not record the sequences.
	-- ----
	v_sync_seqno := "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC');
	insert into "_csctoss_repl".sl_seqlog 
			(seql_seqid, seql_origin, seql_ev_seqno, seql_last_value)
			select seq_id, v_local_node_id, v_sync_seqno, seq_last_value
			from "_csctoss_repl".sl_seqlastvalue
			where seq_set = p_set_id;
					
	-- ----
	-- Finally we generate the real event
	-- ----
	return "_csctoss_repl".createEvent('_csctoss_repl', 'MOVE_SET', 
			p_set_id::text, v_local_node_id::text, p_new_origin::text);
end;
$_$;

COMMENT ON FUNCTION moveset(integer, integer) IS 'moveSet(set_id, new_origin)

Generate MOVE_SET event to request that the origin for set set_id be moved to node new_origin';

CREATE OR REPLACE FUNCTION moveset_int(integer, integer, integer, bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_old_origin		alias for $2;
	p_new_origin		alias for $3;
	p_wait_seqno		alias for $4;
	v_local_node_id		int4;
	v_tab_row			record;
	v_sub_row			record;
	v_sub_node			int4;
	v_sub_last			int4;
	v_sub_next			int4;
	v_last_sync			int8;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get our local node ID
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');

	-- ----
	-- If we are the old or new origin of the set, we need to
	-- remove the log trigger from all tables first.
	-- ----
	if v_local_node_id = p_old_origin or v_local_node_id = p_new_origin then
		for v_tab_row in select tab_id from "_csctoss_repl".sl_table
				where tab_set = p_set_id
				order by tab_id
		loop
			perform "_csctoss_repl".alterTableRestore(v_tab_row.tab_id);
		end loop;
	end if;

	-- On the new origin, raise an event - ACCEPT_SET
	if v_local_node_id = p_new_origin then
		-- Create a SYNC event as well so that the ACCEPT_SET has
		-- the same snapshot as the last SYNC generated by the new
		-- origin. This snapshot will be used by other nodes to
		-- finalize the setsync status.
		perform "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC', NULL);
		perform "_csctoss_repl".createEvent('_csctoss_repl', 'ACCEPT_SET', 
			p_set_id::text, p_old_origin::text, 
			p_new_origin::text, p_wait_seqno::text);
	end if;

	-- ----
	-- Next we have to reverse the subscription path
	-- ----
	v_sub_last = p_new_origin;
	select sub_provider into v_sub_node
			from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id
			and sub_receiver = p_new_origin;
	if not found then
		raise exception 'Slony-I: subscription path broken in moveSet_int';
	end if;
	while v_sub_node <> p_old_origin loop
		-- ----
		-- Tracing node by node, the old receiver is now in
		-- v_sub_last and the old provider is in v_sub_node.
		-- ----

		-- ----
		-- Get the current provider of this node as next
		-- and change the provider to the previous one in
		-- the reverse chain.
		-- ----
		select sub_provider into v_sub_next
				from "_csctoss_repl".sl_subscribe
				where sub_set = p_set_id
					and sub_receiver = v_sub_node
				for update;
		if not found then
			raise exception 'Slony-I: subscription path broken in moveSet_int';
		end if;
		update "_csctoss_repl".sl_subscribe
				set sub_provider = v_sub_last
				where sub_set = p_set_id
					and sub_receiver = v_sub_node;

		v_sub_last = v_sub_node;
		v_sub_node = v_sub_next;
	end loop;

	-- ----
	-- This includes creating a subscription for the old origin
	-- ----
	insert into "_csctoss_repl".sl_subscribe
			(sub_set, sub_provider, sub_receiver,
			sub_forward, sub_active)
			values (p_set_id, v_sub_last, p_old_origin, true, true);
	if v_local_node_id = p_old_origin then
		select coalesce(max(ev_seqno), 0) into v_last_sync 
				from "_csctoss_repl".sl_event
				where ev_origin = p_new_origin
					and ev_type = 'SYNC';
		if v_last_sync > 0 then
			insert into "_csctoss_repl".sl_setsync
					(ssy_setid, ssy_origin, ssy_seqno,
					ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
					select p_set_id, p_new_origin, v_last_sync,
					ev_minxid, ev_maxxid, ev_xip, NULL
					from "_csctoss_repl".sl_event
					where ev_origin = p_new_origin
						and ev_seqno = v_last_sync;
		else
			insert into "_csctoss_repl".sl_setsync
					(ssy_setid, ssy_origin, ssy_seqno,
					ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
					values (p_set_id, p_new_origin, '0',
					'0', '0', '', NULL);
		end if;
	end if;

	-- ----
	-- Now change the ownership of the set.
	-- ----
	update "_csctoss_repl".sl_set
			set set_origin = p_new_origin
			where set_id = p_set_id;

	-- ----
	-- On the new origin, delete the obsolete setsync information
	-- and the subscription.
	-- ----
	if v_local_node_id = p_new_origin then
		delete from "_csctoss_repl".sl_setsync
				where ssy_setid = p_set_id;
	else
		if v_local_node_id <> p_old_origin then
			--
			-- On every other node, change the setsync so that it will
			-- pick up from the new origins last known sync.
			--
			delete from "_csctoss_repl".sl_setsync
					where ssy_setid = p_set_id;
			select coalesce(max(ev_seqno), 0) into v_last_sync
					from "_csctoss_repl".sl_event
					where ev_origin = p_new_origin
						and ev_type = 'SYNC';
			if v_last_sync > 0 then
				insert into "_csctoss_repl".sl_setsync
						(ssy_setid, ssy_origin, ssy_seqno,
						ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
						select p_set_id, p_new_origin, v_last_sync,
						ev_minxid, ev_maxxid, ev_xip, NULL
						from "_csctoss_repl".sl_event
						where ev_origin = p_new_origin
							and ev_seqno = v_last_sync;
			else
				insert into "_csctoss_repl".sl_setsync
						(ssy_setid, ssy_origin, ssy_seqno,
						ssy_minxid, ssy_maxxid, ssy_xip, ssy_action_list)
						values (p_set_id, p_new_origin, '0',
						'0', '0', '', NULL);
			end if;
		end if;
	end if;
	delete from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id
			and sub_receiver = p_new_origin;

	-- Regenerate sl_listen since we revised the subscriptions
	perform "_csctoss_repl".RebuildListenEntries();

	-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
	perform "_csctoss_repl".addPartialLogIndices();

	-- ----
	-- If we are the new or old origin, we have to
	-- put all the tables into altered state again.
	-- ----
	if v_local_node_id = p_old_origin or v_local_node_id = p_new_origin then
		for v_tab_row in select tab_id from "_csctoss_repl".sl_table
				where tab_set = p_set_id
				order by tab_id
		loop
			perform "_csctoss_repl".alterTableForReplication(v_tab_row.tab_id);
		end loop;
	end if;

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION moveset_int(integer, integer, integer, bigint) IS 'moveSet(set_id, old_origin, new_origin, wait_seqno)

Process MOVE_SET event to request that the origin for set set_id be
moved from old_origin to node new_origin';

CREATE OR REPLACE FUNCTION pre74() RETURNS integer
    LANGUAGE sql
    AS $$select 0$$;

COMMENT ON FUNCTION pre74() IS 'Returns 1/0 based on whether or not the DB is running a
version earlier than 7.4';

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

CREATE OR REPLACE FUNCTION reachablefromnode(integer, integer[]) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$
declare
	v_node alias for $1 ;
	v_blacklist alias for $2 ;
	v_ignore int4[] ;
	v_reachable_edge_last int4[] ;
	v_reachable_edge_new int4[] default '{}' ;
	v_server record ;
begin
	v_reachable_edge_last := array[v_node] ;
	v_ignore := v_blacklist || array[v_node] ;
	return next v_node ;
	while v_reachable_edge_last != '{}' loop
		v_reachable_edge_new := '{}' ;
		for v_server in select pa_server as no_id
			from "_csctoss_repl".sl_path
			where pa_client = ANY(v_reachable_edge_last) and pa_server != ALL(v_ignore)
		loop
			if v_server.no_id != ALL(v_ignore) then
				v_ignore := v_ignore || array[v_server.no_id] ;
				v_reachable_edge_new := v_reachable_edge_new || array[v_server.no_id] ;
				return next v_server.no_id ;
			end if ;
		end loop ;
		v_reachable_edge_last := v_reachable_edge_new ;
	end loop ;
	return ;
end ;
$_$;

COMMENT ON FUNCTION reachablefromnode(integer, integer[]) IS 'ReachableFromNode(receiver, blacklist)

Find all nodes that <receiver> can receive events from without
using nodes in <blacklist> as a relay.';

CREATE OR REPLACE FUNCTION rebuildlistenentries() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	v_row	record;
	skip    boolean;
begin
	-- First remove the entire configuration
	delete from "_csctoss_repl".sl_listen;

	-- Second populate the sl_listen configuration with a full
	-- network of all possible paths.
	insert into "_csctoss_repl".sl_listen
				(li_origin, li_provider, li_receiver)
			select pa_server, pa_server, pa_client from "_csctoss_repl".sl_path;
	while true loop
		insert into "_csctoss_repl".sl_listen
					(li_origin, li_provider, li_receiver)
			select distinct li_origin, pa_server, pa_client
				from "_csctoss_repl".sl_listen, "_csctoss_repl".sl_path
				where li_receiver = pa_server
				  and li_origin <> pa_client
			except
			select li_origin, li_provider, li_receiver
				from "_csctoss_repl".sl_listen;

		if not found then
			exit;
		end if;
	end loop;

	-- We now replace specific event-origin,receiver combinations
	-- with a configuration that tries to avoid events arriving at
	-- a node before the data provider actually has the data ready.

	-- Loop over every possible pair of receiver and event origin
	for v_row in select N1.no_id as receiver, N2.no_id as origin
			from "_csctoss_repl".sl_node as N1, "_csctoss_repl".sl_node as N2
			where N1.no_id <> N2.no_id
	loop
		skip := 'f';
		-- 1st choice:
		-- If we use the event origin as a data provider for any
		-- set that originates on that very node, we are a direct
		-- subscriber to that origin and listen there only.
		if exists (select true from "_csctoss_repl".sl_set, "_csctoss_repl".sl_subscribe
				where set_origin = v_row.origin
				  and sub_set = set_id
				  and sub_provider = v_row.origin
				  and sub_receiver = v_row.receiver
				  and sub_active)
		then
			delete from "_csctoss_repl".sl_listen
				where li_origin = v_row.origin
				  and li_receiver = v_row.receiver;
			insert into "_csctoss_repl".sl_listen (li_origin, li_provider, li_receiver)
				values (v_row.origin, v_row.origin, v_row.receiver);
			skip := 't';
		end if;

		if skip then
			skip := 'f';
		else
		-- 2nd choice:
		-- If we are subscribed to any set originating on this
		-- event origin, we want to listen on all data providers
		-- we use for this origin. We are a cascaded subscriber
		-- for sets from this node.
			if exists (select true from "_csctoss_repl".sl_set, "_csctoss_repl".sl_subscribe
						where set_origin = v_row.origin
						  and sub_set = set_id
						  and sub_receiver = v_row.receiver
						  and sub_active)
			then
				delete from "_csctoss_repl".sl_listen
					where li_origin = v_row.origin
					  and li_receiver = v_row.receiver;
				insert into "_csctoss_repl".sl_listen (li_origin, li_provider, li_receiver)
					select distinct set_origin, sub_provider, v_row.receiver
						from "_csctoss_repl".sl_set, "_csctoss_repl".sl_subscribe
						where set_origin = v_row.origin
						  and sub_set = set_id
						  and sub_receiver = v_row.receiver
						  and sub_active;
			end if;
		end if;

	end loop ;

	return null ;
end ;
$$;

COMMENT ON FUNCTION rebuildlistenentries() IS 'RebuildListenEntries()

Invoked by various subscription and path modifying functions, this
rewrites the sl_listen entries, adding in all the ones required to
allow communications between nodes in the Slony-I cluster.';

CREATE OR REPLACE FUNCTION registernodeconnection(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_nodeid	alias for $1;
begin
	insert into "_csctoss_repl".sl_nodelock
		(nl_nodeid, nl_backendpid)
		values
		(p_nodeid, pg_backend_pid());

	return 0;
end;
$_$;

COMMENT ON FUNCTION registernodeconnection(integer) IS 'Register (uniquely) the node connection so that only one slon can service the node';

CREATE OR REPLACE FUNCTION registry_get_int4(text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_default	alias for $2;
	v_value		int4;
BEGIN
	select reg_int4 into v_value from "_csctoss_repl".sl_registry
			where reg_key = p_key;
	if not found then 
		v_value = p_default;
		if p_default notnull then
			perform "_csctoss_repl".registry_set_int4(p_key, p_default);
		end if;
	else
		if v_value is null then
			raise exception 'Slony-I: registry key % is not an int4 value',
					p_key;
		end if;
	end if;
	return v_value;
END;
$_$;

COMMENT ON FUNCTION registry_get_int4(text, integer) IS 'registry_get_int4(key, value)

Get a registry value. If not present, set and return the default.';

CREATE OR REPLACE FUNCTION registry_get_text(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_default	alias for $2;
	v_value		text;
BEGIN
	select reg_text into v_value from "_csctoss_repl".sl_registry
			where reg_key = p_key;
	if not found then 
		v_value = p_default;
		if p_default notnull then
			perform "_csctoss_repl".registry_set_text(p_key, p_default);
		end if;
	else
		if v_value is null then
			raise exception 'Slony-I: registry key % is not a text value',
					p_key;
		end if;
	end if;
	return v_value;
END;
$_$;

COMMENT ON FUNCTION registry_get_text(text, text) IS 'registry_get_text(key, value)

Get a registry value. If not present, set and return the default.';

CREATE OR REPLACE FUNCTION registry_get_timestamp(text, timestamp without time zone) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_default	alias for $2;
	v_value		timestamp;
BEGIN
	select reg_timestamp into v_value from "_csctoss_repl".sl_registry
			where reg_key = p_key;
	if not found then 
		v_value = p_default;
		if p_default notnull then
			perform "_csctoss_repl".registry_set_timestamp(p_key, p_default);
		end if;
	else
		if v_value is null then
			raise exception 'Slony-I: registry key % is not an timestamp value',
					p_key;
		end if;
	end if;
	return v_value;
END;
$_$;

COMMENT ON FUNCTION registry_get_timestamp(text, timestamp without time zone) IS 'registry_get_timestamp(key, value)

Get a registry value. If not present, set and return the default.';

CREATE OR REPLACE FUNCTION registry_set_int4(text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_value		alias for $2;
BEGIN
	if p_value is null then
		delete from "_csctoss_repl".sl_registry
				where reg_key = p_key;
	else
		lock table "_csctoss_repl".sl_registry;
		update "_csctoss_repl".sl_registry
				set reg_int4 = p_value
				where reg_key = p_key;
		if not found then
			insert into "_csctoss_repl".sl_registry (reg_key, reg_int4)
					values (p_key, p_value);
		end if;
	end if;
	return p_value;
END;
$_$;

COMMENT ON FUNCTION registry_set_int4(text, integer) IS 'registry_set_int4(key, value)

Set or delete a registry value';

CREATE OR REPLACE FUNCTION registry_set_text(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_value		alias for $2;
BEGIN
	if p_value is null then
		delete from "_csctoss_repl".sl_registry
				where reg_key = p_key;
	else
		lock table "_csctoss_repl".sl_registry;
		update "_csctoss_repl".sl_registry
				set reg_text = p_value
				where reg_key = p_key;
		if not found then
			insert into "_csctoss_repl".sl_registry (reg_key, reg_text)
					values (p_key, p_value);
		end if;
	end if;
	return p_value;
END;
$_$;

COMMENT ON FUNCTION registry_set_text(text, text) IS 'registry_set_text(key, value)

Set or delete a registry value';

CREATE OR REPLACE FUNCTION registry_set_timestamp(text, timestamp without time zone) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
	p_key		alias for $1;
	p_value		alias for $2;
BEGIN
	if p_value is null then
		delete from "_csctoss_repl".sl_registry
				where reg_key = p_key;
	else
		lock table "_csctoss_repl".sl_registry;
		update "_csctoss_repl".sl_registry
				set reg_timestamp = p_value
				where reg_key = p_key;
		if not found then
			insert into "_csctoss_repl".sl_registry (reg_key, reg_timestamp)
					values (p_key, p_value);
		end if;
	end if;
	return p_value;
END;
$_$;

COMMENT ON FUNCTION registry_set_timestamp(text, timestamp without time zone) IS 'registry_set_timestamp(key, value)

Set or delete a registry value';

CREATE OR REPLACE FUNCTION replicate_partition(integer, text, text, text, text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
  p_tab_id alias for $1;
  p_nspname alias for $2;
  p_tabname alias for $3;
  p_idxname alias for $4;
  p_comment alias for $5;

  prec record;
  prec2 record;
  v_set_id int4;

begin
-- Look up the parent table; fail if it does not exist
   select c1.oid into prec from pg_catalog.pg_class c1, pg_catalog.pg_class c2, pg_catalog.pg_inherits i, pg_catalog.pg_namespace n where c1.oid = i.inhparent  and c2.oid = i.inhrelid and n.oid = c2.relnamespace and n.nspname = p_nspname and c2.relname = p_tabname;
   if not found then
	raise exception 'replicate_partition: No parent table found for %.%!', p_nspname, p_tabname;
   end if;

-- The parent table tells us what replication set to use
   select tab_set into prec2 from "_csctoss_repl".sl_table where tab_reloid = prec.oid;
   if not found then
	raise exception 'replicate_partition: Parent table % for new partition %.% is not replicated!', prec.oid, p_nspname, p_tabname;
   end if;

   v_set_id := prec2.tab_set;

-- Now, we have all the parameters necessary to run add_empty_table_to_replication...
   return "_csctoss_repl".add_empty_table_to_replication(v_set_id, p_tab_id, p_nspname, p_tabname, p_idxname, p_comment);
end
$_$;

COMMENT ON FUNCTION replicate_partition(integer, text, text, text, text) IS 'Add a partition table to replication.
tab_idxname is optional - if NULL, then we use the primary key.
This function looks up replication configuration via the parent table.';

CREATE OR REPLACE FUNCTION sequencelastvalue(text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_seqname	alias for $1;
	v_seq_row	record;
begin
	for v_seq_row in execute 'select last_value from ' || "_csctoss_repl".slon_quote_input(p_seqname)
	loop
		return v_seq_row.last_value;
	end loop;

	-- not reached
end;
$_$;

COMMENT ON FUNCTION sequencelastvalue(text) IS 'sequenceLastValue(p_seqname)

Utility function used in sl_seqlastvalue view to compactly get the
last value from the requested sequence.';

CREATE OR REPLACE FUNCTION sequencesetvalue(integer, integer, bigint, bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_seq_id			alias for $1;
	p_seq_origin		alias for $2;
	p_ev_seqno			alias for $3;
	p_last_value		alias for $4;
	v_fqname			text;
begin
	-- ----
	-- Get the sequences fully qualified name
	-- ----
	select "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) into v_fqname
		from "_csctoss_repl".sl_sequence SQ,
			"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
		where SQ.seq_id = p_seq_id
			and SQ.seq_reloid = PGC.oid
			and PGC.relnamespace = PGN.oid;
	if not found then
		raise exception 'Slony-I: sequenceSetValue(): sequence % not found', p_seq_id;
	end if;

	-- ----
	-- Update it to the new value
	-- ----
	execute 'select setval(''' || v_fqname ||
			''', ''' || p_last_value::text || ''')';

	insert into "_csctoss_repl".sl_seqlog
			(seql_seqid, seql_origin, seql_ev_seqno, seql_last_value)
			values (p_seq_id, p_seq_origin, p_ev_seqno, p_last_value);

	return p_seq_id;
end;
$_$;

COMMENT ON FUNCTION sequencesetvalue(integer, integer, bigint, bigint) IS 'sequenceSetValue (seq_id, seq_origin, ev_seqno, last_value)
Set sequence seq_id to have new value last_value.
';

CREATE OR REPLACE FUNCTION setaddsequence(integer, integer, text, text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_seq_id			alias for $2;
	p_fqname			alias for $3;
	p_seq_comment		alias for $4;
	v_set_origin		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that we are the origin of the set
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: setAddSequence(): set % not found', p_set_id;
	end if;
	if v_set_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: setAddSequence(): set % has remote origin - submit to origin node', p_set_id;
	end if;

	if exists (select true from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id)
	then
		raise exception 'Slony-I: cannot add sequence to currently subscribed set %',
				p_set_id;
	end if;

	-- ----
	-- Add the sequence to the set and generate the SET_ADD_SEQUENCE event
	-- ----
	perform "_csctoss_repl".setAddSequence_int(p_set_id, p_seq_id, p_fqname,
			p_seq_comment);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_ADD_SEQUENCE',
						p_set_id::text, p_seq_id::text, 
						p_fqname::text, p_seq_comment::text);
end;
$_$;

COMMENT ON FUNCTION setaddsequence(integer, integer, text, text) IS 'setAddSequence (set_id, seq_id, seq_fqname, seq_comment)

On the origin node for set set_id, add sequence seq_fqname to the
replication set, and raise SET_ADD_SEQUENCE to cause this to replicate
to subscriber nodes.';

CREATE OR REPLACE FUNCTION setaddsequence_int(integer, integer, text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_seq_id			alias for $2;
	p_fqname			alias for $3;
	p_seq_comment		alias for $4;
	v_local_node_id		int4;
	v_set_origin		int4;
	v_sub_provider		int4;
	v_relkind			char;
	v_seq_reloid		oid;
	v_seq_relname		name;
	v_seq_nspname		name;
	v_sync_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- For sets with a remote origin, check that we are subscribed 
	-- to that set. Otherwise we ignore the sequence because it might 
	-- not even exist in our database.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: setAddSequence_int(): set % not found',
				p_set_id;
	end if;
	if v_set_origin != v_local_node_id then
		select sub_provider into v_sub_provider
				from "_csctoss_repl".sl_subscribe
				where sub_set = p_set_id
				and sub_receiver = "_csctoss_repl".getLocalNodeId('_csctoss_repl');
		if not found then
			return 0;
		end if;
	end if;
	
	-- ----
	-- Get the sequences OID and check that it is a sequence
	-- ----
	select PGC.oid, PGC.relkind, PGC.relname, PGN.nspname 
		into v_seq_reloid, v_relkind, v_seq_relname, v_seq_nspname
			from "pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
			where PGC.relnamespace = PGN.oid
			and "_csctoss_repl".slon_quote_input(p_fqname) = "_csctoss_repl".slon_quote_brute(PGN.nspname) ||
					'.' || "_csctoss_repl".slon_quote_brute(PGC.relname);
	if not found then
		raise exception 'Slony-I: setAddSequence_int(): sequence % not found', 
				p_fqname;
	end if;
	if v_relkind != 'S' then
		raise exception 'Slony-I: setAddSequence_int(): % is not a sequence',
				p_fqname;
	end if;

        select 1 into v_sync_row from "_csctoss_repl".sl_sequence where seq_id = p_seq_id;
	if not found then
               v_relkind := 'o';   -- all is OK
        else
                raise exception 'Slony-I: setAddSequence_int(): sequence ID % has already been assigned', p_seq_id;
        end if;

	-- ----
	-- Add the sequence to sl_sequence
	-- ----
	insert into "_csctoss_repl".sl_sequence
		(seq_id, seq_reloid, seq_relname, seq_nspname, seq_set, seq_comment) 
		values
		(p_seq_id, v_seq_reloid, v_seq_relname, v_seq_nspname,  p_set_id, p_seq_comment);

	-- ----
	-- On the set origin, fake a sl_seqlog row for the last sync event
	-- ----
	if v_set_origin = v_local_node_id then
		for v_sync_row in select coalesce (max(ev_seqno), 0) as ev_seqno
				from "_csctoss_repl".sl_event
				where ev_origin = v_local_node_id
					and ev_type = 'SYNC'
		loop
			insert into "_csctoss_repl".sl_seqlog
					(seql_seqid, seql_origin, seql_ev_seqno, 
					seql_last_value) values
					(p_seq_id, v_local_node_id, v_sync_row.ev_seqno,
					"_csctoss_repl".sequenceLastValue(p_fqname));
		end loop;
	end if;

	return p_seq_id;
end;
$_$;

COMMENT ON FUNCTION setaddsequence_int(integer, integer, text, text) IS 'setAddSequence_int (set_id, seq_id, seq_fqname, seq_comment)

This processes the SET_ADD_SEQUENCE event.  On remote nodes that
subscribe to set_id, add the sequence to the replication set.';

CREATE OR REPLACE FUNCTION setaddtable(integer, integer, text, name, text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_tab_id			alias for $2;
	p_fqname			alias for $3;
	p_tab_idxname		alias for $4;
	p_tab_comment		alias for $5;
	v_set_origin		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that we are the origin of the set
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: setAddTable(): set % not found', p_set_id;
	end if;
	if v_set_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: setAddTable(): set % has remote origin', p_set_id;
	end if;

	if exists (select true from "_csctoss_repl".sl_subscribe
			where sub_set = p_set_id)
	then
		raise exception 'Slony-I: cannot add table to currently subscribed set %',
				p_set_id;
	end if;

	-- ----
	-- Add the table to the set and generate the SET_ADD_TABLE event
	-- ----
	perform "_csctoss_repl".setAddTable_int(p_set_id, p_tab_id, p_fqname,
			p_tab_idxname, p_tab_comment);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_ADD_TABLE',
			p_set_id::text, p_tab_id::text, p_fqname::text,
			p_tab_idxname::text, p_tab_comment::text);
end;
$_$;

COMMENT ON FUNCTION setaddtable(integer, integer, text, name, text) IS 'setAddTable (set_id, tab_id, tab_fqname, tab_idxname, tab_comment)

Add table tab_fqname to replication set on origin node, and generate
SET_ADD_TABLE event to allow this to propagate to other nodes.

Note that the table id, tab_id, must be unique ACROSS ALL SETS.';

CREATE OR REPLACE FUNCTION setaddtable_int(integer, integer, text, name, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare

	p_set_id		alias for $1;
	p_tab_id		alias for $2;
	p_fqname		alias for $3;
	p_tab_idxname		alias for $4;
	p_tab_comment		alias for $5;
	v_tab_relname		name;
	v_tab_nspname		name;
	v_local_node_id		int4;
	v_set_origin		int4;
	v_sub_provider		int4;
	v_relkind		char;
	v_tab_reloid		oid;
	v_pkcand_nn		boolean;
	v_prec			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- For sets with a remote origin, check that we are subscribed 
	-- to that set. Otherwise we ignore the table because it might 
	-- not even exist in our database.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_set_id;
	if not found then
		raise exception 'Slony-I: setAddTable_int(): set % not found',
				p_set_id;
	end if;
	if v_set_origin != v_local_node_id then
		select sub_provider into v_sub_provider
				from "_csctoss_repl".sl_subscribe
				where sub_set = p_set_id
				and sub_receiver = "_csctoss_repl".getLocalNodeId('_csctoss_repl');
		if not found then
			return 0;
		end if;
	end if;
	
	-- ----
	-- Get the tables OID and check that it is a real table
	-- ----
	select PGC.oid, PGC.relkind, PGC.relname, PGN.nspname into v_tab_reloid, v_relkind, v_tab_relname, v_tab_nspname
			from "pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
			where PGC.relnamespace = PGN.oid
			and "_csctoss_repl".slon_quote_input(p_fqname) = "_csctoss_repl".slon_quote_brute(PGN.nspname) ||
					'.' || "_csctoss_repl".slon_quote_brute(PGC.relname);
	if not found then
		raise exception 'Slony-I: setAddTable_int(): table % not found', 
				p_fqname;
	end if;
	if v_relkind != 'r' then
		raise exception 'Slony-I: setAddTable_int(): % is not a regular table',
				p_fqname;
	end if;

	if not exists (select indexrelid
			from "pg_catalog".pg_index PGX, "pg_catalog".pg_class PGC
			where PGX.indrelid = v_tab_reloid
				and PGX.indexrelid = PGC.oid
				and PGC.relname = p_tab_idxname)
	then
		raise exception 'Slony-I: setAddTable_int(): table % has no index %',
				p_fqname, p_tab_idxname;
	end if;

	-- ----
	-- Verify that the columns in the PK (or candidate) are not NULLABLE
	-- ----

	v_pkcand_nn := 'f';
	for v_prec in select attname from "pg_catalog".pg_attribute where attrelid = 
                        (select oid from "pg_catalog".pg_class where oid = v_tab_reloid) 
                    and attname in (select attname from "pg_catalog".pg_attribute where 
                                    attrelid = (select oid from "pg_catalog".pg_class PGC, 
                                    "pg_catalog".pg_index PGX where 
                                    PGC.relname = p_tab_idxname and PGX.indexrelid=PGC.oid and
                                    PGX.indrelid = v_tab_reloid)) and attnotnull <> 't'
	loop
		raise notice 'Slony-I: setAddTable_int: table % PK column % nullable', p_fqname, v_prec.attname;
		v_pkcand_nn := 't';
	end loop;
	if v_pkcand_nn then
		raise exception 'Slony-I: setAddTable_int: table % not replicable!', p_fqname;
	end if;

	select * into v_prec from "_csctoss_repl".sl_table where tab_id = p_tab_id;
	if not found then
		v_pkcand_nn := 't';  -- No-op -- All is well
	else
		raise exception 'Slony-I: setAddTable_int: table id % has already been assigned!', p_tab_id;
	end if;

	-- ----
	-- Add the table to sl_table and create the trigger on it.
	-- ----
	insert into "_csctoss_repl".sl_table
			(tab_id, tab_reloid, tab_relname, tab_nspname, 
			tab_set, tab_idxname, tab_altered, tab_comment) 
			values
			(p_tab_id, v_tab_reloid, v_tab_relname, v_tab_nspname,
			p_set_id, p_tab_idxname, false, p_tab_comment);
	perform "_csctoss_repl".alterTableForReplication(p_tab_id);

	return p_tab_id;
end;
$_$;

COMMENT ON FUNCTION setaddtable_int(integer, integer, text, name, text) IS 'setAddTable_int (set_id, tab_id, tab_fqname, tab_idxname, tab_comment)

This function processes the SET_ADD_TABLE event on remote nodes,
adding a table to replication if the remote node is subscribing to its
replication set.';

CREATE OR REPLACE FUNCTION setdropsequence(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_seq_id		alias for $1;
	v_set_id		int4;
	v_set_origin		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Determine set id for this sequence
	-- ----
	select seq_set into v_set_id from "_csctoss_repl".sl_sequence where seq_id = p_seq_id;

	-- ----
	-- Ensure sequence exists
	-- ----
	if not found then
		raise exception 'Slony-I: setDropSequence_int(): sequence % not found',
			p_seq_id;
	end if;

	-- ----
	-- Check that we are the origin of the set
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = v_set_id;
	if not found then
		raise exception 'Slony-I: setDropSequence(): set % not found', v_set_id;
	end if;
	if v_set_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: setDropSequence(): set % has origin at another node - submit this to that node', v_set_id;
	end if;

	-- ----
	-- Add the sequence to the set and generate the SET_ADD_SEQUENCE event
	-- ----
	perform "_csctoss_repl".setDropSequence_int(p_seq_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_DROP_SEQUENCE',
					p_seq_id::text);
end;
$_$;

COMMENT ON FUNCTION setdropsequence(integer) IS 'setDropSequence (seq_id)

On the origin node for the set, drop sequence seq_id from replication
set, and raise SET_DROP_SEQUENCE to cause this to replicate to
subscriber nodes.';

CREATE OR REPLACE FUNCTION setdropsequence_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_seq_id		alias for $1;
	v_set_id		int4;
	v_local_node_id		int4;
	v_set_origin		int4;
	v_sub_provider		int4;
	v_relkind			char;
	v_sync_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Determine set id for this sequence
	-- ----
	select seq_set into v_set_id from "_csctoss_repl".sl_sequence where seq_id = p_seq_id;

	-- ----
	-- Ensure sequence exists
	-- ----
	if not found then
		return 0;
	end if;

	-- ----
	-- For sets with a remote origin, check that we are subscribed 
	-- to that set. Otherwise we ignore the sequence because it might 
	-- not even exist in our database.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = v_set_id;
	if not found then
		raise exception 'Slony-I: setDropSequence_int(): set % not found',
				v_set_id;
	end if;
	if v_set_origin != v_local_node_id then
		select sub_provider into v_sub_provider
				from "_csctoss_repl".sl_subscribe
				where sub_set = v_set_id
				and sub_receiver = "_csctoss_repl".getLocalNodeId('_csctoss_repl');
		if not found then
			return 0;
		end if;
	end if;

	-- ----
	-- drop the sequence from sl_sequence, sl_seqlog
	-- ----
	delete from "_csctoss_repl".sl_seqlog where seql_seqid = p_seq_id;
	delete from "_csctoss_repl".sl_sequence where seq_id = p_seq_id;

	return p_seq_id;
end;
$_$;

COMMENT ON FUNCTION setdropsequence_int(integer) IS 'setDropSequence_int (seq_id)

This processes the SET_DROP_SEQUENCE event.  On remote nodes that
subscribe to the set containing sequence seq_id, drop the sequence
from the replication set.';

CREATE OR REPLACE FUNCTION setdroptable(integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id		alias for $1;
	v_set_id		int4;
	v_set_origin		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

        -- ----
	-- Determine the set_id
        -- ----
	select tab_set into v_set_id from "_csctoss_repl".sl_table where tab_id = p_tab_id;

	-- ----
	-- Ensure table exists
	-- ----
	if not found then
		raise exception 'Slony-I: setDropTable_int(): table % not found',
			p_tab_id;
	end if;

	-- ----
	-- Check that we are the origin of the set
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = v_set_id;
	if not found then
		raise exception 'Slony-I: setDropTable(): set % not found', v_set_id;
	end if;
	if v_set_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: setDropTable(): set % has remote origin', v_set_id;
	end if;

	-- ----
	-- Drop the table from the set and generate the SET_ADD_TABLE event
	-- ----
	perform "_csctoss_repl".setDropTable_int(p_tab_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_DROP_TABLE', 
				p_tab_id::text);
end;
$_$;

COMMENT ON FUNCTION setdroptable(integer) IS 'setDropTable (tab_id)

Drop table tab_id from set on origin node, and generate SET_DROP_TABLE
event to allow this to propagate to other nodes.';

CREATE OR REPLACE FUNCTION setdroptable_int(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id		alias for $1;
	v_set_id		int4;
	v_local_node_id		int4;
	v_set_origin		int4;
	v_sub_provider		int4;
	v_tab_reloid		oid;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

        -- ----
	-- Determine the set_id
        -- ----
	select tab_set into v_set_id from "_csctoss_repl".sl_table where tab_id = p_tab_id;

	-- ----
	-- Ensure table exists
	-- ----
	if not found then
		return 0;
	end if;

	-- ----
	-- For sets with a remote origin, check that we are subscribed 
	-- to that set. Otherwise we ignore the table because it might 
	-- not even exist in our database.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = v_set_id;
	if not found then
		raise exception 'Slony-I: setDropTable_int(): set % not found',
				v_set_id;
	end if;
	if v_set_origin != v_local_node_id then
		select sub_provider into v_sub_provider
				from "_csctoss_repl".sl_subscribe
				where sub_set = v_set_id
				and sub_receiver = "_csctoss_repl".getLocalNodeId('_csctoss_repl');
		if not found then
			return 0;
		end if;
	end if;
	
	-- ----
	-- Drop the table from sl_table and drop trigger from it.
	-- ----
	perform "_csctoss_repl".alterTableRestore(p_tab_id);
	perform "_csctoss_repl".tableDropKey(p_tab_id);
	delete from "_csctoss_repl".sl_table where tab_id = p_tab_id;
	return p_tab_id;
end;
$_$;

COMMENT ON FUNCTION setdroptable_int(integer) IS 'setDropTable_int (tab_id)

This function processes the SET_DROP_TABLE event on remote nodes,
dropping a table from replication if the remote node is subscribing to
its replication set.';

CREATE OR REPLACE FUNCTION setmovesequence(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_seq_id			alias for $1;
	p_new_set_id		alias for $2;
	v_old_set_id		int4;
	v_origin			int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get the sequences current set
	-- ----
	select seq_set into v_old_set_id from "_csctoss_repl".sl_sequence
			where seq_id = p_seq_id;
	if not found then
		raise exception 'Slony-I: setMoveSequence(): sequence %d not found', p_seq_id;
	end if;
	
	-- ----
	-- Check that both sets exist and originate here
	-- ----
	if p_new_set_id = v_old_set_id then
		raise exception 'Slony-I: setMoveSequence(): set ids cannot be identical';
	end if;
	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = p_new_set_id;
	if not found then
		raise exception 'Slony-I: setMoveSequence(): set % not found', p_new_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: setMoveSequence(): set % does not originate on local node',
				p_new_set_id;
	end if;

	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = v_old_set_id;
	if not found then
		raise exception 'Slony-I: set % not found', v_old_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				v_old_set_id;
	end if;

	-- ----
	-- Check that both sets are subscribed by the same set of nodes
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = p_new_set_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = v_old_set_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				p_new_set_id, v_old_set_id;
	end if;

	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = v_old_set_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = p_new_set_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				v_old_set_id, p_new_set_id;
	end if;

	-- ----
	-- Change the set the sequence belongs to
	-- ----
	perform "_csctoss_repl".setMoveSequence_int(p_seq_id, p_new_set_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_MOVE_SEQUENCE', 
			p_seq_id::text, p_new_set_id::text);
end;
$_$;

COMMENT ON FUNCTION setmovesequence(integer, integer) IS 'setMoveSequence(p_seq_id, p_new_set_id) - This generates the
SET_MOVE_SEQUENCE event, after validation, notably that both sets
exist, are distinct, and have exactly the same subscription lists';

CREATE OR REPLACE FUNCTION setmovesequence_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_seq_id			alias for $1;
	p_new_set_id		alias for $2;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	-- ----
	-- Move the sequence to the new set
	-- ----
	update "_csctoss_repl".sl_sequence
			set seq_set = p_new_set_id
			where seq_id = p_seq_id;

	return p_seq_id;
end;
$_$;

COMMENT ON FUNCTION setmovesequence_int(integer, integer) IS 'setMoveSequence_int(p_seq_id, p_new_set_id) - processes the
SET_MOVE_SEQUENCE event, moving a sequence to another replication
set.';

CREATE OR REPLACE FUNCTION setmovetable(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id			alias for $1;
	p_new_set_id		alias for $2;
	v_old_set_id		int4;
	v_origin			int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Get the tables current set
	-- ----
	select tab_set into v_old_set_id from "_csctoss_repl".sl_table
			where tab_id = p_tab_id;
	if not found then
		raise exception 'Slony-I: table %d not found', p_tab_id;
	end if;
	
	-- ----
	-- Check that both sets exist and originate here
	-- ----
	if p_new_set_id = v_old_set_id then
		raise exception 'Slony-I: set ids cannot be identical';
	end if;
	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = p_new_set_id;
	if not found then
		raise exception 'Slony-I: set % not found', p_new_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				p_new_set_id;
	end if;

	select set_origin into v_origin from "_csctoss_repl".sl_set
			where set_id = v_old_set_id;
	if not found then
		raise exception 'Slony-I: set % not found', v_old_set_id;
	end if;
	if v_origin != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: set % does not originate on local node',
				v_old_set_id;
	end if;

	-- ----
	-- Check that both sets are subscribed by the same set of nodes
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = p_new_set_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = v_old_set_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				p_new_set_id, v_old_set_id;
	end if;

	if exists (select true from "_csctoss_repl".sl_subscribe SUB1
				where SUB1.sub_set = v_old_set_id
				and SUB1.sub_receiver not in (select SUB2.sub_receiver
						from "_csctoss_repl".sl_subscribe SUB2
						where SUB2.sub_set = p_new_set_id))
	then
		raise exception 'Slony-I: subscriber lists of set % and % are different',
				v_old_set_id, p_new_set_id;
	end if;

	-- ----
	-- Change the set the table belongs to
	-- ----
	perform "_csctoss_repl".createEvent('_csctoss_repl', 'SYNC', NULL);
	perform "_csctoss_repl".setMoveTable_int(p_tab_id, p_new_set_id);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'SET_MOVE_TABLE', 
			p_tab_id::text, p_new_set_id::text);
end;
$_$;

COMMENT ON FUNCTION setmovetable(integer, integer) IS 'This processes the SET_MOVE_TABLE event.  The table is moved 
to the destination set.';

CREATE OR REPLACE FUNCTION setmovetable_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id			alias for $1;
	p_new_set_id		alias for $2;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;
	
	-- ----
	-- Move the table to the new set
	-- ----
	update "_csctoss_repl".sl_table
			set tab_set = p_new_set_id
			where tab_id = p_tab_id;

	return p_tab_id;
end;
$_$;

CREATE OR REPLACE FUNCTION setsessionrole(name, text) RETURNS text
    LANGUAGE c SECURITY DEFINER
    AS '$libdir/slony1_funcs', '_Slony_I_setSessionRole';

COMMENT ON FUNCTION setsessionrole(name, text) IS 'setSessionRole(username, role) - set role for session.

role can be "normal" or "slon"; setting the latter is necessary, on
subscriber nodes, in order to override the denyaccess() trigger
attached to subscribing tables.';

CREATE OR REPLACE FUNCTION slon_quote_brute(text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
declare	
    p_tab_fqname alias for $1;
    v_fqname text default '';
begin
    v_fqname := '"' || replace(p_tab_fqname,'"','""') || '"';
    return v_fqname;
end;
$_$;

COMMENT ON FUNCTION slon_quote_brute(text) IS 'Brutally quote the given text';

CREATE OR REPLACE FUNCTION slon_quote_input(text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
  declare
     p_tab_fqname alias for $1;
     v_nsp_name text;
     v_tab_name text;
	 v_i integer;
	 v_l integer;
     v_pq2 integer;
begin
	v_l := length(p_tab_fqname);

	-- Let us search for the dot
	if p_tab_fqname like '"%' then
		-- if the first part of the ident starts with a double quote, search
		-- for the closing double quote, skipping over double double quotes.
		v_i := 2;
		while v_i <= v_l loop
			if substr(p_tab_fqname, v_i, 1) != '"' then
				v_i := v_i + 1;
			else
				v_i := v_i + 1;
				if substr(p_tab_fqname, v_i, 1) != '"' then
					exit;
				end if;
				v_i := v_i + 1;
			end if;
		end loop;
	else
		-- first part of ident is not quoted, search for the dot directly
		v_i := 1;
		while v_i <= v_l loop
			if substr(p_tab_fqname, v_i, 1) = '.' then
				exit;
			end if;
			v_i := v_i + 1;
		end loop;
	end if;

	-- v_i now points at the dot or behind the string.

	if substr(p_tab_fqname, v_i, 1) = '.' then
		-- There is a dot now, so split the ident into its namespace
		-- and objname parts and make sure each is quoted
		v_nsp_name := substr(p_tab_fqname, 1, v_i - 1);
		v_tab_name := substr(p_tab_fqname, v_i + 1);
		if v_nsp_name not like '"%' then
			v_nsp_name := '"' || replace(v_nsp_name, '"', '""') ||
						  '"';
		end if;
		if v_tab_name not like '"%' then
			v_tab_name := '"' || replace(v_tab_name, '"', '""') ||
						  '"';
		end if;

		return v_nsp_name || '.' || v_tab_name;
	else
		-- No dot ... must be just an ident without schema
		if p_tab_fqname like '"%' then
			return p_tab_fqname;
		else
			return '"' || replace(p_tab_fqname, '"', '""') || '"';
		end if;
	end if;

end;$_$;

COMMENT ON FUNCTION slon_quote_input(text) IS 'quote all words that aren''t quoted yet';

CREATE OR REPLACE FUNCTION slonyversion() RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
	return ''	|| "_csctoss_repl".slonyVersionMajor()::text || '.'
				|| "_csctoss_repl".slonyVersionMinor()::text || '.'
				|| "_csctoss_repl".slonyVersionPatchlevel()::text;
end;
$$;

COMMENT ON FUNCTION slonyversion() IS 'Returns the version number of the slony schema';

CREATE OR REPLACE FUNCTION slonyversionmajor() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	return 1;
end;
$$;

COMMENT ON FUNCTION slonyversionmajor() IS 'Returns the major version number of the slony schema';

CREATE OR REPLACE FUNCTION slonyversionminor() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	return 2;
end;
$$;

COMMENT ON FUNCTION slonyversionminor() IS 'Returns the minor version number of the slony schema';

CREATE OR REPLACE FUNCTION slonyversionpatchlevel() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	return 23;
end;
$$;

COMMENT ON FUNCTION slonyversionpatchlevel() IS 'Returns the version patch level of the slony schema';

CREATE OR REPLACE FUNCTION storelisten(integer, integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_origin		alias for $1;
	p_provider	alias for $2;
	p_receiver	alias for $3;
begin
	perform "_csctoss_repl".storeListen_int (p_origin, p_provider, p_receiver);
	return  "_csctoss_repl".createEvent ('_csctoss_repl', 'STORE_LISTEN',
			p_origin::text, p_provider::text, p_receiver::text);
end;
$_$;

COMMENT ON FUNCTION storelisten(integer, integer, integer) IS 'FUNCTION storeListen (li_origin, li_provider, li_receiver)

generate STORE_LISTEN event, indicating that receiver node li_receiver
listens to node li_provider in order to get messages coming from node
li_origin.';

CREATE OR REPLACE FUNCTION storelisten_int(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_li_origin		alias for $1;
	p_li_provider	alias for $2;
	p_li_receiver	alias for $3;
	v_exists		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	select 1 into v_exists
			from "_csctoss_repl".sl_listen
			where li_origin = p_li_origin
			and li_provider = p_li_provider
			and li_receiver = p_li_receiver;
	if not found then
		-- ----
		-- In case we receive STORE_LISTEN events before we know
		-- about the nodes involved in this, we generate those nodes
		-- as pending.
		-- ----
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_li_origin) then
			perform "_csctoss_repl".storeNode_int (p_li_origin, '<event pending>', 'f');
		end if;
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_li_provider) then
			perform "_csctoss_repl".storeNode_int (p_li_provider, '<event pending>', 'f');
		end if;
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_li_receiver) then
			perform "_csctoss_repl".storeNode_int (p_li_receiver, '<event pending>', 'f');
		end if;

		insert into "_csctoss_repl".sl_listen
				(li_origin, li_provider, li_receiver) values
				(p_li_origin, p_li_provider, p_li_receiver);
	end if;

	return 0;
end;
$_$;

COMMENT ON FUNCTION storelisten_int(integer, integer, integer) IS 'FUNCTION storeListen_int (li_origin, li_provider, li_receiver)

Process STORE_LISTEN event, indicating that receiver node li_receiver
listens to node li_provider in order to get messages coming from node
li_origin.';

CREATE OR REPLACE FUNCTION storenode(integer, text, boolean) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	p_no_comment	alias for $2;
	p_no_spool		alias for $3;
	v_no_spool_txt	text;
begin
	if p_no_spool then
		v_no_spool_txt = 't';
	else
		v_no_spool_txt = 'f';
	end if;
	perform "_csctoss_repl".storeNode_int (p_no_id, p_no_comment, p_no_spool);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'STORE_NODE',
									p_no_id::text, p_no_comment::text, 
									v_no_spool_txt::text);
end;
$_$;

COMMENT ON FUNCTION storenode(integer, text, boolean) IS 'no_id - Node ID #
no_comment - Human-oriented comment
no_spool - Flag for virtual spool nodes

Generate the STORE_NODE event for node no_id';

CREATE OR REPLACE FUNCTION storenode_int(integer, text, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_no_id			alias for $1;
	p_no_comment	alias for $2;
	p_no_spool		alias for $3;
	v_old_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check if the node exists
	-- ----
	select * into v_old_row
			from "_csctoss_repl".sl_node
			where no_id = p_no_id
			for update;
	if found then 
		-- ----
		-- Node exists, update the existing row.
		-- ----
		update "_csctoss_repl".sl_node
				set no_comment = p_no_comment,
				no_spool = p_no_spool
				where no_id = p_no_id;
	else
		-- ----
		-- New node, insert the sl_node row
		-- ----
		insert into "_csctoss_repl".sl_node
				(no_id, no_active, no_comment, no_spool) values
				(p_no_id, 'f', p_no_comment, p_no_spool);
	end if;

	return p_no_id;
end;
$_$;

COMMENT ON FUNCTION storenode_int(integer, text, boolean) IS 'no_id - Node ID #
no_comment - Human-oriented comment
no_spool - Flag for virtual spool nodes

Internal function to process the STORE_NODE event for node no_id';

CREATE OR REPLACE FUNCTION storepath(integer, integer, text, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_pa_server		alias for $1;
	p_pa_client		alias for $2;
	p_pa_conninfo	alias for $3;
	p_pa_connretry	alias for $4;
begin
	perform "_csctoss_repl".storePath_int(p_pa_server, p_pa_client,
			p_pa_conninfo, p_pa_connretry);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'STORE_PATH', 
			p_pa_server::text, p_pa_client::text, 
			p_pa_conninfo::text, p_pa_connretry::text);
end;
$_$;

COMMENT ON FUNCTION storepath(integer, integer, text, integer) IS 'FUNCTION storePath (pa_server, pa_client, pa_conninfo, pa_connretry)

Generate the STORE_PATH event indicating that node pa_client can
access node pa_server using DSN pa_conninfo';

CREATE OR REPLACE FUNCTION storepath_int(integer, integer, text, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_pa_server		alias for $1;
	p_pa_client		alias for $2;
	p_pa_conninfo	alias for $3;
	p_pa_connretry	alias for $4;
	v_dummy			int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check if the path already exists
	-- ----
	select 1 into v_dummy
			from "_csctoss_repl".sl_path
			where pa_server = p_pa_server
			and pa_client = p_pa_client
			for update;
	if found then
		-- ----
		-- Path exists, update pa_conninfo
		-- ----
		update "_csctoss_repl".sl_path
				set pa_conninfo = p_pa_conninfo,
					pa_connretry = p_pa_connretry
				where pa_server = p_pa_server
				and pa_client = p_pa_client;
	else
		-- ----
		-- New path
		--
		-- In case we receive STORE_PATH events before we know
		-- about the nodes involved in this, we generate those nodes
		-- as pending.
		-- ----
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_pa_server) then
			perform "_csctoss_repl".storeNode_int (p_pa_server, '<event pending>', 'f');
		end if;
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_pa_client) then
			perform "_csctoss_repl".storeNode_int (p_pa_client, '<event pending>', 'f');
		end if;
		insert into "_csctoss_repl".sl_path
				(pa_server, pa_client, pa_conninfo, pa_connretry) values
				(p_pa_server, p_pa_client, p_pa_conninfo, p_pa_connretry);
	end if;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	return 0;
end;
$_$;

COMMENT ON FUNCTION storepath_int(integer, integer, text, integer) IS 'FUNCTION storePath (pa_server, pa_client, pa_conninfo, pa_connretry)

Process the STORE_PATH event indicating that node pa_client can
access node pa_server using DSN pa_conninfo';

CREATE OR REPLACE FUNCTION storeset(integer, text) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_set_comment		alias for $2;
	v_local_node_id		int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');

	insert into "_csctoss_repl".sl_set
			(set_id, set_origin, set_comment) values
			(p_set_id, v_local_node_id, p_set_comment);

	return "_csctoss_repl".createEvent('_csctoss_repl', 'STORE_SET', 
			p_set_id::text, v_local_node_id::text, p_set_comment::text);
end;
$_$;

COMMENT ON FUNCTION storeset(integer, text) IS 'Generate STORE_SET event for set set_id with human readable comment set_comment';

CREATE OR REPLACE FUNCTION storeset_int(integer, integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	p_set_origin		alias for $2;
	p_set_comment		alias for $3;
	v_dummy				int4;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	select 1 into v_dummy
			from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if found then 
		update "_csctoss_repl".sl_set
				set set_comment = p_set_comment
				where set_id = p_set_id;
	else
		if not exists (select 1 from "_csctoss_repl".sl_node
						where no_id = p_set_origin) then
			perform "_csctoss_repl".storeNode_int (p_set_origin, '<event pending>', 'f');
		end if;
		insert into "_csctoss_repl".sl_set
				(set_id, set_origin, set_comment) values
				(p_set_id, p_set_origin, p_set_comment);
	end if;

	-- Run addPartialLogIndices() to try to add indices to unused sl_log_? table
	perform "_csctoss_repl".addPartialLogIndices();

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION storeset_int(integer, integer, text) IS 'storeSet_int (set_id, set_origin, set_comment)

Process the STORE_SET event, indicating the new set with given ID,
origin node, and human readable comment.';

CREATE OR REPLACE FUNCTION storetrigger(integer, name) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_trig_tabid		alias for $1;
	p_trig_tgname		alias for $2;
begin
	perform "_csctoss_repl".storeTrigger_int(p_trig_tabid, p_trig_tgname);
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'STORE_TRIGGER',
			p_trig_tabid::text, p_trig_tgname::text);
end;
$_$;

COMMENT ON FUNCTION storetrigger(integer, name) IS 'storeTrigger (trig_tabid, trig_tgname)

Submits STORE_TRIGGER event to indicate that trigger trig_tgname on
replicated table trig_tabid will NOT be disabled.';

CREATE OR REPLACE FUNCTION storetrigger_int(integer, name) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_trig_tabid		alias for $1;
	p_trig_tgname		alias for $2;
	v_tab_altered		boolean;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Do nothing if the sl_trigger entry already exists.
	-- ----
	if exists (select 1 from "_csctoss_repl".sl_trigger
				where trig_tabid = p_trig_tabid
				  and trig_tgname = p_trig_tgname)
		then
		return 0;
	end if;

	-- ----
	-- Get the current table status (altered or not)
	-- ----
	select tab_altered into v_tab_altered
			from "_csctoss_repl".sl_table where tab_id = p_trig_tabid;
	if not found then
		-- ----
		-- Not found is no hard error here, because that might
		-- mean that we are not subscribed to that set
		-- ----
		return 0;
	end if;

	-- ----
	-- If the table is modified for replication, restore the original state
	-- ----
	if v_tab_altered then
		perform "_csctoss_repl".alterTableRestore(p_trig_tabid);
	end if;

	-- ----
	-- Make sure that an entry for this trigger exists
	-- ----
	delete from "_csctoss_repl".sl_trigger
			where trig_tabid = p_trig_tabid
			  and trig_tgname = p_trig_tgname;
	insert into "_csctoss_repl".sl_trigger (
				trig_tabid, trig_tgname
			) values (
				p_trig_tabid, p_trig_tgname
			);

	-- ----
	-- Put the table back into replicated state if it was
	-- ----
	if v_tab_altered then
		perform "_csctoss_repl".alterTableForReplication(p_trig_tabid);
	end if;

	return p_trig_tabid;
end;
$_$;

COMMENT ON FUNCTION storetrigger_int(integer, name) IS 'storeTrigger_int (trig_tabid, trig_tgname)

Processes STORE_TRIGGER event to make sure that trigger trig_tgname on
replicated table trig_tabid is NOT disabled.';

CREATE OR REPLACE FUNCTION subscribeset(integer, integer, integer, boolean) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_provider		alias for $2;
	p_sub_receiver		alias for $3;
	p_sub_forward		alias for $4;
	v_set_origin		int4;
	v_ev_seqno			int8;
	v_rec			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that this is called on the provider node
	-- ----
	if p_sub_provider != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: subscribeSet() must be called on provider';
	end if;

	-- ----
	-- Check that the origin and provider of the set are remote
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_sub_set;
	if not found then
		raise exception 'Slony-I: subscribeSet(): set % not found', p_sub_set;
	end if;
	if v_set_origin = p_sub_receiver then
		raise exception 
				'Slony-I: subscribeSet(): set origin and receiver cannot be identical';
	end if;
	if p_sub_receiver = p_sub_provider then
		raise exception 
				'Slony-I: subscribeSet(): set provider and receiver cannot be identical';
	end if;

	-- ---
	-- Verify that the provider is either the origin or an active subscriber
	-- Bug report #1362
	-- ---
	if v_set_origin <> p_sub_provider then
		if not exists (select 1 from "_csctoss_repl".sl_subscribe
			where sub_set = p_sub_set and 
                              sub_receiver = p_sub_provider and
			      sub_forward and sub_active) then
			raise exception 'Slony-I: subscribeSet(): provider % is not an active forwarding node for replication set %', p_sub_provider, p_sub_set;
		end if;
	end if;

	-- ----
	-- Create the SUBSCRIBE_SET event
	-- ----
	v_ev_seqno :=  "_csctoss_repl".createEvent('_csctoss_repl', 'SUBSCRIBE_SET', 
			p_sub_set::text, p_sub_provider::text, p_sub_receiver::text, 
			case p_sub_forward when true then 't' else 'f' end);

	-- ----
	-- Call the internal procedure to store the subscription
	-- ----
	perform "_csctoss_repl".subscribeSet_int(p_sub_set, p_sub_provider,
			p_sub_receiver, p_sub_forward);

	return v_ev_seqno;
end;
$_$;

COMMENT ON FUNCTION subscribeset(integer, integer, integer, boolean) IS 'subscribeSet (sub_set, sub_provider, sub_receiver, sub_forward)

Makes sure that the receiver is not the provider, then stores the
subscription, and publishes the SUBSCRIBE_SET event to other nodes.';

CREATE OR REPLACE FUNCTION subscribeset_int(integer, integer, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_provider		alias for $2;
	p_sub_receiver		alias for $3;
	p_sub_forward		alias for $4;
	v_set_origin		int4;
	v_sub_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Provider change is only allowed for active sets
	-- ----
	if p_sub_receiver = "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		select sub_active into v_sub_row from "_csctoss_repl".sl_subscribe
				where sub_set = p_sub_set
				and sub_receiver = p_sub_receiver;
		if found then
			if not v_sub_row.sub_active then
				raise exception 'Slony-I: subscribeSet_int(): set % is not active, cannot change provider',
						p_sub_set;
			end if;
		end if;
	end if;

	-- ----
	-- Try to change provider and/or forward for an existing subscription
	-- ----
	update "_csctoss_repl".sl_subscribe
			set sub_provider = p_sub_provider,
				sub_forward = p_sub_forward
			where sub_set = p_sub_set
			and sub_receiver = p_sub_receiver;
	if found then
		-- ----
		-- Rewrite sl_listen table
		-- ----
		perform "_csctoss_repl".RebuildListenEntries();

		return p_sub_set;
	end if;

	-- ----
	-- Not found, insert a new one
	-- ----
	if not exists (select true from "_csctoss_repl".sl_path
			where pa_server = p_sub_provider
			and pa_client = p_sub_receiver)
	then
		insert into "_csctoss_repl".sl_path
				(pa_server, pa_client, pa_conninfo, pa_connretry)
				values 
				(p_sub_provider, p_sub_receiver, 
				'<event pending>', 10);
	end if;
	insert into "_csctoss_repl".sl_subscribe
			(sub_set, sub_provider, sub_receiver, sub_forward, sub_active)
			values (p_sub_set, p_sub_provider, p_sub_receiver,
				p_sub_forward, false);

	-- ----
	-- If the set origin is here, then enable the subscription
	-- ----
	select set_origin into v_set_origin
			from "_csctoss_repl".sl_set
			where set_id = p_sub_set;
	if not found then
		raise exception 'Slony-I: subscribeSet_int(): set % not found', p_sub_set;
	end if;

	if v_set_origin = "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		perform "_csctoss_repl".createEvent('_csctoss_repl', 'ENABLE_SUBSCRIPTION', 
				p_sub_set::text, p_sub_provider::text, p_sub_receiver::text, 
				case p_sub_forward when true then 't' else 'f' end);
		perform "_csctoss_repl".enableSubscription(p_sub_set, 
				p_sub_provider, p_sub_receiver);
	end if;

	-- ----
	-- Rewrite sl_listen table
	-- ----
	perform "_csctoss_repl".RebuildListenEntries();

	return p_sub_set;
end;
$_$;

COMMENT ON FUNCTION subscribeset_int(integer, integer, integer, boolean) IS 'subscribeSet_int (sub_set, sub_provider, sub_receiver, sub_forward)

Internal actions for subscribing receiver sub_receiver to subscription
set sub_set.';

CREATE OR REPLACE FUNCTION tableaddkey(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	v_attkind		text default '';
	v_attrow		record;
	v_have_serial	bool default 'f';
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	--
	-- Loop over the attributes of this relation
	-- and add a "v" for every user column, and a "k"
	-- if we find the Slony-I special serial column.
	--
	for v_attrow in select PGA.attnum, PGA.attname
			from "pg_catalog".pg_class PGC,
			    "pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_attribute PGA
			where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			    "_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
				and PGN.oid = PGC.relnamespace
				and PGA.attrelid = PGC.oid
				and not PGA.attisdropped
				and PGA.attnum > 0
			order by attnum
	loop
		if v_attrow.attname = '_Slony-I_csctoss_repl_rowID' then
		    v_attkind := v_attkind || 'k';
			v_have_serial := 't';
		else
			v_attkind := v_attkind || 'v';
		end if;
	end loop;
	
	--
	-- A table must have at least one attribute, so not finding
	-- anything means the table does not exist.
	--
	if not found then
		raise exception 'Slony-I: tableAddKey(): table % not found', v_tab_fqname_quoted;
	end if;

	--
	-- If it does not have the special serial column, we
	-- have to add it. This will be only half way done.
	-- The function to add the table to the set must finish
	-- these definitions with NOT NULL and UNIQUE after
	-- updating all existing rows.
	--
	if not v_have_serial then
		execute 'lock table ' || v_tab_fqname_quoted ||
			' in access exclusive mode';
		execute 'alter table only ' || v_tab_fqname_quoted ||
			' add column "_Slony-I_csctoss_repl_rowID" bigint;';
		execute 'alter table only ' || v_tab_fqname_quoted ||
			' alter column "_Slony-I_csctoss_repl_rowID" ' ||
			' set default "pg_catalog".nextval(''"_csctoss_repl".sl_rowid_seq'');';

		v_attkind := v_attkind || 'k';
	end if;

	--
	-- Return the resulting Slony-I attkind
	--
	return v_attkind;
end;
$_$;

COMMENT ON FUNCTION tableaddkey(text) IS 'tableAddKey (tab_fqname) - if the table has not got a column of the
form _Slony-I_<clustername>_rowID, then add it as a bigint, defaulted
to nextval() for a sequence created for the cluster.';

CREATE OR REPLACE FUNCTION tabledropkey(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_id		alias for $1;
	v_tab_fqname	text;
	v_tab_oid		oid;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Construct the tables fully qualified name and get its oid
	-- ----
	select "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
				"_csctoss_repl".slon_quote_brute(PGC.relname),
				PGC.oid into v_tab_fqname, v_tab_oid
			from "_csctoss_repl".sl_table T,
				"pg_catalog".pg_class PGC,
				"pg_catalog".pg_namespace PGN
			where T.tab_id = p_tab_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid;
	if not found then
		raise exception 'Slony-I: tableDropKey(): table with ID % not found', p_tab_id;
	end if;

	-- ----
	-- Drop the special serial ID column if the table has it
	-- ----
	if exists (select true from "pg_catalog".pg_attribute
			where attrelid = v_tab_oid
				and attname = '_Slony-I_csctoss_repl_rowID')
	then
		execute 'lock table ' || v_tab_fqname ||
				' in access exclusive mode';
		execute 'alter table ' || v_tab_fqname ||
				' drop column "_Slony-I_csctoss_repl_rowID"';
	end if;

	return p_tab_id;
end;
$_$;

COMMENT ON FUNCTION tabledropkey(integer) IS 'tableDropKey (tab_id)

If the specified table has a column "_Slony-I_<clustername>_rowID",
then drop it.';

CREATE OR REPLACE FUNCTION tablehasserialkey(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
declare
	p_tab_fqname	alias for $1;
	v_tab_fqname_quoted	text default '';
	v_attnum		int2;
begin
	v_tab_fqname_quoted := "_csctoss_repl".slon_quote_input(p_tab_fqname);
	select PGA.attnum into v_attnum
			from "pg_catalog".pg_class PGC,
				"pg_catalog".pg_namespace PGN,
				"pg_catalog".pg_attribute PGA
			where "_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
				"_csctoss_repl".slon_quote_brute(PGC.relname) = v_tab_fqname_quoted
				and PGC.relnamespace = PGN.oid
				and PGA.attrelid = PGC.oid
				and PGA.attname = '_Slony-I_csctoss_repl_rowID'
				and not PGA.attisdropped;
	return found;
end;
$_$;

COMMENT ON FUNCTION tablehasserialkey(text) IS 'tableHasSerialKey (tab_fqname)

Checks if a table has our special serial key column that is used if
the table has no natural unique constraint.';

CREATE OR REPLACE FUNCTION terminatenodeconnections(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_failed_node	alias for $1;
	v_row			record;
begin
	for v_row in select nl_nodeid, nl_conncnt,
			nl_backendpid from "_csctoss_repl".sl_nodelock
			where nl_nodeid = p_failed_node for update
	loop
		perform "_csctoss_repl".killBackend(v_row.nl_backendpid, 'TERM');
		delete from "_csctoss_repl".sl_nodelock
			where nl_nodeid = v_row.nl_nodeid
			and nl_conncnt = v_row.nl_conncnt;
	end loop;

	return 0;
end;
$_$;

COMMENT ON FUNCTION terminatenodeconnections(integer) IS 'terminates all backends that have registered to be from the given node';

CREATE OR REPLACE FUNCTION truncateonlytable(name) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
	execute 'truncate '|| "_csctoss_repl".slon_quote_input($1);
end;
$_$;

COMMENT ON FUNCTION truncateonlytable(name) IS 'Calls TRUNCATE with out specifying ONLY, syntax supported in versions 8.3 and below';

CREATE OR REPLACE FUNCTION uninstallnode() RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
	v_tab_row		record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- This is us ... time for suicide! Restore all tables to
	-- their original status.
	-- ----
	for v_tab_row in select * from "_csctoss_repl".sl_table loop
		perform "_csctoss_repl".alterTableRestore(v_tab_row.tab_id);
		perform "_csctoss_repl".tableDropKey(v_tab_row.tab_id);
	end loop;

	raise notice 'Slony-I: Please drop schema "_csctoss_repl"';
	return 0;
end;
$$;

COMMENT ON FUNCTION uninstallnode() IS 'Reset the whole database to standalone by removing the whole
replication system.';

CREATE OR REPLACE FUNCTION unlockset(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_set_id			alias for $1;
	v_local_node_id		int4;
	v_set_row			record;
	v_tab_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that the set exists and that we are the origin
	-- and that it is not already locked.
	-- ----
	v_local_node_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
	select * into v_set_row from "_csctoss_repl".sl_set
			where set_id = p_set_id
			for update;
	if not found then
		raise exception 'Slony-I: set % not found', p_set_id;
	end if;
	if v_set_row.set_origin <> v_local_node_id then
		raise exception 'Slony-I: set % does not originate on local node',
				p_set_id;
	end if;
	if v_set_row.set_locked isnull then
		raise exception 'Slony-I: set % is not locked', p_set_id;
	end if;

	-- ----
	-- Drop the lockedSet trigger from all tables in the set.
	-- ----
	for v_tab_row in select T.tab_id,
			"_csctoss_repl".slon_quote_brute(PGN.nspname) || '.' ||
			"_csctoss_repl".slon_quote_brute(PGC.relname) as tab_fqname
			from "_csctoss_repl".sl_table T,
				"pg_catalog".pg_class PGC, "pg_catalog".pg_namespace PGN
			where T.tab_set = p_set_id
				and T.tab_reloid = PGC.oid
				and PGC.relnamespace = PGN.oid
			order by tab_id
	loop
		execute 'drop trigger "_csctoss_repl_lockedset_' || 
				v_tab_row.tab_id::text || '" on ' || v_tab_row.tab_fqname;
	end loop;

	-- ----
	-- Clear out the set_locked field
	-- ----
	update "_csctoss_repl".sl_set
			set set_locked = NULL
			where set_id = p_set_id;

	return p_set_id;
end;
$_$;

COMMENT ON FUNCTION unlockset(integer) IS 'Remove the special trigger from all tables of a set that disables access to it.';

CREATE OR REPLACE FUNCTION unsubscribeset(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_receiver		alias for $2;
	v_tab_row			record;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- Check that this is called on the receiver node
	-- ----
	if p_sub_receiver != "_csctoss_repl".getLocalNodeId('_csctoss_repl') then
		raise exception 'Slony-I: unsubscribeSet() must be called on receiver';
	end if;

	-- ----
	-- Check that this does not break any chains
	-- ----
	if exists (select true from "_csctoss_repl".sl_subscribe
			where sub_set = p_sub_set
				and sub_provider = p_sub_receiver)
	then
		raise exception 'Slony-I: Cannot unsubscribe set % while being provider',
				p_sub_set;
	end if;

	-- ----
	-- Restore all tables original triggers and rules and remove
	-- our replication stuff.
	-- ----
	for v_tab_row in select tab_id from "_csctoss_repl".sl_table
			where tab_set = p_sub_set
			order by tab_id
	loop
		perform "_csctoss_repl".alterTableRestore(v_tab_row.tab_id);
		perform "_csctoss_repl".tableDropKey(v_tab_row.tab_id);
	end loop;

	-- ----
	-- Remove the setsync status. This will also cause the
	-- worker thread to ignore the set and stop replicating
	-- right now.
	-- ----
	delete from "_csctoss_repl".sl_setsync
			where ssy_setid = p_sub_set;

	-- ----
	-- Remove all sl_table and sl_sequence entries for this set.
	-- Should we ever subscribe again, the initial data
	-- copy process will create new ones.
	-- ----
	delete from "_csctoss_repl".sl_table
			where tab_set = p_sub_set;
	delete from "_csctoss_repl".sl_sequence
			where seq_set = p_sub_set;

	-- ----
	-- Call the internal procedure to drop the subscription
	-- ----
	perform "_csctoss_repl".unsubscribeSet_int(p_sub_set, p_sub_receiver);

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	-- ----
	-- Create the UNSUBSCRIBE_SET event
	-- ----
	return  "_csctoss_repl".createEvent('_csctoss_repl', 'UNSUBSCRIBE_SET', 
			p_sub_set::text, p_sub_receiver::text);
end;
$_$;

COMMENT ON FUNCTION unsubscribeset(integer, integer) IS 'unsubscribeSet (sub_set, sub_receiver) 

Unsubscribe node sub_receiver from subscription set sub_set.  This is
invoked on the receiver node.  It verifies that this does not break
any chains (e.g. - where sub_receiver is a provider for another node),
then restores tables, drops Slony-specific keys, drops table entries
for the set, drops the subscription, and generates an UNSUBSCRIBE_SET
node to publish that the node is being dropped.';

CREATE OR REPLACE FUNCTION unsubscribeset_int(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
	p_sub_set			alias for $1;
	p_sub_receiver		alias for $2;
begin
	-- ----
	-- Grab the central configuration lock
	-- ----
	lock table "_csctoss_repl".sl_config_lock;

	-- ----
	-- All the real work is done before event generation on the
	-- subscriber.
	-- ----
	delete from "_csctoss_repl".sl_subscribe
			where sub_set = p_sub_set
				and sub_receiver = p_sub_receiver;

	-- Rewrite sl_listen table
	perform "_csctoss_repl".RebuildListenEntries();

	return p_sub_set;
end;
$_$;

COMMENT ON FUNCTION unsubscribeset_int(integer, integer) IS 'unsubscribeSet_int (sub_set, sub_receiver)

All the REAL work of removing the subscriber is done before the event
is generated, so this function just has to drop the references to the
subscription in sl_subscribe.';

CREATE OR REPLACE FUNCTION updaterelname(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
declare
        p_set_id                alias for $1;
        p_only_on_node          alias for $2;
        v_no_id                 int4;
        v_set_origin            int4;
begin
        -- ----
        -- Grab the central configuration lock
        -- ----
        lock table "_csctoss_repl".sl_config_lock;

        -- ----
        -- Check that we either are the set origin or a current
        -- subscriber of the set.
        -- ----
        v_no_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
        select set_origin into v_set_origin
                        from "_csctoss_repl".sl_set
                        where set_id = p_set_id
                        for update;
        if not found then
                raise exception 'Slony-I: set % not found', p_set_id;
        end if;
        if v_set_origin <> v_no_id
                and not exists (select 1 from "_csctoss_repl".sl_subscribe
                        where sub_set = p_set_id
                        and sub_receiver = v_no_id)
        then
                return 0;
        end if;
    
        -- ----
        -- If execution on only one node is requested, check that
        -- we are that node.
        -- ----
        if p_only_on_node > 0 and p_only_on_node <> v_no_id then
                return 0;
        end if;
        update "_csctoss_repl".sl_table set 
                tab_relname = PGC.relname, tab_nspname = PGN.nspname
                from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN 
                where "_csctoss_repl".sl_table.tab_reloid = PGC.oid
                        and PGC.relnamespace = PGN.oid;
        update "_csctoss_repl".sl_sequence set
                seq_relname = PGC.relname, seq_nspname = PGN.nspname
                from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN
                where "_csctoss_repl".sl_sequence.seq_reloid = PGC.oid
                and PGC.relnamespace = PGN.oid;
        return p_set_id;
end;
$_$;

COMMENT ON FUNCTION updaterelname(integer, integer) IS 'updateRelname(set_id, only_on_node)';

CREATE OR REPLACE FUNCTION updatereloid(integer, integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $_$
declare
        p_set_id                alias for $1;
        p_only_on_node          alias for $2;
        v_no_id                 int4;
        v_set_origin            int4;
begin
        -- ----
        -- Grab the central configuration lock
        -- ----
        lock table "_csctoss_repl".sl_config_lock;

        -- ----
        -- Check that we either are the set origin or a current
        -- subscriber of the set.
        -- ----
        v_no_id := "_csctoss_repl".getLocalNodeId('_csctoss_repl');
        select set_origin into v_set_origin
                        from "_csctoss_repl".sl_set
                        where set_id = p_set_id
                        for update;
        if not found then
                raise exception 'Slony-I: set % not found', p_set_id;
        end if;
        if v_set_origin <> v_no_id
                and not exists (select 1 from "_csctoss_repl".sl_subscribe
                        where sub_set = p_set_id
                        and sub_receiver = v_no_id)
        then
                return 0;
        end if;

        -- ----
        -- If execution on only one node is requested, check that
        -- we are that node.
        -- ----
        if p_only_on_node > 0 and p_only_on_node <> v_no_id then
                return 0;
        end if;
        update "_csctoss_repl".sl_table set
                tab_reloid = PGC.oid
                from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN
                where "_csctoss_repl".slon_quote_brute("_csctoss_repl".sl_table.tab_relname) = "_csctoss_repl".slon_quote_brute(PGC.relname)
                        and PGC.relnamespace = PGN.oid
			and "_csctoss_repl".slon_quote_brute(PGN.nspname) = "_csctoss_repl".slon_quote_brute("_csctoss_repl".sl_table.tab_nspname);

        update "_csctoss_repl".sl_sequence set
                seq_reloid = PGC.oid
                from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN
                where "_csctoss_repl".slon_quote_brute("_csctoss_repl".sl_sequence.seq_relname) = "_csctoss_repl".slon_quote_brute(PGC.relname)
                	and PGC.relnamespace = PGN.oid
			and "_csctoss_repl".slon_quote_brute(PGN.nspname) = "_csctoss_repl".slon_quote_brute("_csctoss_repl".sl_sequence.seq_nspname);

        return  "_csctoss_repl".createEvent('_csctoss_repl', 'RESET_CONFIG',
                        p_set_id::text, p_only_on_node::text);
end;
$_$;

COMMENT ON FUNCTION updatereloid(integer, integer) IS 'updateReloid(set_id, only_on_node)

Updates the respective reloids in sl_table and sl_seqeunce based on
their respective FQN';

CREATE OR REPLACE FUNCTION upgradeschema(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

declare
        p_old   alias for $1;
begin
	-- upgrade sl_table
	if p_old IN ('1.0.2', '1.0.5', '1.0.6') then
		-- Add new column(s) sl_table.tab_relname, sl_table.tab_nspname
		execute 'alter table "_csctoss_repl".sl_table add column tab_relname name';
		execute 'alter table "_csctoss_repl".sl_table add column tab_nspname name';

		-- populate the colums with data
		update "_csctoss_repl".sl_table set
			tab_relname = PGC.relname, tab_nspname = PGN.nspname
			from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN
			where "_csctoss_repl".sl_table.tab_reloid = PGC.oid
			and PGC.relnamespace = PGN.oid;

		-- constrain the colums
		execute 'alter table "_csctoss_repl".sl_table alter column tab_relname set NOT NULL';
		execute 'alter table "_csctoss_repl".sl_table alter column tab_nspname set NOT NULL';

	end if;

	-- upgrade sl_sequence
	if p_old IN ('1.0.2', '1.0.5', '1.0.6') then
		-- Add new column(s) sl_sequence.seq_relname, sl_sequence.seq_nspname
		execute 'alter table "_csctoss_repl".sl_sequence add column seq_relname name';
		execute 'alter table "_csctoss_repl".sl_sequence add column seq_nspname name';

		-- populate the columns with data
		update "_csctoss_repl".sl_sequence set
			seq_relname = PGC.relname, seq_nspname = PGN.nspname
			from pg_catalog.pg_class PGC, pg_catalog.pg_namespace PGN
			where "_csctoss_repl".sl_sequence.seq_reloid = PGC.oid
			and PGC.relnamespace = PGN.oid;

		-- constrain the data
		execute 'alter table "_csctoss_repl".sl_sequence alter column seq_relname set NOT NULL';
		execute 'alter table "_csctoss_repl".sl_sequence alter column seq_nspname set NOT NULL';
	end if;

	-- ----
	-- Changes from 1.0.x to 1.1.0
	-- ----
	if p_old IN ('1.0.2', '1.0.5', '1.0.6') then
		-- Add new column sl_node.no_spool for virtual spool nodes
		execute 'alter table "_csctoss_repl".sl_node add column no_spool boolean';
		update "_csctoss_repl".sl_node set no_spool = false;
	end if;

	-- ----
	-- Changes for 1.1.3
	-- ----
	if p_old IN ('1.0.2', '1.0.5', '1.0.6', '1.1.0', '1.1.1', '1.1.2') then
		-- Add new table sl_nodelock
		execute 'create table "_csctoss_repl".sl_nodelock (
						nl_nodeid		int4,
						nl_conncnt		serial,
						nl_backendpid	int4,

						CONSTRAINT "sl_nodelock-pkey"
						PRIMARY KEY (nl_nodeid, nl_conncnt)
					)';
		-- Drop obsolete functions
		execute 'drop function "_csctoss_repl".terminateNodeConnections(name)';
		execute 'drop function "_csctoss_repl".cleanupListener()';
		execute 'drop function "_csctoss_repl".truncateTable(text)';
	end if;

	-- ----
	-- Changes for 1.2
	-- ----
	if p_old IN ('1.0.2', '1.0.5', '1.0.6', '1.1.0', '1.1.1', '1.1.2', '1.1.3','1.1.5', '1.1.6', '1.1.7', '1.1.8', '1.1.9') then
		-- Add new table sl_registry
		execute 'create table "_csctoss_repl".sl_registry (
						reg_key			text primary key,
						reg_int4		int4,
						reg_text		text,
						reg_timestamp	timestamp
					) without oids';
                execute 'alter table "_csctoss_repl".sl_config_lock set without oids;';
                execute 'alter table "_csctoss_repl".sl_confirm set without oids;';
                execute 'alter table "_csctoss_repl".sl_event set without oids;';
                execute 'alter table "_csctoss_repl".sl_listen set without oids;';
                execute 'alter table "_csctoss_repl".sl_node set without oids;';
                execute 'alter table "_csctoss_repl".sl_nodelock set without oids;';
                execute 'alter table "_csctoss_repl".sl_path set without oids;';
                execute 'alter table "_csctoss_repl".sl_sequence set without oids;';
                execute 'alter table "_csctoss_repl".sl_set set without oids;';
                execute 'alter table "_csctoss_repl".sl_setsync set without oids;';
                execute 'alter table "_csctoss_repl".sl_subscribe set without oids;';
                execute 'alter table "_csctoss_repl".sl_table set without oids;';
                execute 'alter table "_csctoss_repl".sl_trigger set without oids;';
	end if;

	-- ----
	-- Changes for 1.2.11
	-- ----
	if p_old IN ('1.0.2', '1.0.5', '1.0.6', '1.1.0', '1.1.1', '1.1.2', '1.1.3','1.1.5', '1.1.6', '1.1.7', '1.1.8', '1.1.9', '1.2.0', '1.2.1', '1.2.2', '1.2.3', '1.2.4', '1.2.5', '1.2.6', '1.2.7', '1.2.8', '1.2.9', '1.2.10') then
		-- Add new table sl_archive_counter
		execute 'create table "_csctoss_repl".sl_archive_counter (
						ac_num			bigint,
						ac_timestamp	timestamp
					) without oids';
		execute 'insert into "_csctoss_repl".sl_archive_counter
					(ac_num, ac_timestamp) values (0, ''epoch''::timestamp)';
	end if;

	-- In any version, make sure that the xxidin() functions are defined STRICT
	perform "_csctoss_repl".make_function_strict ('xxidin', '(cstring)');
	return p_old;
end;
$_$;

COMMENT ON FUNCTION upgradeschema(text) IS 'Called during "update functions" by slonik to perform schema changes';

CREATE OR REPLACE FUNCTION xxid_ge_snapshot(xxid, xxid_snapshot) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxid_ge_snapshot';

CREATE OR REPLACE FUNCTION xxid_lt_snapshot(xxid, xxid_snapshot) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxid_lt_snapshot';

CREATE OR REPLACE FUNCTION xxideq(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxideq';

CREATE OR REPLACE FUNCTION xxidge(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxidge';

CREATE OR REPLACE FUNCTION xxidgt(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxidgt';

CREATE OR REPLACE FUNCTION xxidle(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxidle';

CREATE OR REPLACE FUNCTION xxidlt(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxidlt';

CREATE OR REPLACE FUNCTION xxidne(xxid, xxid) RETURNS boolean
    LANGUAGE c
    AS '$libdir/xxid', '_Slony_I_xxidne';

ALTER TABLE sl_event
	ADD CONSTRAINT "sl_event-pkey" PRIMARY KEY (ev_origin, ev_seqno);

ALTER TABLE sl_listen
	ADD CONSTRAINT "sl_listen-pkey" PRIMARY KEY (li_origin, li_provider, li_receiver);

ALTER TABLE sl_node
	ADD CONSTRAINT "sl_node-pkey" PRIMARY KEY (no_id);

ALTER TABLE sl_nodelock
	ADD CONSTRAINT "sl_nodelock-pkey" PRIMARY KEY (nl_nodeid, nl_conncnt);

ALTER TABLE sl_path
	ADD CONSTRAINT "sl_path-pkey" PRIMARY KEY (pa_server, pa_client);

ALTER TABLE sl_registry
	ADD CONSTRAINT sl_registry_pkey PRIMARY KEY (reg_key);

ALTER TABLE sl_sequence
	ADD CONSTRAINT "sl_sequence-pkey" PRIMARY KEY (seq_id);

ALTER TABLE sl_set
	ADD CONSTRAINT "sl_set-pkey" PRIMARY KEY (set_id);

ALTER TABLE sl_setsync
	ADD CONSTRAINT "sl_setsync-pkey" PRIMARY KEY (ssy_setid);

ALTER TABLE sl_subscribe
	ADD CONSTRAINT "sl_subscribe-pkey" PRIMARY KEY (sub_receiver, sub_set);

ALTER TABLE sl_table
	ADD CONSTRAINT "sl_table-pkey" PRIMARY KEY (tab_id);

ALTER TABLE sl_trigger
	ADD CONSTRAINT "sl_trigger-pkey" PRIMARY KEY (trig_tabid, trig_tgname);

ALTER TABLE sl_listen
	ADD CONSTRAINT "li_origin-no_id-ref" FOREIGN KEY (li_origin) REFERENCES sl_node(no_id);

ALTER TABLE sl_listen
	ADD CONSTRAINT "sl_listen-sl_path-ref" FOREIGN KEY (li_provider, li_receiver) REFERENCES sl_path(pa_server, pa_client);

ALTER TABLE sl_path
	ADD CONSTRAINT "pa_client-no_id-ref" FOREIGN KEY (pa_client) REFERENCES sl_node(no_id);

ALTER TABLE sl_path
	ADD CONSTRAINT "pa_server-no_id-ref" FOREIGN KEY (pa_server) REFERENCES sl_node(no_id);

ALTER TABLE sl_sequence
	ADD CONSTRAINT sl_sequence_seq_reloid_key UNIQUE (seq_reloid);

ALTER TABLE sl_sequence
	ADD CONSTRAINT "seq_set-set_id-ref" FOREIGN KEY (seq_set) REFERENCES sl_set(set_id);

ALTER TABLE sl_set
	ADD CONSTRAINT "set_origin-no_id-ref" FOREIGN KEY (set_origin) REFERENCES sl_node(no_id);

ALTER TABLE sl_setsync
	ADD CONSTRAINT "ssy_origin-no_id-ref" FOREIGN KEY (ssy_origin) REFERENCES sl_node(no_id);

ALTER TABLE sl_setsync
	ADD CONSTRAINT "ssy_setid-set_id-ref" FOREIGN KEY (ssy_setid) REFERENCES sl_set(set_id);

ALTER TABLE sl_subscribe
	ADD CONSTRAINT "sl_subscribe-sl_path-ref" FOREIGN KEY (sub_provider, sub_receiver) REFERENCES sl_path(pa_server, pa_client);

ALTER TABLE sl_subscribe
	ADD CONSTRAINT "sub_set-set_id-ref" FOREIGN KEY (sub_set) REFERENCES sl_set(set_id);

ALTER TABLE sl_table
	ADD CONSTRAINT sl_table_tab_reloid_key UNIQUE (tab_reloid);

ALTER TABLE sl_table
	ADD CONSTRAINT "tab_set-set_id-ref" FOREIGN KEY (tab_set) REFERENCES sl_set(set_id);

ALTER TABLE sl_trigger
	ADD CONSTRAINT "trig_tabid-tab_id-ref" FOREIGN KEY (trig_tabid) REFERENCES sl_table(tab_id) ON DELETE CASCADE;

CREATE INDEX sl_confirm_idx1 ON sl_confirm USING btree (con_origin, con_received, con_seqno);

CREATE INDEX sl_confirm_idx2 ON sl_confirm USING btree (con_received, con_seqno);

CREATE INDEX "PartInd_csctoss_repl_sl_log_1-node-201" ON sl_log_1 USING btree (log_xid) WHERE (log_origin = 201);

CREATE INDEX sl_log_1_idx1 ON sl_log_1 USING btree (log_origin, log_xid, log_actionseq);

CREATE INDEX "PartInd_csctoss_repl_sl_log_2-node-201" ON sl_log_2 USING btree (log_xid) WHERE (log_origin = 201);

CREATE INDEX log_tableid_idx ON sl_log_2 USING btree (log_tableid);

CREATE INDEX sl_log_2_idx1 ON sl_log_2 USING btree (log_origin, log_xid, log_actionseq);

CREATE INDEX sl_seqlog_idx ON sl_seqlog USING btree (seql_origin, seql_ev_seqno, seql_seqid);

CREATE VIEW sl_seqlastvalue AS
	SELECT sq.seq_id, sq.seq_set, sq.seq_reloid, s.set_origin AS seq_origin, sequencelastvalue(((quote_ident((pgn.nspname)::text) || '.'::text) || quote_ident((pgc.relname)::text))) AS seq_last_value FROM sl_sequence sq, sl_set s, pg_class pgc, pg_namespace pgn WHERE (((s.set_id = sq.seq_set) AND (pgc.oid = sq.seq_reloid)) AND (pgn.oid = pgc.relnamespace));

CREATE VIEW sl_status AS
	SELECT e.ev_origin AS st_origin, c.con_received AS st_received, e.ev_seqno AS st_last_event, e.ev_timestamp AS st_last_event_ts, c.con_seqno AS st_last_received, c.con_timestamp AS st_last_received_ts, ce.ev_timestamp AS st_last_received_event_ts, (e.ev_seqno - c.con_seqno) AS st_lag_num_events, (('now'::text)::timestamp(6) with time zone - (ce.ev_timestamp)::timestamp with time zone) AS st_lag_time FROM sl_event e, sl_confirm c, sl_event ce WHERE (((((e.ev_origin = c.con_origin) AND (ce.ev_origin = e.ev_origin)) AND (ce.ev_seqno = c.con_seqno)) AND ((e.ev_origin, e.ev_seqno) IN (SELECT sl_event.ev_origin, max(sl_event.ev_seqno) AS max FROM sl_event WHERE (sl_event.ev_origin = getlocalnodeid('_csctoss_repl'::name)) GROUP BY sl_event.ev_origin))) AND ((c.con_origin, c.con_received, c.con_seqno) IN (SELECT sl_confirm.con_origin, sl_confirm.con_received, max(sl_confirm.con_seqno) AS max FROM sl_confirm WHERE (sl_confirm.con_origin = getlocalnodeid('_csctoss_repl'::name)) GROUP BY sl_confirm.con_origin, sl_confirm.con_received)));

COMMENT ON VIEW sl_status IS 'View showing how far behind remote nodes are.';

SET search_path = csctoss, pg_catalog;

DROP FUNCTION ops_api_assign(text, text, integer, text, boolean, boolean);

DROP FUNCTION static_ip_desc(text);

DROP FUNCTION unique_id(integer, text);

DROP FUNCTION username_correct();

DROP TABLE billing_entity_fusio;

CREATE TABLE v_contact_id (
	nextval bigint
);

CREATE TRIGGER _csctoss_repl_logtrigger_1270
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1270', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1150
	AFTER INSERT OR UPDATE OR DELETE ON equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1150', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1080
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1080', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1930
	AFTER INSERT OR UPDATE OR DELETE ON line
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1930', 'kvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1940
	AFTER INSERT OR UPDATE OR DELETE ON line_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1940', 'kkvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2480
	AFTER INSERT OR UPDATE OR DELETE ON location_labels
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2480', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1850
	AFTER INSERT OR UPDATE OR DELETE ON radreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1850', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1200
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1200', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1800
	AFTER INSERT OR UPDATE OR DELETE ON usergroup
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1800', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1250
	AFTER INSERT OR UPDATE OR DELETE ON address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1250', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1210
	AFTER INSERT OR UPDATE OR DELETE ON address_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1210', 'kv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1880
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_contact
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1880', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1890
	AFTER INSERT OR UPDATE OR DELETE ON alert_definition_snmp
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1890', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2340
	AFTER INSERT OR UPDATE OR DELETE ON alert_priority
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2340', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1860
	AFTER INSERT OR UPDATE OR DELETE ON alert_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1860', 'kvvvv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_2150
	AFTER INSERT OR UPDATE OR DELETE ON api_device_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2150', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1370
	AFTER INSERT OR UPDATE OR DELETE ON api_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1370', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2160
	AFTER INSERT OR UPDATE OR DELETE ON api_parser
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2160', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1380
	AFTER INSERT OR UPDATE OR DELETE ON api_request_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1380', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2170
	AFTER INSERT OR UPDATE OR DELETE ON api_supported_device
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2170', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1140
	AFTER INSERT OR UPDATE OR DELETE ON app_config
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1140', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1910
	AFTER INSERT OR UPDATE OR DELETE ON atm_processor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1910', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1760
	AFTER INSERT OR UPDATE OR DELETE ON attribute
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1760', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1750
	AFTER INSERT OR UPDATE OR DELETE ON attribute_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1750', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1330
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1330', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1710
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_download
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1710', 'kkvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1430
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_location_label
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1430', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1360
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1360', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1260
	AFTER INSERT OR UPDATE OR DELETE ON billing_entity_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1260', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1600
	AFTER INSERT OR UPDATE OR DELETE ON bp_aggregate_usage_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1600', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1590
	AFTER INSERT OR UPDATE OR DELETE ON bp_allotment_adjustment_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1590', 'kkkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1480
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_calendar
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1480', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1490
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_period
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1490', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1540
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1540', 'kvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1610
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_discount
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1610', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1560
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_onetime
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1560', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1550
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_static
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1550', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1440
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1440', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1450
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_unit
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1450', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1570
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_charge_usage
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1570', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1520
	AFTER INSERT OR UPDATE OR DELETE ON bp_master_billing_plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1520', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1460
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_discount_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1460', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1530
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_entity_preferences
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1530', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1630
	AFTER INSERT OR UPDATE OR DELETE ON bp_billing_equipment_assignment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1630', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1470
	AFTER INSERT OR UPDATE OR DELETE ON bp_charge_frequency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1470', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1620
	AFTER INSERT OR UPDATE OR DELETE ON bp_past_due_charge
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1620', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1640
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_billing_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1640', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1660
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_change_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1660', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1650
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_charge_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1650', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1680
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_status_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1680', 'kkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1670
	AFTER INSERT OR UPDATE OR DELETE ON bp_period_usage_summary
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1670', 'kvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1580
	AFTER INSERT OR UPDATE OR DELETE ON bp_usage_allotment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1580', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2060
	AFTER INSERT OR UPDATE OR DELETE ON branding_button
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2060', 'kkvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2070
	AFTER INSERT OR UPDATE OR DELETE ON branding_content
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2070', 'kvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2080
	AFTER INSERT OR UPDATE OR DELETE ON branding_presentation
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2080', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1740
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1740', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1720
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1720', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1730
	AFTER INSERT OR UPDATE OR DELETE ON broadcast_message_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1730', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1390
	AFTER INSERT OR UPDATE OR DELETE ON plan
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1390', 'kvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1350
	AFTER INSERT OR UPDATE OR DELETE ON product
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1350', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1510
	AFTER INSERT OR UPDATE OR DELETE ON carrier
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1510', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2240
	AFTER INSERT OR UPDATE OR DELETE ON carrier_api_activity_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2240', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2050
	AFTER INSERT OR UPDATE OR DELETE ON carrier_domain
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2050', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_2000
	AFTER INSERT OR UPDATE OR DELETE ON cc_auth_log
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2000', 'kvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2010
	AFTER INSERT OR UPDATE OR DELETE ON cc_encrypt_key
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2010', 'kvvvv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1340
	AFTER INSERT OR UPDATE OR DELETE ON contact_address
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1340', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1280
	AFTER INSERT OR UPDATE OR DELETE ON contact_level
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1280', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1290
	AFTER INSERT OR UPDATE OR DELETE ON contact_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1290', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1500
	AFTER INSERT OR UPDATE OR DELETE ON currency
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1500', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2500
	AFTER INSERT OR UPDATE OR DELETE ON device_monitor
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2500', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1700
	AFTER INSERT OR UPDATE OR DELETE ON download_file_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1700', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_2180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2180', 'kvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_firmware
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2190', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1160
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1160', 'kkv');

CREATE TRIGGER _csctoss_repl_logtrigger_1070
	AFTER INSERT OR UPDATE OR DELETE ON equipment_info_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1070', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2200
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_credential
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2200', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2370
	AFTER INSERT OR UPDATE OR DELETE ON equipment_model_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2370', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1170
	AFTER INSERT OR UPDATE OR DELETE ON equipment_note
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1170', 'kkvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1180
	AFTER INSERT OR UPDATE OR DELETE ON equipment_software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1180', 'kkvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1190
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1190', 'kvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1110
	AFTER INSERT OR UPDATE OR DELETE ON equipment_status_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1110', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1100
	AFTER INSERT OR UPDATE OR DELETE ON equipment_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1100', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1780
	AFTER INSERT OR UPDATE OR DELETE ON username
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1780', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2560
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2560', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2580
	AFTER INSERT OR UPDATE OR DELETE ON equipment_warranty_rule
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2580', 'kv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1950
	AFTER INSERT OR UPDATE OR DELETE ON line_terminal
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1950', 'kvv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1220
	AFTER INSERT OR UPDATE OR DELETE ON location_label_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1220', 'kv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1690
	AFTER INSERT OR UPDATE OR DELETE ON portal_properties
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1690', 'kv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1830
	AFTER INSERT OR UPDATE OR DELETE ON radgroupcheck
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1830', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1840
	AFTER INSERT OR UPDATE OR DELETE ON radgroupreply
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1840', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2590
	AFTER INSERT OR UPDATE OR DELETE ON radius_operator
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2590', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1120
	AFTER INSERT OR UPDATE OR DELETE ON receiving_lot
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1120', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1060
	AFTER INSERT OR UPDATE OR DELETE ON replication_failure
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1060', 'kvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1400
	AFTER INSERT OR UPDATE OR DELETE ON report
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1400', 'kvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2600
	AFTER INSERT OR UPDATE OR DELETE ON rma_form
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2600', 'kvvvvvvvvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1990
	AFTER INSERT OR UPDATE OR DELETE ON sales_order
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1990', 'kv');

CREATE TRIGGER _csctoss_repl_logtrigger_1320
	AFTER INSERT OR UPDATE OR DELETE ON security_roles
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1320', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1410
	AFTER INSERT OR UPDATE OR DELETE ON shipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1410', 'kvvvvvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1420
	AFTER INSERT OR UPDATE OR DELETE ON shipment_equipment
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1420', 'kkvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1130
	AFTER INSERT OR UPDATE OR DELETE ON software
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1130', 'kvvvv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_1020
	AFTER INSERT OR UPDATE OR DELETE ON staff_access
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1020', 'kk');

CREATE TRIGGER _csctoss_repl_logtrigger_1240
	AFTER INSERT OR UPDATE OR DELETE ON state_code
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1240', 'kvv');

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

CREATE TRIGGER _csctoss_repl_logtrigger_2110
	AFTER INSERT OR UPDATE OR DELETE ON throw_away_minutes
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2110', 'kvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1050
	AFTER INSERT OR UPDATE OR DELETE ON timezone
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1050', 'kvv');

CREATE TRIGGER _csctoss_repl_logtrigger_2420
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_history
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '2420', 'kvvvvvvvv');

CREATE TRIGGER _csctoss_repl_logtrigger_1090
	AFTER INSERT OR UPDATE OR DELETE ON unique_identifier_type
	FOR EACH ROW
	EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1090', 'kvv');

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

SET search_path = invoice, pg_catalog;

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
