--Activate

par_esn_hex                 text    := $1;
par_esn_dec                 text    := $2;
par_mdn                     text    := $3;
par_min                     text    := $4;
par_serial_number           text    := $5;
par_mac_address             text    := $6;
par_equipment_model_id      integer := $7;
par_realm                   text    := $8;
par_carrier                 text    := $9;

select substring(un.username,12) as realm
      ,em.model_number1 as equipment_model
      ,uie.value as esn_hex
      ,uid.value as esn_dec
      ,uim.value as mac
      ,uis.value as serialno
      ,uimd.value as esn_mdn
      ,uimn.value as esn_min
  from equipment e
  join equipment_model em on em.equipment_model_id = e.equipment_model_id
  join unique_identifier uie on e.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uid on e.equipment_id = uid.equipment_id and uid.unique_identifier_type = 'ESN DEC'
  join unique_identifier uimd on e.equipment_id = uimd.equipment_id and uimd.unique_identifier_type = 'MDN'
  join unique_identifier uimn on e.equipment_id = uimn.equipment_id and uimn.unique_identifier_type = 'MIN'
  join unique_identifier uis on e.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
  join unique_identifier uim on e.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join username un on substring(un.username,1,10) = uimd.value
 where uie.value IN (
'353238060066833',
'352613070205467',
'352613070405257',
'352613070387877',
'352613070386408',
'352613070412733',
'352613070407865',
'A100004394DAB3 ',
'352613070386879',
'352613070190859',
'352613070283910',
'352613070385566',
'353238060191136',
'352613070383264',
'352613070418441',
'352613070382894',
'352613070411180',
'352613070386846',
'F616FCA8',
'F6158B75')
ORDER BY 1;


   realm    | equipment_model |     esn_hex     |       esn_dec        |     mac      | serialno |  esn_mdn   |  esn_min   
------------+-----------------+-----------------+----------------------+--------------+----------+------------+------------
 vzw3g.com  | SL-05-E2-CV1    | 352613070190859 | 89148000004530252413 | 00804413AD5E | S08956   | 4708291870 | 4708291870
* vzw3g.com  | SL-05-E2-CV1    | 352613070205467 | 89148000004530252454 | 00804413AD4A | S08959   | 4708291866 | 4708291866
 vzw3g.com  | SL-05-E2-CV1    | 352613070283910 | 89148000004530252397 | 00804413ACF8 | S08975   | 4708291872 | 4708291872

* vzw3g.com  | SL-05-E2-CV1    | 352613070382894 | 89148000004530258105 | 00804412EC97 | S22515   | 4705724375 | 4705724375

 vzw3g.com  | SL-05-E2-CV1    | 352613070383264 | 89148000004530258089 | 00804412ECA3 | S22524   | 4705831029 | 4705831029
* vzw3g.com  | SL-08-P-CV1     | 352613070385566 | 89148000004530258055 | 0080441306A7 | A18740   | 4708290267 | 4708290267
 vzw3g.com  | SL-05-E2-CV1    | 352613070386408 | 89148000004530258154 | 00804412ECAB | S22514   | 4704641643 | 4704641643
* vzw3g.com  | SL-05-E2-CV1    | 352613070386846 | 89148000004530258121 | 00804412EC90 | S22504   | 4705325800 | 4705325800
* vzw3g.com  | SL-08-P-CV1     | 352613070386879 | 89148000004530257982 | 00804413069E | A18727   | 4708290319 | 4708290319
 vzw3g.com  | SL-05-E2-CV1    | 352613070387877 | 89148000004530258147 | 00804412ECAF | S22506   | 4705320904 | 4705320904
 vzw3g.com  | SL-05-E2-CV1    | 352613070405257 | 89148000004530258139 | 00804412ECA2 | S22526   | 4705325009 | 4705325009

 vzw3g.com  | SL-05-E2-CV1    | 352613070407865 | 89148000004530258170 | 00804412ECA0 | S22527   | 4704461063 | 4704461063
 vzw3g.com  | SL-05-E2-CV1    | 352613070411180 | 89148000004530258113 | 00804412EC9E | S22523   | 4705721694 | 4705721694
 vzw3g.com  | SL-05-E2-CV1    | 352613070412733 | 89148000004530258162 | 00804412EC81 | S22499   | 4704461084 | 4704461084
 vzw3g.com  | SL-05-E2-CV1    | 352613070418441 | 89148000004530258097 | 00804412ECB0 | S22517   | 4705830534 | 4705830534
* vzw3g.com  | WR11-L800       | 353238060066833 | 89148000004530249609 | 00042D06673B | 419643   | 4708082947 | 4708082947
 vzw3g.com  | WR11-L800       | 353238060191136 | 89148000004023158812 | 00042D066813 | 419859   | 4708082965 | 4708082965
 uscc.net   | Systech 7310    | F6158B75        | 24601411957          | 0DE3FB       | 642209   | 3123887029 | 3123887029
(18 rows)


