

jbilling=# select * from oss.archive_equipment('F616FA78');
INFO:  var_order_id=20916
ERROR:  JBILLING: Could Not Obtain Active Order Number for order_id: 20916


jbilling=# 
jbilling=# select * from order_line where order_id = 20916;
-[ RECORD 1 ]-----------+---------------------------------------------------
id                      | 24245
order_id                | 20916
item_id                 | 716
type_id                 | 1
amount                  | 670.0000000000
quantity                | 2.0000000000
price                   | 335.0000000000
item_price              | 
create_datetime         | 2011-01-13 11:35:59.781
deleted                 | 1
description             | Cellular Payment Gateway Router
provisioning_status     | 20
provisioning_request_id | 
optlock                 | 2
provisioning_count      | 
-[ RECORD 2 ]-----------+---------------------------------------------------
id                      | 24246
order_id                | 20916
item_id                 | 708
type_id                 | 1
amount                  | 15.0000000000
quantity                | 2.0000000000
price                   | 7.5000000000
item_price              | 
create_datetime         | 2011-01-13 11:35:59.796
deleted                 | 1
description             | 5MB 1X Pooled, Monthly Recurring, $2.75/MB Overage
provisioning_status     | 20
provisioning_request_id | 
optlock                 | 2
provisioning_count      | 2
-[ RECORD 3 ]-----------+---------------------------------------------------
id                      | 24247
order_id                | 20916
item_id                 | 1
type_id                 | 2
amount                  | 46.9000000000
quantity                | 0.0000000000
price                   | 7.0000000000
item_price              | 
create_datetime         | 2011-01-13 11:35:59.812
deleted                 | 1
description             | Sales Tax (7.0%)
provisioning_status     | 20
provisioning_request_id | 
optlock                 | 2
provisioning_count      | 
-[ RECORD 4 ]-----------+---------------------------------------------------
id                      | 24248
order_id                | 20916
item_id                 | 4
type_id                 | 2
amount                  | 0.0000000000
quantity                | 0.0000000000
price                   | 0.0000000000
item_price              | 
create_datetime         | 2011-01-13 11:35:59.827
deleted                 | 1
description             | Monthly Telcom Tax (0.0%)
provisioning_status     | 20
provisioning_request_id | 
optlock                 | 2
provisioning_count      | 


jbilling=# select * from prov_line where esn_hex = 'F616FA78';
-[ RECORD 1 ]---+--------------------
id              | 53005
order_id        | 20916
item_id         | 708
line_id         | 16629
esn_hex         | F616FA78
username        | 3126712634@uscc.net
start_date      | 2011-01-13
end_date        | 
optlock         | 4
acct_start_date | 2011-02-02
archived        | 
renewed_id      | 
sn              | 627102
archived_date   | 
archived_reason | 

--

csctoss=# select * from line where line_id = 16629;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 16629
calling_station_id        | 
line_assignment_type      | CUSTOMER ASSIGNED
billing_entity_id         | 325
logical_apn               | 
disabled_apn              | 
contact_id                | 
order_id                  | 
employee_id               | 
billing_entity_address_id | 788
active_flag               | t
line_label                | 
start_date                | 2011-01-13 00:00:00+00
end_date                  | 2018-07-23 00:00:00+00
date_created              | 2011-01-13 15:24:01+00
radius_username           | 
radius_password           | 
radius_auth_type          | 
static_ip_address         | 
ip_pool                   | 
proxy_access              | 
session_timeout_seconds   | 
idle_timeout_seconds      | 
primary_dns               | 
secondary_dns             | 
current_plan_id           | 
previous_line_id          | 
notes                     | SO-2233A
additional_info           | 


---

jbilling=# SELECT order_id 
  FROM prov_line
  WHERE end_date IS NULL
  AND archived IS NULL
  AND start_date IS NOT NULL
  --AND acct_start_date IS NOT NULL
  AND esn_hex = 'F616FA78'
  LIMIT 1;
 order_id 
----------
    20916
(1 row)

jbilling=# select * from purchase_order where id = 20916;
-[ RECORD 1 ]------+------------------------
id                 | 20916
user_id            | 722
period_id          | 1
billing_type_id    | 2
active_since       | 2011-01-01
active_until       | 
cycle_start        | 2011-01-01
create_datetime    | 2011-01-13 11:36:04.429
next_billable_day  | 
created_by         | 1010
status_id          | 17
currency_id        | 1
deleted            | 0
notify             | 0
last_notified      | 
notification_step  | 
due_date_unit_id   | 3
due_date_value     | 
df_fm              | 0
anticipate_periods | 
own_invoice        | 0
notes              | 
notes_in_invoice   | 0
is_current         | 0
use_static         | 0
use_privatenetwork | 1
include_sales_tax  | 1
include_comm_tax   | 0
shipping_method    | UPS Ground
processor          | Columbus Data Systems
public_number      | SO-2233A
optlock            | 156
tracking_num       | 
oss_synced         | 1
renewal            | 
shipping_cost      | 


