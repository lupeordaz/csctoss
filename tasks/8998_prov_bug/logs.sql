[postgres@testoss01 csctoss_logs]$ tail -f csctoss-2018-11-01_000000.log
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 5067452CONTEXT:  SQL statement "SELECT  ( $1  = 0)"
	PL/pgSQL function "ops_get_firmware_status" line 48 at if
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 5067452LOG:  statement: SELECT  'Current'
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 5067452CONTEXT:  SQL statement "SELECT  'Current'"
	PL/pgSQL function "ops_get_firmware_status" line 51 at assignment
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 5067452LOG:  statement: SELECT   $1 
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 5067452CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_get_firmware_status" line 59 at return
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38928) postgres 24874 0LOG:  disconnection: session time: 0:00:00.40 user=postgres database=csctoss host=devapi01.jcigroup.local port=38928
2018-11-01 16:34:05 MDT devapi01.jcigroup.local(38926) postgres 24873 0LOG:  disconnection: session time: 0:00:00.42 user=postgres database=csctoss host=devapi01.jcigroup.local port=38926
2018-11-01 16:34:28 MDT  [unknown] 24877 0LOG:  connection received: host=192.168.144.244 port=47708
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 0LOG:  connection authorized: user=postgres database=csctoss
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 5067454LOG:  statement: SET datestyle='ISO'
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 0LOG:  duration: 0.929 ms
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 5067455LOG:  statement: SET bytea_output='escape'
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 5067455ERROR:  unrecognized configuration parameter "bytea_output"
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 5067455STATEMENT:  SET bytea_output='escape'
2018-11-01 16:34:28 MDT 192.168.144.244(47708) postgres 24877 0LOG:  disconnection: session time: 0:00:00.04 user=postgres database=csctoss host=192.168.144.244 port=47708
2018-11-01 16:34:28 MDT  [unknown] 24878 0LOG:  connection received: host=192.168.144.244 port=47710
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 0LOG:  connection authorized: user=postgres database=csctoss
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 5067457LOG:  statement: SET datestyle='ISO'
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 0LOG:  duration: 0.686 ms
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 5067458LOG:  statement: SET bytea_output='escape'
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 5067458ERROR:  unrecognized configuration parameter "bytea_output"
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 5067458STATEMENT:  SET bytea_output='escape'
2018-11-01 16:34:28 MDT 192.168.144.244(47710) postgres 24878 5067459LOG:  statement: SELECT COUNT(*) FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = '353238060067682'
2018-11-01 16:34:28 MDT  [unknown] 24879 0LOG:  connection received: host=devapi01.jcigroup.local port=38930
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 0LOG:  connection authorized: user=postgres database=csctoss
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  * FROM csctoss.ops_api_assign ($1, $2, $3, $4, $5, $6, $7) 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_assign" line 37 at block variables initialization
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SET client_min_messages TO notice
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SET client_min_messages TO notice"
	PL/pgSQL function "ops_api_assign" line 38 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  public.set_change_log_staff_id (3)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  public.set_change_log_staff_id (3)"
	PL/pgSQL function "ops_api_assign" line 39 at perform
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'All or some of the input values are null.'
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'All or some of the input values are null.'"
	PL/pgSQL function "ops_api_assign" line 42 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = '' OR  $2  = '' OR  $3  IS NULL OR  $4  = '' OR  $5  IS NULL OR  $6  is NULL
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = '' OR  $2  = '' OR  $3  IS NULL OR  $4  = '' OR  $5  IS NULL OR  $6  is NULL"
	PL/pgSQL function "ops_api_assign" line 43 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  The ESN HEX value entered does not exist:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  The ESN HEX value entered does not exist:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 55 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value =  $1 "
	PL/pgSQL function "ops_api_assign" line 56 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 61 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Equipment model does not exist:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Equipment model does not exist:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 66 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  equipment_model_id FROM equipment WHERE equipment_id =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  equipment_model_id FROM equipment WHERE equipment_id =  $1 "
	PL/pgSQL function "ops_api_assign" line 67 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 71 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  em.carrier FROM unique_identifier ui JOIN equipment e ON ui.equipment_id = e.equipment_id JOIN equipment_model em ON em.equipment_model_id = e.equipment_model_id WHERE ui.value =  $1  LIMIT 1
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  em.carrier FROM unique_identifier ui JOIN equipment e ON ui.equipment_id = e.equipment_id JOIN equipment_model em ON em.equipment_model_id = e.equipment_model_id WHERE ui.value =  $1  LIMIT 1"
	PL/pgSQL function "ops_api_assign" line 77 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  Sales Order: SO100364
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  ESN: 353238060067682
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  CARRIER: VZW
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  ( $1  = 'USCC')
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  ( $1  = 'USCC')"
	PL/pgSQL function "ops_api_assign" line 89 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  value FROM unique_identifier WHERE unique_identifier_type = 'MDN' AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value =  $1 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  value FROM unique_identifier WHERE unique_identifier_type = 'MDN' AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value =  $1 )"
	PL/pgSQL function "ops_api_assign" line 95 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  MDN/MIN: 4708298912
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Username does not exist:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Username does not exist:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 104 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  username FROM username WHERE SUBSTR(username, 1, 10) =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  username FROM username WHERE SUBSTR(username, 1, 10) =  $1 "
	PL/pgSQL function "ops_api_assign" line 105 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 109 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  USERNAME: 4708298912@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Serial Number value does not exist for the Equipment:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Serial Number value does not exist for the Equipment:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 123 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  value FROM unique_identifier WHERE unique_identifier_type = 'SERIAL NUMBER' AND equipment_id =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  value FROM unique_identifier WHERE unique_identifier_type = 'SERIAL NUMBER' AND equipment_id =  $1 "
	PL/pgSQL function "ops_api_assign" line 124 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 129 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Billing Entity Address does not exist:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Billing Entity Address does not exist:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 135 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  address_id FROM billing_entity_address WHERE billing_entity_id =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  address_id FROM billing_entity_address WHERE billing_entity_id =  $1 "
	PL/pgSQL function "ops_api_assign" line 136 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 140 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Active Line already exists for ESN Hex provided:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Active Line already exists for ESN Hex provided:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 144 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  nextval('csctoss.line_line_id_seq')
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  nextval('csctoss.line_line_id_seq')"
	PL/pgSQL function "ops_api_assign" line 145 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  EXISTS (SELECT TRUE FROM line l JOIN line_equipment le USING (line_id) JOIN unique_identifier ui USING (equipment_id) WHERE ui.unique_identifier_type = 'ESN HEX' AND ui.value =  $1  AND le.end_date IS NULL)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  EXISTS (SELECT TRUE FROM line l JOIN line_equipment le USING (line_id) JOIN unique_identifier ui USING (equipment_id) WHERE ui.unique_identifier_type = 'ESN HEX' AND ui.value =  $1  AND le.end_date IS NULL)"
	PL/pgSQL function "ops_api_assign" line 146 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846378
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846378"
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO change_log (staff_id, change_type, table_name, primary_key, column_name, previous_value) VALUES ($1, $2, $3, $4, $5, $6)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO change_log (staff_id, change_type, table_name, primary_key, column_name, previous_value) VALUES ($1, $2, $3, $4, $5, $6)"
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."staff" x WHERE "staff_id" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."staff" x WHERE "staff_id" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO change_log (staff_id, change_type, table_name, primary_key, column_name, previous_value) VALUES ($1, $2, $3, $4, $5, $6)"
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NOT NULL AND  $2  >  $3 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NOT NULL AND  $2  >  $3 "
	PL/pgSQL function "line_pre_insert" line 4 at if
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NOT NULL AND (SELECT COUNT(*) > 0 FROM csctoss.line_equipment WHERE line_id =  $2  AND end_date IS NULL)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NOT NULL AND (SELECT COUNT(*) > 0 FROM csctoss.line_equipment WHERE line_id =  $2  AND end_date IS NULL)"
	PL/pgSQL function "line_pre_insert" line 9 at if
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."billing_entity" x WHERE "billing_entity_id" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."billing_entity" x WHERE "billing_entity_id" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."line_assignment_type" x WHERE "line_assignment_type" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."line_assignment_type" x WHERE "line_assignment_type" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO line ( line_id, line_assignment_type, billing_entity_id, billing_entity_address_id, active_flag, line_label, start_date, date_created, radius_username, notes) VALUES (  $1 , 'CUSTOMER ASSIGNED',  $2 ,  $3 , TRUE,  $4 , current_date, current_date,  $5 ,  $6 )"
	PL/pgSQL function "ops_api_assign" line 157 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Line Insert Failed!'
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Line Insert Failed!'"
	PL/pgSQL function "ops_api_assign" line 166 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 167 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  start_date FROM line WHERE line_id =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  start_date FROM line WHERE line_id =  $1 "
	PL/pgSQL function "ops_api_assign" line 172 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Username Update Failed:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Username Update Failed:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 176 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: UPDATE username SET notes =  $1 , billing_entity_id =  $2  WHERE username =  $3 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "UPDATE username SET notes =  $1 , billing_entity_id =  $2  WHERE username =  $3 "
	PL/pgSQL function "ops_api_assign" line 177 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214847072
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214847072"
	SQL statement "UPDATE username SET notes =  $1 , billing_entity_id =  $2  WHERE username =  $3 "
	PL/pgSQL function "ops_api_assign" line 177 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."billing_entity" x WHERE "billing_entity_id" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."billing_entity" x WHERE "billing_entity_id" = $1 FOR UPDATE OF x"
	SQL statement "UPDATE username SET notes =  $1 , billing_entity_id =  $2  WHERE username =  $3 "
	PL/pgSQL function "ops_api_assign" line 177 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 182 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Equipment is already assigned to a line:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Equipment is already assigned to a line:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 190 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id =  $1  AND end_date IS NULL)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id =  $1  AND end_date IS NULL)"
	PL/pgSQL function "ops_api_assign" line 191 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id =  $1  AND end_date = current_date )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id =  $1  AND end_date = current_date )"
	PL/pgSQL function "ops_api_assign" line 194 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Line_Equipment Insert Failed!'
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Line_Equipment Insert Failed!'"
	PL/pgSQL function "ops_api_assign" line 201 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846389
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846389"
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NOT NULL AND  $2  >  $3 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NOT NULL AND  $2  >  $3 "
	PL/pgSQL function "line_equipment_pre_insert" line 4 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NULL
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NULL"
	PL/pgSQL function "line_equipment_pre_insert" line 9 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE line_id <>  $1  AND equipment_id =  $2  AND end_date IS NULL)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE line_id <>  $1  AND equipment_id =  $2  AND end_date IS NULL)"
	PL/pgSQL function "line_equipment_pre_insert" line 12 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE line_id <>  $1  AND equipment_id =  $2  AND end_date IS NOT NULL AND  $3  < end_date)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE line_id <>  $1  AND equipment_id =  $2  AND end_date IS NOT NULL AND  $3  < end_date)"
	PL/pgSQL function "line_equipment_pre_insert" line 21 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE  $1  BETWEEN start_date AND COALESCE(end_date, '9999-12-31') AND line_id <>  $2  AND equipment_id =  $3 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE  $1  BETWEEN start_date AND COALESCE(end_date, '9999-12-31') AND line_id <>  $2  AND equipment_id =  $3 )"
	PL/pgSQL function "line_equipment_pre_insert" line 33 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NOT NULL AND (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE  $2  BETWEEN start_date AND COALESCE(end_date, '9999-12-31') AND line_id <>  $3  AND equipment_id =  $4 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NOT NULL AND (SELECT count(*) > 0 FROM csctoss.line_equipment WHERE  $2  BETWEEN start_date AND COALESCE(end_date, '9999-12-31') AND line_id <>  $3  AND equipment_id =  $4 )"
	PL/pgSQL function "line_equipment_pre_insert" line 41 at if
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."equipment" x WHERE "equipment_id" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."equipment" x WHERE "equipment_id" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."line" x WHERE "line_id" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."line" x WHERE "line_id" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO line_equipment (line_id, equipment_id, start_date, billing_entity_address_id) VALUES ( $1 ,  $2 , current_date,  $3 )"
	PL/pgSQL function "ops_api_assign" line 202 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_assign" line 207 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  start_date FROM line_equipment WHERE line_id =  $1  AND equipment_id =  $2 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  start_date FROM line_equipment WHERE line_id =  $1  AND equipment_id =  $2 "
	PL/pgSQL function "ops_api_assign" line 213 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  priority FROM groupname WHERE 1 = 1 AND groupname =  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  priority FROM groupname WHERE 1 = 1 AND groupname =  $1 "
	PL/pgSQL function "ops_api_assign" line 224 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR:  Usergroup not found in GROUPNAME table:  ' ||  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR:  Usergroup not found in GROUPNAME table:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 230 at assignment
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 0
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 0"
	PL/pgSQL function "ops_api_assign" line 231 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: DELETE FROM usergroup WHERE username LIKE  $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "DELETE FROM usergroup WHERE username LIKE  $1 "
	PL/pgSQL function "ops_api_assign" line 236 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846422
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846422"
	SQL statement "DELETE FROM usergroup WHERE username LIKE  $1 "
	PL/pgSQL function "ops_api_assign" line 236 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO usergroup (username,groupname,priority) VALUES ( $1 , $2 , $3 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO usergroup (username,groupname,priority) VALUES ( $1 , $2 , $3 )"
	PL/pgSQL function "ops_api_assign" line 238 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846422
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846422"
	SQL statement "INSERT INTO usergroup (username,groupname,priority) VALUES ( $1 , $2 , $3 )"
	PL/pgSQL function "ops_api_assign" line 238 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."groupname" x WHERE "groupname" = $1 FOR UPDATE OF x
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."groupname" x WHERE "groupname" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO usergroup (username,groupname,priority) VALUES ( $1 , $2 , $3 )"
	PL/pgSQL function "ops_api_assign" line 238 at SQL statement
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  em.carrier FROM unique_identifier ui JOIN equipment e ON (ui.equipment_id = e.equipment_id) JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id) WHERE 1 = 1 AND ui.value =  $1  LIMIT 1
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  em.carrier FROM unique_identifier ui JOIN equipment e ON (ui.equipment_id = e.equipment_id) JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id) WHERE 1 = 1 AND ui.value =  $1  LIMIT 1"
	PL/pgSQL function "ops_api_assign" line 247 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = FALSE
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = FALSE"
	PL/pgSQL function "ops_api_assign" line 257 at if
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 12 at block variables initialization
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 12 at block variables initialization
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 12 at block variables initialization
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 12 at block variables initialization
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 12 at block variables initialization
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SET client_min_messages TO notice
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SET client_min_messages TO notice"
	PL/pgSQL function "ops_api_static_ip_assign" line 13 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4708298912@vzw3g.com][line_id=47270][billing_entity_id=368]
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  public.set_change_log_staff_id(3)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  public.set_change_log_staff_id(3)"
	PL/pgSQL function "ops_api_static_ip_assign" line 16 at perform
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  IS NULL OR  $2  IS NULL OR  $3  IS NULL OR  $4  IS NULL OR  $5  IS NULL
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  IS NULL OR  $2  IS NULL OR  $3  IS NULL OR  $4  IS NULL OR  $5  IS NULL"
	PL/pgSQL function "ops_api_static_ip_assign" line 19 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  static_ip FROM static_ip_pool sip JOIN static_ip_carrier_def sid ON (sid.carrier_def_id = sip.carrier_id) WHERE groupname =  $1  AND carrier LIKE '%'|| $2 ||'%' AND billing_entity_id =  $3  ORDER BY billing_entity_id LIMIT 1
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  static_ip FROM static_ip_pool sip JOIN static_ip_carrier_def sid ON (sid.carrier_def_id = sip.carrier_id) WHERE groupname =  $1  AND carrier LIKE '%'|| $2 ||'%' AND billing_entity_id =  $3  ORDER BY billing_entity_id LIMIT 1"
	PL/pgSQL function "ops_api_static_ip_assign" line 30 at select into variables
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 42 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  No billing entity id path selected.
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  static_ip FROM static_ip_pool sip JOIN static_ip_carrier_def sid ON (sid.carrier_def_id = sip.carrier_id) WHERE groupname =  $1  AND is_assigned = FALSE AND carrier LIKE '%'|| $2 ||'%' AND billing_entity_id is null ORDER BY static_ip LIMIT 1 FOR UPDATE
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  static_ip FROM static_ip_pool sip JOIN static_ip_carrier_def sid ON (sid.carrier_def_id = sip.carrier_id) WHERE groupname =  $1  AND is_assigned = FALSE AND carrier LIKE '%'|| $2 ||'%' AND billing_entity_id is null ORDER BY static_ip LIMIT 1 FOR UPDATE"
	PL/pgSQL function "ops_api_static_ip_assign" line 103 at select into variables
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 116 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  Processing radreply: Username: 4708298912@vzw3g.com, static_ip: 10.80.0.85.
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT ( SELECT TRUE FROM radreply WHERE username =  $1  AND attribute = 'Class')
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT ( SELECT TRUE FROM radreply WHERE username =  $1  AND attribute = 'Class')"
	PL/pgSQL function "ops_api_static_ip_assign" line 118 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)
