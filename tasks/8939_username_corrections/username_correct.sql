-- Function: username_correct()

-- DROP FUNCTION username_correct();

CREATE OR REPLACE FUNCTION username_correct()
  RETURNS int AS
$BODY$
DECLARE
  c_staff_id              	integer:=3;
  var_myrow					my_type1%ROWTYPE;
  var_status				int;
  v_result                	integer;
  v_numrows               	integer;

BEGIN

--select * INTO v_result public.set_change_log_staff_id(c_staff_id);

FOR var_myrow IN 
  SELECT DISTINCT ui.equipment_id
      ,substring(l.radius_username,1,(position('@' IN l.radius_username) - 1)) AS username
  FROM line l
  JOIN line_equipment le ON le.line_id = l.line_id
  JOIN unique_identifier ui ON le.equipment_id = ui.equipment_id
  JOIN unique_identifier uim ON le.equipment_id = uim.equipment_id AND uim.unique_identifier_type = 'MIN'
 WHERE l.end_date is NULL
   AND l.radius_username LIKE '%@uscc.net'
   AND substring(l.radius_username,1,(position('@' IN l.radius_username) - 1)) <> uim.value
 ORDER BY 1,2 limit 10

	LOOP
		RAISE NOTICE 'Equipment Id:  %', var_myrow.equip_id;
		RAISE NOTICE 'Username:      %', var_myrow.user_prefix;

	    UPDATE unique_identifier
	       SET value = var_myrow.user_prefix
	     WHERE equipment_id = var_myrow.equip_id
	       AND unique_identifier_type = 'MIN';

	    GET DIAGNOSTICS v_numrows = ROW_COUNT;
	    IF v_numrows = 0 THEN
	        RAISE NOTICE 'Update failed: %',var_myrow.user_prefix;
	    END IF;

	END LOOP;

RAISE NOTICE 'Finished Function';
RETURN 0;
END ;
$BODY$
  LANGUAGE plpgsql VOLATILE;;
ALTER FUNCTION username_correct()
  OWNER TO csctoss_owner;
