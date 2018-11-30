-- Function: username_check()

-- DROP FUNCTION username_check();

CREATE OR REPLACE FUNCTION username_check()
  RETURNS SETOF my_type2 AS
$BODY$
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

		var_myrow2.upd_equip_id 	  := var_myrow.equip_id;
		var_myrow2.correct_min		  := var_myrow.rad_username;
		var_myrow2.exist_min		    := var_myrow.uim_value;
		var_myrow2.related_equip_id := var_equipment_id;
		var_myrow2.related_min		  := var_min_value;

		RETURN NEXT var_myrow2;

	END LOOP;

RAISE NOTICE 'Finished Function';
RETURN;
END ;
$BODY$
  LANGUAGE plpgsql STABLE SECURITY DEFINER;
ALTER FUNCTION username_check()
  OWNER TO csctoss_owner;