*vzw3g.com  | SL-05-E2-CV1    | 352613070190859,89148000004530252413,00804413AD5E,S08956,4708291870,4708291870
vzw3g.com  | SL-05-E2-CV1    | 352613070283910,89148000004530252397,00804413ACF8,S08975,4708291872,4708291872

*vzw3g.com  | SL-05-E2-CV1    | 352613070382894,89148000004530258105,00804412EC97,S22515,4705724375,4705724375

vzw3g.com  | SL-05-E2-CV1    | 352613070383264,89148000004530258089,00804412ECA3,S22524,4705831029,4705831029
vzw3g.com  | SL-05-E2-CV1    | 352613070386408,89148000004530258154,00804412ECAB,S22514,4704641643,4704641643
vzw3g.com  | SL-05-E2-CV1    | 352613070386846,89148000004530258121,00804412EC90,S22504,4705325800,4705325800
*vzw3g.com  | SL-08-P-CV1     | 352613070386879,89148000004530257982,00804413069E,A18727,4708290319,4708290319
vzw3g.com  | SL-05-E2-CV1    | 352613070387877,89148000004530258147,00804412ECAF,S22506,4705320904,4705320904
vzw3g.com  | SL-05-E2-CV1    | 352613070405257,89148000004530258139,00804412ECA2,S22526,4705325009,4705325009
vzw3g.com  | SL-05-E2-CV1    | 352613070407865,89148000004530258170,00804412ECA0,S22527,4704461063,4704461063
*vzw3g.com  | SL-05-E2-CV1    | 352613070411180,89148000004530258113,00804412EC9E,S22523,4705721694,4705721694
vzw3g.com  | SL-05-E2-CV1    | 352613070412733,89148000004530258162,00804412EC81,S22499,4704461084,4704461084
vzw3g.com  | SL-05-E2-CV1    | 352613070418441,89148000004530258097,00804412ECB0,S22517,4705830534,4705830534
vzw3g.com  | WR11-L800       | 353238060191136,89148000004023158812,00042D066813,419859,4708082965,4708082965



 uscc.net   | Systech 7310    | F6158B75        | 24601411957          | 0DE3FB       | 642209   | 3123887029 | 3123887029



vzw3g.com  | SL-05-E2-CV1    | 352613070190859,89148000004530252413,00804413AD5E,S08956,4708291870,4708291870



--

./api_assign.sh 352613070205467 SO-12502 577 SERVICE-vzwretail_cnione TRUE 132 FALSE
./api_assign.sh 353238060066833 SO-12503 699 SERVICE-vzwretail_cnione true 156 true
./api_assign.sh 352613070385566 SO-12504 577 SERVICE-vzwretail_cnione true 132 true

352613070205467,89148000004530252454,00804413AD4A,S08959,4708291866,4708291866

-- Assign

par_esn_hex                        text := $1;
par_sales_order                    text := $2;
par_billing_entity_id              integer := $3;
par_groupname                      text := $4;
par_static_ip_boolean              boolean := $5;
par_product_code                   text := $6;
par_bypass_jbilling                boolean := $7;


select uie.value as esn_hex
      ,l.notes as sales_order
      ,l.billing_entity_id as beid
      ,ug.groupname as groupname
      ,TRUE as static_ip_boolean
      ,pr.product_code
      ,TRUE as bypass_jbilling
  from line_equipment le
  join line l on l.line_id = le.line_id
  join plan pl on pl.line_id = l.line_id
  join product pr on pr.product_id = pl.product_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uimd on le.equipment_id = uimd.equipment_id and uimd.unique_identifier_type = 'MDN'
  join usergroup ug on l.radius_username = ug.username
 where uie.value IN (
'353238060066833',
'352613070205467',
'352613070405257',
'352613070387877',
'352613070386408',
'352613070412733',
'352613070407865',
'A100004394DAB3 ',
'352613070386879',
'352613070190859',
'352613070283910',
'352613070385566',
'353238060191136',
'352613070383264',
'352613070418441',
'352613070382894',
'352613070411180',
'352613070386846',
'F616FCA8',
'F6158B75');

     esn_hex     | sales_order | beid | Billing Entity Name      |        groupname         | static_ip_boolean |     product_code     | bypass_jbilling 
-----------------+-------------+------+--------------------------+-------------------+----------------------+-----------------
 352613070205467 | SO-12502    |  577 | ACFN                     | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070385566 | SO-12504    |  577 | ACFN                     | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070190859 | SO-12506    |  577 | ACFN                     | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070386879 | SO-12507    |  577 | ACFN                     | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 353238060066833 | SO-12503    |  699 | Fiserv Cash and Logistics| SERVICE-vzwretail_cnione | t                 | MRC-CNI-SS-M-0-N-0-3 | t
 F6158B75        | SO-12505    |  863 |                          | SERVICE-private_atm      | t                 | MRC-005-01RP-1XU     | t
 F616FCA8        | SO-12505    |  863 |                          | SERVICE-private_atm      | t                 | MRC-005-01RP-1XU     | t
 352613070407865 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070412733 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070386408 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070387877 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070405257 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t

 352613070386846 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t

 352613070411180 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070382894 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t








 352613070418441 | SO-12509    |  334 | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 352613070383264 | SO-12509    |  334 | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
 353238060191136 | SO-12510    |  771 | SERVICE-vzwretail_cnione | t                 | MRC-CYE1-M-0-N-0-3   | t
 352613070283910 | SO-12511    |  577 | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t
