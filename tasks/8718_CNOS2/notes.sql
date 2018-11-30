

2018-10-15 10:39:15 MDT 10.249.17.102(46802) csctoss_owner 7936 5014590STATEMENT:  select * from unique_id(3,'A10000157EC0D3');
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591LOG:  statement: select * from unique_id(3,'A10000157EC0D3');
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591NOTICE:  SQL: select l.line_id
	                ,le.equipment_id
	                ,l.radius_username
	                ,uim.value
	                ,uis.value
	                ,uie.value
	                ,NULL
	            from line_equipment le
	            join line l on l.line_id = le.line_id join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS' join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER' join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX' where uie.value = %L






2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591LOG:  statement: SELECT  format( $1 ,  $2 ) INTO  $3 
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591CONTEXT:  SQL statement "SELECT  format( $1 ,  $2 ) INTO  $3 "
	PL/pgSQL function "unique_id" line 44 at execute statement
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591ERROR:  syntax error at or near "$3" at character 34
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591QUERY:  SELECT  format( $1 ,  $2 ) INTO  $3 
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591CONTEXT:  PL/pgSQL function "unique_id" line 44 at execute statement
2018-10-15 10:42:58 MDT 10.249.17.102(46802) csctoss_owner 7936 5014591STATEMENT:  select * from unique_id(3,'A10000157EC0D3');




v_sql := 'INSERT INTO line_equipment (line_id ,equipment_id ,start_date ,end_date' ;
v_sql := v_sql || ' ,billing_entity_address_id ,ship_date ,install_date ,installed_by)' ;
v_sql := v_sql || ' VALUES(' ;
v_sql := v_sql || arrea_line[i]::TEXT ;
v_sql := v_sql || ', ' || arrea_equip[i]::TEXT ;
v_sql := v_sql || ', \'' || arrea_start[i]::TEXT || '\'::DATE' ;
IF arrea_end[i] = 'X' THEN
	v_sql := v_sql || ', null' ;
ELSE
	v_sql := v_sql || ', \'' || arrea_end[i]::TEXT || '\'::DATE' ;
END IF ;
IF v_address_id IS NULL THEN
	v_sql := v_sql || ', null' ;
ELSE
	v_sql := v_sql || ', ' || v_address_id::TEXT ;
END IF ;
IF arrea_ship[i] = 'X' THEN
	v_sql := v_sql || ', null' ;
ELSE
	v_sql := v_sql || ', \'' || arrea_ship[i]::TEXT || '\'::DATE' ;
END IF ;
IF arrea_inst_date[i] = 'X' THEN
	v_sql := v_sql || ', null' ;
ELSE
	v_sql := v_sql || ', \'' || arrea_inst_date[i]::TEXT || '\'::DATE' ;
END IF ;
IF arrea_inst_by[i] IS NULL THEN
	v_sql := v_sql || ', null )' ;
ELSE
	v_sql := v_sql || ', \'' || arrea_inst_by[i] || '\' )' ;
END IF ;
EXECUTE v_sql ;