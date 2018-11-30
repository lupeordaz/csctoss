BEGIN;

select * from set_change_log_staff_id(3);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4 , 'SO10040', current_timestamp, 132, 3, 47306 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4 , 'SO10040', current_timestamp, 132, 3, 47307 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4 , 'SO10040', current_timestamp, 132, 3, 47308 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4 , 'SO-test', current_timestamp, 132, 3, 47309 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100356', current_timestamp, 156, 3, 47310 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100356', current_timestamp, 156, 3, 47311 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100356', current_timestamp, 156, 3, 47312 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100358', current_timestamp, 33, 3, 47313 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100359', current_timestamp, 132, 3, 47315 , current_date, null,  null, null, null, current_date, null);

INSERT INTO plan
( length_days, plan_type_id, comment , create_timestamp, product_id, staff_id, line_id , start_date, end_date , prepaid_unit, 
  prepaid_allowance, prepaid_balance, accounting_start_date , sales_order_number)
VALUES
( 1000000, 4, 'SO100360', current_timestamp, 33, 3, 47316 , current_date, null,  null, null, null, current_date, null);