jbilling=# select * from prov_line where order_id = 20916;
-[ RECORD 1 ]---+--------------------
id              | 53005
order_id        | 20916
item_id         | 708
line_id         | 16629
esn_hex         | F616FA78
username        | 3126712634@uscc.net
start_date      | 2011-01-13
end_date        | 
optlock         | 4
acct_start_date | 2011-02-02
archived        | 
renewed_id      | 
sn              | 627102
archived_date   | 
archived_reason | 
-[ RECORD 2 ]---+--------------------
id              | 53004
order_id        | 20916
item_id         | 708
line_id         | 16628
esn_hex         | F616F9A2
username        | 3126712171@uscc.net
start_date      | 2011-01-13
end_date        | 
optlock         | 4
acct_start_date | 2011-01-23
archived        | 
renewed_id      | 
sn              | 626620
archived_date   | 
archived_reason | 

jbilling=# select * from audit.logged_actions where table_name = 'purchase_order' and new_data like '%20916%';
-[ RECORD 1 ]-+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
schema_name   | public
table_name    | purchase_order
user_name     | postgres
action_tstamp | 2015-10-16 18:40:27.99948-06
action        | U
original_data | (20916,722,2,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,1,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,153,"",,,)
new_data      | (20916,722,2,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,153,"",,,)
query         | UPDATE purchase_order SET deleted = 0 where id = 20916;
-[ RECORD 2 ]-+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
schema_name   | public
table_name    | purchase_order
user_name     | jbilling
action_tstamp | 2015-10-16 19:00:00.035194-06
action        | U
original_data | (20916,722,2,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,153,"",,,)
new_data      | (20916,722,2,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,154,"",1,,)
query         | /* update com.sapienter.jbilling.server.order.db.OrderDTO */ update purchase_order set oss_synced=$1, active_since=$2, active_until=$3, anticipate_periods=$4, created_by=$5, user_id=$6, create_datetime=$7, currency_id=$8, cycle_start=$9, deleted=$10, df_fm=$11, due_date_unit_id=$12, due_date_value=$13, include_comm_tax=$14, include_sales_tax=$15, is_current=$16, last_notified=$17, next_billable_day=$18, notes=$19, notes_in_invoice=$20, notification_step=$21, notify=$22, billing_type_id=$23, period_id=$24, status_id=$25, own_invoice=$26, processor=$27, public_number=$28, renewal=$29, shipping_cost=$30, shipping_method=$31, tracking_num=$32, use_privatenetwork=$33, use_static=$34, OPTLOCK=$35 where id=$36 and OPTLOCK=$37
-[ RECORD 3 ]-+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
schema_name   | public
table_name    | purchase_order
user_name     | jbilling
action_tstamp | 2015-10-27 04:21:45.322198-06
action        | U
original_data | (20916,722,2,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,154,"",1,,)
new_data      | (20916,722,1,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,155,"",1,,)
query         | /* update com.sapienter.jbilling.server.order.db.OrderDTO */ update purchase_order set oss_synced=$1, active_since=$2, active_until=$3, anticipate_periods=$4, created_by=$5, user_id=$6, create_datetime=$7, currency_id=$8, cycle_start=$9, deleted=$10, df_fm=$11, due_date_unit_id=$12, due_date_value=$13, include_comm_tax=$14, include_sales_tax=$15, is_current=$16, last_notified=$17, next_billable_day=$18, notes=$19, notes_in_invoice=$20, notification_step=$21, notify=$22, billing_type_id=$23, period_id=$24, status_id=$25, own_invoice=$26, processor=$27, public_number=$28, renewal=$29, shipping_cost=$30, shipping_method=$31, tracking_num=$32, use_privatenetwork=$33, use_static=$34, OPTLOCK=$35 where id=$36 and OPTLOCK=$37
-[ RECORD 4 ]-+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
schema_name   | public
table_name    | purchase_order
user_name     | jbilling
action_tstamp | 2015-11-25 11:17:26.726791-07
action        | U
original_data | (20916,722,1,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,16,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,155,"",1,,)
new_data      | (20916,722,1,2,2011-01-01,,2011-01-01,"2011-01-13 11:36:04.429",,1010,17,1,0,0,,,3,,0,,0,"",0,0,0,1,1,0,"UPS Ground","Columbus Data Systems",SO-2233A,156,"",1,,)
query         | /* update com.sapienter.jbilling.server.order.db.OrderDTO */ update purchase_order set oss_synced=$1, active_since=$2, active_until=$3, anticipate_periods=$4, created_by=$5, user_id=$6, create_datetime=$7, currency_id=$8, cycle_start=$9, deleted=$10, df_fm=$11, due_date_unit_id=$12, due_date_value=$13, include_comm_tax=$14, include_sales_tax=$15, is_current=$16, last_notified=$17, next_billable_day=$18, notes=$19, notes_in_invoice=$20, notification_step=$21, notify=$22, billing_type_id=$23, period_id=$24, status_id=$25, own_invoice=$26, processor=$27, public_number=$28, renewal=$29, shipping_cost=$30, shipping_method=$31, tracking_num=$32, use_privatenetwork=$33, use_static=$34, OPTLOCK=$35 where id=$36 and OPTLOCK=$37


