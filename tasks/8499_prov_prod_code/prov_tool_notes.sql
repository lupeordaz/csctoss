

-- Get product code from JBilling.
var_sql_2 := '
SELECT i.internal_number
  FROM purchase_order po
      ,order_line ol
      ,item i
      ,item_type_map itm
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
    var_return_row.result_code := false;
    var_return_row.error_message := 'ERROR:  Product code not present in Product table';
    RETURN NEXT var_return_row;
    RETURN;
ELSE
    RAISE NOTICE 'Product Info: prod_id: %  plan_type: % length_days: %',v_product_id,v_plan_type_id,v_length_days;
END IF;


--


var_sql := 'SELECT * FROM oss.assign_device_jbilling( ' || quote_literal(upper(par_sales_order))
                || ' , ' || quote_literal(par_esn_hex) || ' , ' || quote_literal(var_serial_number)||' , '
                || quote_literal(var_username) || ' ,' || var_line_id || ')';

RAISE NOTICE 'Calling oss.assign_device_jbilling in Jbilling';
RAISE NOTICE '###  var_sql: %',var_sql;

SELECT result_code into v_return_2  
  FROM public.dblink(fetch_jbilling_conn(), var_sql)
    AS rec_type (result_code boolean);

IF (v_return_2 = FALSE) THEN
    RAISE EXCEPTION 'Jbilling Provisioning Failed.';
    var_return_row.result_code := false;
    var_return_row.error_message := 'ERROR:  Jbilling Provisioning Failed.';
    RETURN NEXT var_return_row;
    RETURN;
ELSE
    RAISE NOTICE 'Jbilling Provisioning Successful.';
END IF;


-- csctoss.receiving_log

­-- input parameters
   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;


1. Call Jbilling to get Product Name (internal number) from item table
2. The value is returned into variable v_jbilling_item_code. 
3. Retrieve the product_id, plan_type_id, and length_days fields from
   product WHERE prod_code = v_jbilling_item_code.
4. Insert record into the Plan table, including the par_sales_order.
5. 
 
