    par_esn_hex                        353238060033858
    par_sales_order                    text := $2;
    par_billing_entity_id              integer := $3;
    par_groupname                      SERVICE-vzwretail_cnione
    par_static_ip_boolean              boolean := $5;
    par_product_code                   text := $6;
    par_bypass_jbilling                boolean := $7;

--
ERROR: Start date cannot be later than end date  
          WHERE: SQL statement 
            "UPDATE line_equipment SET end_date = current_date -1
              WHERE equipment_id = $1 
                AND end_date = current_date" 
      PL/pgSQL function "ops_api_assign" line 209 at SQL statement
        SQL statement 
          "SELECT * from ops_api_assign($1,$2,$3,$4,$5,null,FALSE)" 
      PL/pgSQL function "ops_api_assign" line 4 at select into variables
--

select l.line_id                                                         
      ,le.equipment_id
      ,l.radius_username
      ,uim.value as mac
      ,uis.value as serialno
      ,uie.value as esn_hex
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uie.value = '353238060033858';
 line_id | equipment_id | radius_username |     mac      | serialno |     esn_hex     
---------+--------------+-----------------+--------------+----------+-----------------
   45578 |        42979 |                 | 00042D066BBB | S420795  | 353238060033858
   46887 |        42979 |                 | 00042D066BBB | S420795  | 353238060033858
   47238 |        42979 |                 | 00042D066BBB | S420795  | 353238060033858
(3 rows)



csctoss=# select * from line_equipment where equipment_id = 42979;
 line_id | equipment_id | start_date |  end_date  | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+------------+---------------------------+-----------+--------------+--------------
   45578 |        42979 | 2017-08-19 | 2018-06-14 |                       444 |           |              | 
   46887 |        42979 | 2018-06-15 |            |                       444 |           |              | 
(2 rows)


csctoss=# select * from line_equipment where line_id = 46887;
 line_id | equipment_id | start_date | end_date | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+----------+---------------------------+-----------+--------------+--------------
   46887 |        42979 | 2018-06-15 |          |                       444 |           |              | 
(1 row)


csctoss=# select * from line where line_id = 46887;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 46887
calling_station_id        | 
line_assignment_type      | CUSTOMER ASSIGNED
billing_entity_id         | 396
logical_apn               | 
disabled_apn              | 
contact_id                | 
order_id                  | 
employee_id               | 

-- Ended line 46887 today; code sets end date to yesterday.
-- Cancelled line 47238 today.  Tried provisioning 

select * from ops_api_expire('353238060033858')