(19 rows)

../8874_call_assign/api_assign.sh 352613070205467 SO-12502 577 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 353238060066833 SO-12503 699 SERVICE-vzwretail_cnione true MRC-CNI-SS-M-0-N-0-3 true
../8874_call_assign/api_assign.sh 352613070385566 SO-12504 577 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
*../8874_call_assign/api_assign.sh 352613070190859 SO-12506 577 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
par_esn_hex                        352613070386879 
par_sales_order                    SO-12507 
par_billing_entity_id              577 
par_groupname                      SERVICE-vzwretail_cnione 
par_static_ip_boolean              true 
par_product_code                   MRC-005-01RP-EVV 
par_bypass_jbilling                true
*../8874_call_assign/api_assign.sh 352613070386879 SO-12507 577 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true

../8874_call_assign/api_assign.sh 352613070407865 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070412733 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070386408 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070387877 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070405257 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070386846 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
*../8874_call_assign/api_assign.sh 352613070411180 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070382894 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070418441 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 352613070383264 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true
../8874_call_assign/api_assign.sh 353238060191136 SO-12510 771 SERVICE-vzwretail_cnione true MRC-CYE1-M-0-N-0-3   true
../8874_call_assign/api_assign.sh 352613070283910 SO-12511 577 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV     true
 F6158B75        | SO-12505    |  863 | SERVICE-private_atm      | t                 | MRC-005-01RP-1XU     | t
 F616FCA8        | SO-12505    |  863 | SERVICE-private_atm      | t                 | MRC-005-01RP-1XU     | t


par_esn_hex                        352613070412733 
par_sales_order                    SO-12509 
par_billing_entity_id              334 
par_groupname                      SERVICE-vzwretail_cnione 
par_static_ip_boolean              true 
par_product_code                   MRC-005-01RP-EVV 
par_bypass_jbilling                true
./api_assign.sh 352613070412733 SO-12509 334 SERVICE-vzwretail_cnione true MRC-005-01RP-EVV true





insert_update_location_labels.sql
ops_api_activate.sql
ops_api_assign.sql
ops_api_expire.sql
ops_api_modify.sql
ops_api_restore.sql
ops_api_suspend.sql
ops_change_static_ip.sql
update_unique_identifier_value.sql

--


    par_esn_hex                        text := $1;
    par_sales_order                    text := $2;
    par_billing_entity_id              integer := $3;
    par_groupname                      text := $4;
    par_static_ip_boolean              boolean := $5;
    par_product_code                   text := $6;
    par_bypass_jbilling                boolean := $7;


select * from ops_api_assign('352613070386846','SO-12509',334,'SERVICE-vzwretail_cnione',t,'MRC-005-01RP-EVV',t);

--

     esn_hex     | sales_order | beid | Billing Entity Name      |        groupname         | static_ip_boolean |     product_code     | bypass_jbilling 
-----------------+-------------+------+--------------------------+-------------------+----------------------+-----------------
 352613070382894 | SO-12509    |  334 | Equity Cash Systems      | SERVICE-vzwretail_cnione | t                 | MRC-005-01RP-EVV     | t


SELECT product_id, plan_type_id, length_days 
    FROM csctoss.product
    WHERE 1 = 1
    AND product_code = 'MRC-005-01RP-EVV';
 product_id | plan_type_id | length_days 
------------+--------------+-------------
        132 |            4 |     1000000
(1 row)


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


SELECT product_id, plan_type_id, length_days 
    FROM csctoss.product
    WHERE 1 = 1
    AND product_code = 'MRC-CNI-SS-M-0-N-0-3';
 product_id | plan_type_id | length_days 
------------+--------------+-------------
        156 |            4 |     1000000
(1 row)

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


SELECT product_id, plan_type_id, length_days 
    FROM csctoss.product
    WHERE 1 = 1
    AND product_code = 'MRC-005-01RP-1XU';
 product_id | plan_type_id | length_days 
------------+--------------+-------------
         33 |            4 |     1000000
(1 row)

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


SELECT product_id, plan_type_id, length_days 
    FROM csctoss.product
    WHERE 1 = 1
    AND product_code = 'MRC-005-01RP-EVV';
 product_id | plan_type_id | length_days 
------------+--------------+-------------
        132 |            4 |     1000000
(1 row)




INSERT INTO plan
VALUES
(
1000000, 4 , 'SO-12509', current_timestamp, 132, 
3, var_line_id , current_date, null,  null,
null, null,   current_date,   null  
);



