csctoss=# select prosrc from pg_proc where proname='ops_api_assign';
                                                                    prosrc                                                                    
----------------------------------------------------------------------------------------------------------------------------------------------
                                                                                                                                             +
 DECLARE                                                                                                                                     +
     var_return_row                     ops_api_assign_retval%ROWTYPE;                                                                       +
 BEGIN                                                                                                                                       +
     select * INTO var_return_row from ops_api_assign($1, $2, $3, $4, $5, false);                                                            +
     RETURN NEXT var_return_row;                                                                                                             +
     RETURN;                                                                                                                                 +
                                                                                                                                             +
 END;                                                                                                                                        +
 
                                                                                                                                             +
 DECLARE                                                                                                                                     +
     par_esn_hex                        text := $1;                                                                                          +
     par_sales_order                    text := $2;                                                                                          +
     par_billing_entity_id              integer := $3;                                                                                       +
     par_groupname                      text := $4;                                                                                          +
     par_static_ip_boolean              boolean := $5;                                                                                       +
     par_bypass_jbilling                boolean := $6;                                                                                       +
     var_equipment_id                   integer;                                                                                             +
     var_line_id                        integer;                                                                                             +
     var_mdn                            text;                                                                                                +
     var_mdn_min                        text;                                                                                                +
     var_username                       text;                                                                                                +
     var_billing_entity_address_id      integer;                                                                                             +
     var_static_ip                      text;                                                                                                +
     var_conn_string                    text;                                                                                                +
     var_serial_number                  text;                                                                                                +
     var_line_start_date                date;                                                                                                +
     var_line_equip_start_date          date;                                                                                                +
     var_model_id                       integer;                                                                                             +
     var_carrier                        text;                                                                                                +
     var_sql                            text;                                                                                                +
     var_return_row                     ops_api_assign_retval%ROWTYPE;                                                                       +
     v_return_2                         boolean;                                                                                             +
     v_jbilling_item_code               text;                                                                                                +
     var_sql_2                          text;                                                                                                +
     v_product_id                       integer;                                                                                             +
     v_plan_type_id                     integer;                                                                                             +
     v_length_days                      integer;                                                                                             +
     v_line_ctr                         integer;                                                                                             +
     v_numrows                          integer;                                                                                             +
     v_count                            integer;                                                                                             +
     v_priority                         integer;                                                                                             +
                                                                                                                                             +
 BEGIN                                                                                                                                       +
     SET client_min_messages TO notice;                                                                                                      +
     PERFORM public.set_change_log_staff_id (3);                                                                                             +
                                                                                                                                             +
     -- Check if the parameters are null                                                                                                     +
     IF par_esn_hex = ''                                                                                                                     +
     OR par_sales_order = ''                                                                                                                 +
     OR par_billing_entity_id IS NULL                                                                                                        +
     OR par_groupname = ''                                                                                                                   +
     OR par_static_ip_boolean IS NULL                                                                                                        +
     THEN                                                                                                                                    +
         RAISE EXCEPTION 'All or some of the input values are null';                                                                         +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  All or some of the input values are null';                                                 +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Validate Parameters                                                                                                                  +
     SELECT equipment_id INTO var_equipment_id                                                                                               +
       FROM unique_identifier                                                                                                                +
      WHERE unique_identifier_type = 'ESN HEX'                                                                                               +
        AND value = par_esn_hex;                                                                                                             +
                                                                                                                                             +
     IF NOT FOUND THEN                                                                                                                       +
         RAISE EXCEPTION 'The ESN HEX value entered doesnt exist';                                                                           +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  The ESN HEX value entered doesnt exist';                                                   +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     SELECT equipment_model_id INTO var_model_id                                                                                             +
       FROM equipment                                                                                                                        +
      WHERE equipment_id = var_equipment_id;                                                                                                 +
                                                                                                                                             +
     IF NOT FOUND THEN                                                                                                                       +
          RAISE EXCEPTION 'Equipment model doesnt exist.';                                                                                   +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Equipment model doesnt exist.';                                                        +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Get carrier name from equipment model table                                                                                          +
     SELECT em.carrier INTO var_carrier                                                                                                      +
       FROM unique_identifier ui                                                                                                             +
       JOIN equipment e ON ui.equipment_id = e.equipment_id                                                                                  +
       JOIN equipment_model em ON em.equipment_model_id = e.equipment_model_id                                                               +
      WHERE ui.value = par_esn_hex                                                                                                           +
      LIMIT 1;                                                                                                                               +
                                                                                                                                             +
     RAISE NOTICE 'Sales Order: %',par_sales_order;                                                                                          +
     RAISE NOTICE 'ESN: %',par_esn_hex;                                                                                                      +
     RAISE NOTICE 'CARRIER: %',var_carrier;                                                                                                  +
                                                                                                                                             +
     -- Retrieve a part of username depending upon carrier and MDN/MIN value.                                                                +
     IF (var_carrier = 'USCC')  THEN                                                                                                         +
         SELECT value INTO var_mdn_min                                                                                                       +
           FROM unique_identifier                                                                                                            +
          WHERE unique_identifier_type = 'MIN'                                                                                               +
            AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);+
     ELSE                                                                                                                                    +
         SELECT value INTO var_mdn_min                                                                                                       +
           FROM unique_identifier                                                                                                            +
          WHERE unique_identifier_type = 'MDN'                                                                                               +
            AND equipment_id = (SELECT equipment_id FROM unique_identifier WHERE unique_identifier_type = 'ESN HEX' AND value = par_esn_hex);+
     END IF;                                                                                                                                 +
                                                                                                                                             +
     RAISE NOTICE 'MDN/MIN: %',var_mdn_min;                                                                                                  +
                                                                                                                                             +
     -- Retrieve username value using MDN or MIN value                                                                                       +
     SELECT username INTO var_username                                                                                                       +
     FROM username                                                                                                                           +
     WHERE SUBSTR(username, 1, 10) = var_mdn_min;                                                                                            +
     RAISE NOTICE 'USERNAME: % USERGROUP: %',var_username,par_groupname;                                                                     +
                                                                                                                                             +
     IF NOT FOUND THEN                                                                                                                       +
         SELECT username INTO var_username                                                                                                   +
         FROM username                                                                                                                       +
         WHERE 1 = 1                                                                                                                         +
         AND substr(username, 1, 15) = var_mdn_min ;                                                                                         +
                                                                                                                                             +
         IF NOT FOUND THEN                                                                                                                   +
             RAISE EXCEPTION 'Username does not exist';                                                                                      +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Username does not exist!';                                                             +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         END IF;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Retrieve Serial Number value from unique_identifier                                                                                  +
     SELECT value INTO var_serial_number                                                                                                     +
     FROM unique_identifier                                                                                                                  +
     WHERE unique_identifier_type = 'SERIAL NUMBER'                                                                                          +
     AND equipment_id = var_equipment_id;                                                                                                    +
                                                                                                                                             +
     IF NOT FOUND THEN                                                                                                                       +
         RAISE EXCEPTION 'Serial Number value does not exist for the Equipment.';                                                            +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  Serial Number value does not exist for the Equipment.';                                    +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Billing_entity_address_id retrieval                                                                                                  +
     SELECT address_id INTO var_billing_entity_address_id                                                                                    +
     FROM billing_entity_address                                                                                                             +
     WHERE billing_entity_id = par_billing_entity_id;                                                                                        +
                                                                                                                                             +
     IF NOT FOUND THEN                                                                                                                       +
         RAISE EXCEPTION 'Billing Entity Address does not exist';                                                                            +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  Billing Entity Address does not exist';                                                    +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     ELSE                                                                                                                                    +
         var_line_id := nextval('csctoss.line_line_id_seq');                                                                                 +
         IF EXISTS (SELECT TRUE                                                                                                              +
                    FROM line l                                                                                                              +
                    JOIN line_equipment le USING (line_id)                                                                                   +
                    JOIN unique_identifier ui USING (equipment_id)                                                                           +
                    WHERE ui.unique_identifier_type = 'ESN HEX'                                                                              +
                    AND ui.value = par_esn_hex AND le.end_date IS NULL)                                                                      +
         THEN                                                                                                                                +
             RAISE EXCEPTION 'Active Line already exists for the input parameters';                                                          +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Active Line already exists for the input parameters';                                  +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         ELSE                                                                                                                                +
             -- Insert required fields values into line table                                                                                +
             INSERT INTO line (                                                                                                              +
                 line_id, line_assignment_type, billing_entity_id,                                                                           +
                 billing_entity_address_id, active_flag, line_label,                                                                         +
                 start_date, date_created, radius_username, notes)                                                                           +
             VALUES (                                                                                                                        +
                 var_line_id, 'CUSTOMER ASSIGNED', par_billing_entity_id,                                                                    +
                 var_billing_entity_address_id, TRUE, par_esn_hex,                                                                           +
                 current_date, current_date, var_username, par_sales_order);                                                                 +
                                                                                                                                             +
             IF NOT FOUND THEN                                                                                                               +
                 RAISE EXCEPTION 'Line Insert Failed!';                                                                                      +
                 var_return_row.result_code := false;                                                                                        +
                 var_return_row.error_message := 'ERROR:  Line Insert Failed!';                                                              +
                 RETURN NEXT var_return_row;                                                                                                 +
                 RETURN;                                                                                                                     +
             END IF;                                                                                                                         +
                                                                                                                                             +
             SELECT start_date INTO var_line_start_date                                                                                      +
             FROM line WHERE line_id = var_line_id;                                                                                          +
                                                                                                                                             +
             -- Update username table with SO_ORDER and Billing_Entity_ID                                                                    +
             UPDATE username                                                                                                                 +
                 SET notes = par_sales_order,                                                                                                +
                     billing_entity_id = par_billing_entity_id                                                                               +
             WHERE username = var_username;                                                                                                  +
                                                                                                                                             +
             IF NOT FOUND THEN                                                                                                               +
                 RAISE EXCEPTION 'Username Update Failed!';                                                                                  +
                 var_return_row.result_code := false;                                                                                        +
                 var_return_row.error_message := 'ERROR:  Username Update Failed!';                                                          +
                 RETURN NEXT var_return_row;                                                                                                 +
                 RETURN;                                                                                                                     +
             END IF;                                                                                                                         +
         END IF;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- If no active line exists for the equipment then Insert line, equipment details.                                                      +
     IF NOT EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id = var_equipment_id AND end_date IS NULL) THEN                         +
                                                                                                                                             +
         -- [BEGIN] NEW CODE TO CHECK IF OWNERSHIP TRANSFER - IF SO, THEN BACK DATE END DATE                                                 +
         IF EXISTS (SELECT TRUE FROM line_equipment WHERE equipment_id = var_equipment_id AND end_date = current_date ) THEN                 +
             UPDATE line_equipment                                                                                                           +
             SET                                                                                                                             +
             end_date = current_date - 1                                                                                                     +
             WHERE equipment_id = var_equipment_id                                                                                           +
             AND   end_date = current_date ;                                                                                                 +
         END IF;                                                                                                                             +
         -- [END] NEW CODE TO CHECK IF OWNERSHIP TRANSFER - IF SO, THEN BACK DATE END DATE                                                   +
                                                                                                                                             +
         INSERT INTO line_equipment                                                                                                          +
             (line_id, equipment_id, start_date, billing_entity_address_id)                                                                  +
         VALUES                                                                                                                              +
             (var_line_id, var_equipment_id, current_date, var_billing_entity_address_id);                                                   +
                                                                                                                                             +
         IF NOT FOUND THEN                                                                                                                   +
             RAISE EXCEPTION 'Line_Equipment Insert Failed!';                                                                                +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Line_Equipment Insert Failed!';                                                        +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         END IF;                                                                                                                             +
                                                                                                                                             +
         -- no idea why this is here                                                                                                         +
         SELECT start_date INTO var_line_equip_start_date                                                                                    +
         FROM line_equipment                                                                                                                 +
         WHERE line_id = var_line_id                                                                                                         +
         AND equipment_id = var_equipment_id;                                                                                                +
                                                                                                                                             +
     ELSE                                                                                                                                    +
         RAISE EXCEPTION 'Equipment is already assigned to a line.';                                                                         +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  Equipment is already assigned to a line.';                                                 +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Update usergroup table with input groupname.                                                                                         +
     SELECT priority INTO v_priority                                                                                                         +
       FROM groupname                                                                                                                        +
      WHERE 1 = 1                                                                                                                            +
        AND groupname = par_groupname;                                                                                                       +
                                                                                                                                             +
     GET DIAGNOSTICS v_numrows = ROW_COUNT;                                                                                                  +
     IF v_numrows = 0 THEN                                                                                                                   +
         RAISE EXCEPTION 'Usergroup not found in GROUPNAME table.';                                                                          +
         var_return_row.result_code := false;                                                                                                +
         var_return_row.error_message := 'ERROR:  Usergroup not found in GROUPNAME table.';                                                  +
         RETURN NEXT var_return_row;                                                                                                         +
         RETURN;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     DELETE FROM usergroup WHERE username LIKE var_username;                                                                                 +
                                                                                                                                             +
     INSERT INTO usergroup                                                                                                                   +
         (username,groupname,priority)                                                                                                       +
     VALUES                                                                                                                                  +
         (var_username,par_groupname,v_priority) ;                                                                                           +
                                                                                                                                             +
     -- removed to fix duplicate issue- UPDATE usergroup SET groupname = par_groupname WHERE username LIKE var_username;                     +
                                                                                                                                             +
     -- SELECT carrier from equipment model table                                                                                            +
                                                                                                                                             +
     SELECT em.carrier INTO var_carrier                                                                                                      +
     FROM unique_identifier ui                                                                                                               +
     JOIN equipment e ON (ui.equipment_id = e.equipment_id)                                                                                  +
     JOIN equipment_model em ON (em.equipment_model_id = e.equipment_model_id)                                                               +
     WHERE 1 = 1                                                                                                                             +
     AND ui.value = par_esn_hex                                                                                                              +
     LIMIT 1;                                                                                                                                +
                                                                                                                                             +
     -- Assign static ip to radreply table.                                                                                                  +
     IF par_static_ip_boolean = FALSE THEN                                                                                                   +
         INSERT INTO radreply (username, attribute, op, value, priority)                                                                     +
         VALUES (var_username, 'Class', '=', var_line_id::text, 10);                                                                         +
                                                                                                                                             +
         IF NOT FOUND THEN                                                                                                                   +
             RAISE EXCEPTION 'Radreply Update Failed!';                                                                                      +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Radreply Update Failed!';                                                              +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         END IF;                                                                                                                             +
                                                                                                                                             +
         RAISE NOTICE 'DYNAMIC IP- STATIC IP NOT ASSIGNED';                                                                                  +
     ELSE                                                                                                                                    +
         SELECT *                                                                                                                            +
           INTO var_static_ip                                                                                                                +
           FROM ops_api_static_ip_assign(var_carrier,par_groupname,var_username,var_line_id,par_billing_entity_id);                          +
                                                                                                                                             +
         -- Check if ops_api_static_ip_assign failed!                                                                                        +
         IF substring(var_static_ip from 1 for 3) = 'ERR'                                                                                    +
         THEN                                                                                                                                +
             RAISE EXCEPTION '%', var_static_ip;                                                                                             +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := var_static_ip;                                                                                  +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         ELSE                                                                                                                                +
             RAISE NOTICE 'STATIC IP: %', var_static_ip;                                                                                     +
         END IF;                                                                                                                             +
                                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Get product code from JBilling.                                                                                                      +
     var_sql_2 := '                                                                                                                          +
     SELECT i.internal_number                                                                                                                +
     FROM purchase_order po,                                                                                                                 +
     order_line ol,                                                                                                                          +
     item i,                                                                                                                                 +
     item_type_map itm                                                                                                                       +
     WHERE 1=1                                                                                                                               +
     AND po.public_number = ''' || par_sales_order || '''                                                                                    +
     AND po.id = ol.order_id                                                                                                                 +
     AND ol.item_id = i.id                                                                                                                   +
     AND i.id = itm.item_id                                                                                                                  +
     AND itm.type_id = 301                                                                                                                   +
     AND internal_number LIKE ''MRC%''                                                                                                       +
     LIMIT 1';                                                                                                                               +
                                                                                                                                             +
     IF (par_bypass_jbilling = FALSE) THEN                                                                                                   +
         RAISE NOTICE 'Calling Jbilling to get Product Name (internal number) from item table.';                                             +
                                                                                                                                             +
         SELECT prod_code into v_jbilling_item_code FROM public.dblink(fetch_jbilling_conn(), var_sql_2)                                     +
             AS rec_type (prod_code  text);                                                                                                  +
         v_count := length(v_jbilling_item_code);                                                                                            +
         RAISE NOTICE 'MRC Product Code from Jbilling: % length: %', v_jbilling_item_code, v_count;                                          +
                                                                                                                                             +
         SELECT product_id, plan_type_id, length_days INTO v_product_id, v_plan_type_id, v_length_days                                       +
         FROM csctoss.product                                                                                                                +
         WHERE 1 = 1                                                                                                                         +
         AND product_code LIKE v_jbilling_item_code;                                                                                         +
                                                                                                                                             +
         GET DIAGNOSTICS v_numrows = ROW_COUNT;                                                                                              +
         IF v_numrows = 0 THEN                                                                                                               +
             RAISE EXCEPTION 'ERROR: Product code not present in Product table';                                                             +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Product code not present in Product table';                                            +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         ELSE                                                                                                                                +
             RAISE NOTICE 'Product Info: prod_id: %  plan_type: % length_days: %',v_product_id,v_plan_type_id,v_length_days;                 +
         END IF;                                                                                                                             +
                                                                                                                                             +
         -- Insert csctoss.plan record.                                                                                                      +
         RAISE NOTICE 'Inserting Product Info into plan table';                                                                              +
                                                                                                                                             +
         INSERT INTO plan                                                                                                                    +
         (                                                                                                                                   +
         length_days, plan_type_id, comment , create_timestamp, product_id,                                                                  +
         staff_id, line_id , start_date, end_date , prepaid_unit,                                                                            +
         prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number                                                      +
         )                                                                                                                                   +
         VALUES                                                                                                                              +
         (                                                                                                                                   +
         v_length_days, v_plan_type_id , par_sales_order, current_timestamp, v_product_id,                                                   +
         3, var_line_id , current_date, null,  null,                                                                                         +
         null, null,   current_date,   null                                                                                                  +
         );                                                                                                                                  +
                                                                                                                                             +
         GET DIAGNOSTICS v_numrows = ROW_COUNT;                                                                                              +
         IF v_numrows = 0 THEN                                                                                                               +
             RAISE EXCEPTION 'Error: No rows inserted into plan table.';                                                                     +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  No rows inserted into plan table.';                                                    +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         END IF;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     -- Insert csctoss.equipment_warranty record.                                                                                            +
     RAISE NOTICE 'Inserting Warranty Info into equipment_warranty table';                                                                   +
                                                                                                                                             +
     INSERT INTO equipment_warranty                                                                                                          +
     SELECT                                                                                                                                  +
     var_equipment_id,                                                                                                                       +
     var_line_start_date,                                                                                                                    +
     var_line_start_date + (ewr.num_of_months::text || ' month')::interval                                                                   +
     FROM equipment_warranty_rule ewr                                                                                                        +
     WHERE ewr.equipment_model_id = var_model_id                                                                                             +
     AND NOT EXISTS (SELECT * FROM equipment_warranty ew WHERE ew.equipment_id = var_equipment_id);                                          +
                                                                                                                                             +
     IF (par_bypass_jbilling = FALSE) THEN                                                                                                   +
         -- Connect to jbilling and query the function ops_api_prov_line, for provisioning line.                                             +
         var_sql := 'SELECT * FROM oss.assign_device_jbilling( ' || quote_literal(upper(par_sales_order))                                    +
                 || ' , ' || quote_literal(par_esn_hex) || ' , ' || quote_literal(var_serial_number)||' , '                                  +
                 || quote_literal(var_username) || ' ,' || var_line_id || ')';                                                               +
                                                                                                                                             +
         RAISE NOTICE 'Calling oss.assign_device_jbilling in Jbilling';                                                                      +
         RAISE NOTICE '###  var_sql: %',var_sql;                                                                                             +
                                                                                                                                             +
         SELECT result_code into v_return_2  FROM public.dblink(fetch_jbilling_conn(), var_sql)                                              +
             AS rec_type (result_code boolean);                                                                                              +
                                                                                                                                             +
         IF (v_return_2 = FALSE) THEN                                                                                                        +
             RAISE EXCEPTION 'Jbilling Provisioning Failed.';                                                                                +
             var_return_row.result_code := false;                                                                                            +
             var_return_row.error_message := 'ERROR:  Jbilling Provisioning Failed.';                                                        +
             RETURN NEXT var_return_row;                                                                                                     +
             RETURN;                                                                                                                         +
         ELSE                                                                                                                                +
             RAISE NOTICE 'Jbilling Provisioning Successful.';                                                                               +
         END IF;                                                                                                                             +
     END IF;                                                                                                                                 +
                                                                                                                                             +
     var_return_row.result_code := true;                                                                                                     +
     var_return_row.error_message := 'Line assignment is done succesfully.';                                                                 +
     RETURN NEXT var_return_row;                                                                                                             +
     RETURN;                                                                                                                                 +
                                                                                                                                             +
  END;                                                                                                                                       +
   