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
-- Name: rt_oss_rma(text, text, text); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--
CREATE OR REPLACE FUNCTION rt_oss_rma(text, text, text) 
  RETURNS oss_rma_retval AS
$BODY$
DECLARE
    v_retval            oss_rma_retval%ROWTYPE;

BEGIN
    select * INTO v_retval from rt_oss_rma($1, $2, $3, false);
    RETURN v_retval;

END;  
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION rt_oss_rma(text, text, text)
  OWNER TO csctoss_owner;

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
        SELECT username INTO v_new_username
        FROM username u,
             unique_identifier ui
        WHERE 1=1
             AND substring(u.username FROM 1 FOR 10) = ui.value
             AND ui.equipment_id=v_nequipid
             AND ui.unique_identifier_type = 'MDN'
--             AND u.end_date = to_date('2999-12-31','yyyy-mm-dd')
             ;
    ELSE
        SELECT username INTO v_new_username
        FROM username u,
        unique_identifier ui
        WHERE 1=1
          AND substring(u.username FROM 1 FOR 10) = ui.value
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

    RAISE NOTICE '[rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.';

    -- Insert csctoss.equipment_warranty record.

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


ALTER FUNCTION csctoss.rt_oss_rma(text, text, text, boolean) OWNER TO csctoss_owner;

--
-- Name: rt_oss_rma(text, text, text); Type: ACL; Schema: csctoss; Owner: csctoss_owner
--

REVOKE ALL ON FUNCTION rt_oss_rma(text, text, text, boolean) FROM PUBLIC;
REVOKE ALL ON FUNCTION rt_oss_rma(text, text, text, boolean) FROM csctoss_owner;
GRANT ALL ON FUNCTION rt_oss_rma(text, text, text, boolean) TO csctoss_owner;
GRANT ALL ON FUNCTION rt_oss_rma(text, text, text, boolean) TO postgres;
GRANT ALL ON FUNCTION rt_oss_rma(text, text, text, boolean) TO PUBLIC;


--
-- PostgreSQL database dump complete
--

