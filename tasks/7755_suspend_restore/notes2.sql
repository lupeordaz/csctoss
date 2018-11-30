
I'm not able to cancel two devices.626620 and 627102 - could you please make sure 
these are listed as canceled in our systems?

csctoss=# select l.line_id                                                         
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
   where uis.value = '626620';
-[ RECORD 1 ]---+---------
line_id         | 16628
equipment_id    | 19151
radius_username | 
mac             | 0DE915
serialno        | 626620
esn_hex         | F616F9A2


csctoss=# select * from line where line_id = 16628;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 16628
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
date_created              | 2011-01-13 15:23:59+00
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

jbilling=# select * from prov_line where esn_hex = 'F616F9A2';
-[ RECORD 1 ]---+--------------------
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


jbilling=#  select * from oss.archive_equipment('F616F9A2');
INFO:  var_order_id=20916
ERROR:  JBILLING: Could Not Obtain Active Order Number for order_id: 20916

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
   where uis.value = '627102';
-[ RECORD 1 ]---+---------
line_id         | 16629
equipment_id    | 19414
radius_username | 
mac             | 0DEB26
serialno        | 627102
esn_hex         | F616FA78


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


jbilling=#  select * from oss.archive_equipment('F616FA78');
INFO:  var_order_id=20916
ERROR:  JBILLING: Could Not Obtain Active Order Number for order_id: 20916


select * from purchase_order where id = 20916;
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