2018-11-01 16:34:28 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846406
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846406"
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 'Class'
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 'Class'"
	PL/pgSQL function "radreply_pre_insert_update" line 11 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 'INSERT'
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 'INSERT'"
	PL/pgSQL function "radreply_pre_insert_update" line 12 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  username FROM csctoss.radreply WHERE attribute = 'Class' AND value =  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  username FROM csctoss.radreply WHERE attribute = 'Class' AND value =  $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 15 at select into variables
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 20 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  value FROM csctoss.radreply WHERE username =  $1  AND attribute = 'Class' AND value <>  $2 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  value FROM csctoss.radreply WHERE username =  $1  AND attribute = 'Class' AND value <>  $2 "
	PL/pgSQL function "radreply_pre_insert_update" line 25 at select into variables
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 31 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 'Framed-IP-Address'
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 'Framed-IP-Address'"
	PL/pgSQL function "radreply_pre_insert_update" line 51 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."attribute" x WHERE "attribute" = $1 FOR UPDATE OF x
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."attribute" x WHERE "attribute" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 1 FROM ONLY "csctoss"."radius_operator" x WHERE "op" = $1 FOR UPDATE OF x
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 1 FROM ONLY "csctoss"."radius_operator" x WHERE "op" = $1 FOR UPDATE OF x"
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Class', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 132 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  <> 1
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  <> 1"
	PL/pgSQL function "ops_api_static_ip_assign" line 135 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846406
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT indkey FROM pg_index WHERE indisprimary='t' AND indrelid=214846406"
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 'INSERT'
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 'INSERT'"
	PL/pgSQL function "radreply_pre_insert_update" line 59 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  value FROM csctoss.radreply WHERE attribute = 'Framed-IP-Address' AND op = '=' AND username =  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  value FROM csctoss.radreply WHERE attribute = 'Framed-IP-Address' AND op = '=' AND username =  $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 61 at select into variables
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 67 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  ((SELECT count(*) FROM csctoss.radreply rr JOIN csctoss.usergroup ug ON (rr.username = ug.username) WHERE 1 = 1 AND rr.attribute = 'Framed-IP-Address' AND rr.value =  $1  AND ug.groupname = (SELECT groupname FROM usergroup ug2 WHERE ug2.username =  $2 )) >= 1)
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  ((SELECT count(*) FROM csctoss.radreply rr JOIN csctoss.usergroup ug ON (rr.username = ug.username) WHERE 1 = 1 AND rr.attribute = 'Framed-IP-Address' AND rr.value =  $1  AND ug.groupname = (SELECT groupname FROM usergroup ug2 WHERE ug2.username =  $2 )) >= 1)"
	PL/pgSQL function "radreply_pre_insert_update" line 72 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  username FROM csctoss.radreply WHERE attribute = 'Framed-IP-Address' AND op = '=' AND value =  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  username FROM csctoss.radreply WHERE attribute = 'Framed-IP-Address' AND op = '=' AND value =  $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 93 at select into variables
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "radreply_pre_insert_update" line 99 at if
	SQL statement "INSERT INTO radreply (username, attribute, op, value, priority) VALUES ( $1 , 'Framed-IP-Address', '=',  $2 ::text, 10)"
	PL/pgSQL function "ops_api_static_ip_assign" line 141 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  <> 1
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  <> 1"
	PL/pgSQL function "ops_api_static_ip_assign" line 144 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  Update static_ip_pool for static_ip 10.80.0.85: line_id - 47270, groupname - SERVICE-vzwretail_cnione
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: UPDATE static_ip_pool SET is_assigned = 'TRUE' , line_id =  $1  WHERE static_ip =  $2  AND groupname =  $3 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "UPDATE static_ip_pool SET is_assigned = 'TRUE' , line_id =  $1  WHERE static_ip =  $2  AND groupname =  $3 "
	PL/pgSQL function "ops_api_static_ip_assign" line 152 at SQL statement
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  NOT  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  NOT  $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 158 at if
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1 "
	PL/pgSQL function "ops_api_static_ip_assign" line 163 at return
	SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
	PL/pgSQL function "ops_api_assign" line 269 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  substring( $1  from 1 for 3) = 'ERR'
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  substring( $1  from 1 for 3) = 'ERR'"
	PL/pgSQL function "ops_api_assign" line 275 at if
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  STATIC IP: 10.80.0.85
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  product_id, plan_type_id, length_days FROM csctoss.product WHERE 1 = 1 AND product_code =  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  product_id, plan_type_id, length_days FROM csctoss.product WHERE 1 = 1 AND product_code =  $1 "
	PL/pgSQL function "ops_api_assign" line 286 at select into variables
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT 'ERROR: Invalid Product code:  ' ||  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT 'ERROR: Invalid Product code:  ' ||  $1 "
	PL/pgSQL function "ops_api_assign" line 291 at assignment
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT   $1  = 0
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT   $1  = 0"
	PL/pgSQL function "ops_api_assign" line 292 at if
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462NOTICE:  Invalid Product code
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  false
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  false"
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462LOG:  statement: SELECT  $1 
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 5067462CONTEXT:  SQL statement "SELECT  $1 "
2018-11-01 16:34:29 MDT devapi01.jcigroup.local(38930) postgres 24879 0LOG:  disconnection: session time: 0:00:00.80 user=postgres database=csctoss host=devapi01.jcigroup.local port=38930
2018-11-01 16:34:29 MDT 192.168.144.244(47710) postgres 24878 5067464LOG:  statement: DEALLOCATE pdo_stmt_00000001
2018-11-01 16:34:29 MDT 192.168.144.244(47710) postgres 24878 0LOG:  duration: 0.264 ms
2018-11-01 16:34:29 MDT 192.168.144.244(47710) postgres 24878 0LOG:  disconnection: session time: 0:00:00.89 user=postgres database=csctoss host=192.168.144.244 port=47710
^C
[postgres@testoss01 csctoss_logs]$ 
