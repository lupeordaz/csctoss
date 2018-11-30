--
-- Name: ops_api_assign(text, text, integer, text, boolean); Type: FUNCTION; Schema: csctoss; Owner: csctoss_owner
--
CREATE OR REPLACE FUNCTION ops_api_assign(text, text, integer, text, boolean)
  RETURNS SETOF ops_api_assign_retval AS
$BODY$
DECLARE
    var_return_row                     ops_api_assign_retval%ROWTYPE;
BEGIN
    select * INTO var_return_row from ops_api_assign($1, $2, $3, $4, $5, null, FALSE);
    RETURN NEXT var_return_row;
    RETURN;

END;  
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION ops_api_assign(text, text, integer, text, boolean)
  OWNER TO csctoss_owner;


--

CREATE OR REPLACE FUNCTION ops_api_assign(text, text, integer, text, boolean, text)
  RETURNS SETOF ops_api_assign_retval AS
$BODY$
DECLARE
    var_return_row                     ops_api_assign_retval%ROWTYPE;
BEGIN
    select * INTO var_return_row from ops_api_assign($1, $2, $3, $4, $5, $6, FALSE);
    RETURN NEXT var_return_row;
    RETURN;

END;  
$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION ops_api_assign(text, text, integer, text, boolean, text)
  OWNER TO csctoss_owner;



CREATE OR REPLACE FUNCTION ops_api_assign(text, text, integer, text, boolean, text, boolean) 
  RETURNS SETOF ops_api_assign_retval
    LANGUAGE plpgsql
    AS $_$
DECLARE
    par_esn_hex                        text := $1;
    par_sales_order                    text := $2;
    par_billing_entity_id              integer := $3;
    par_groupname                      text := $4;
    par_static_ip_boolean              boolean := $5;
    par_product_code                   text := $6
    par_bypass_jbilling                boolean := $7;
    var_equipment_id                   integer;
    var_line_id                        integer;
    var_mdn                            text;
    var_mdn_min                        text;
    var_username                       text;
    var_billing_entity_address_id      integer;

.
.
.


    IF (par_bypass_jbilling = FALSE) THEN
        IF (par_product_code is not null) THEN
            SELECT product_id, plan_type_id, length_days INTO v_product_id, v_plan_type_id, v_length_days
            FROM csctoss.product
            WHERE 1 = 1
            AND product_code = par_product_code;
            GET DIAGNOSTICS v_numrows = ROW_COUNT;
            IF v_numrows = 0 THEN
                RAISE EXCEPTION 'ERROR: Invalid Product code';
                var_return_row.result_code := false;
                var_return_row.error_message := 'ERROR:  Invalid Product code not present in Product table';
                RETURN NEXT var_return_row;
                RETURN;
            ELSE
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
                    var_return_row.result_code := false;
                    var_return_row.error_message := 'ERROR:  No rows inserted into plan table.';
                    RETURN NEXT var_return_row;
                    RETURN;
                END IF;
            END IF;
        ELSE
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
                var_return_row.result_code := false;
                var_return_row.error_message := 'ERROR:  Product code not present in Product table';
                RETURN NEXT var_return_row;
                RETURN;
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
                var_return_row.result_code := false;
                var_return_row.error_message := 'ERROR:  No rows inserted into plan table.';
                RETURN NEXT var_return_row;
                RETURN;
            END IF;
        END IF;
    END IF;

    IF (par_bypass_jbilling = FALSE) THEN
        IF (par_product_code is null) THEN
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
                var_return_row.result_code := false;
                var_return_row.error_message := 'ERROR:  Jbilling Provisioning Failed.';
                RETURN NEXT var_return_row;
                RETURN;
            ELSE
                RAISE NOTICE 'Jbilling Provisioning Successful.';
            END IF;
        END IF;
    END IF;

--


SELECT line.line_id           AS line_id
      ,cust.user_id           AS jbill_customer_id,
      ,cust.external_id       AS jbill_external_id_customer
      ,cont.organization_name AS jbill_organization_name,
      ,po.public_number       AS jbill_so_number,
  FROM line
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,pl.sn AS sn
                                      ,po.public_number AS public_number
                                      ,po.status_id AS status_id
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                  JOIN customer cust ON (po.user_id = cust.user_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, sn text, public_number text, status_id int, customer text)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   AND line.end_date IS NULL
   AND line.notes <> jbill.public_number
 ORDER BY line.line_id;



