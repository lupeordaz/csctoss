
csctoss=# \x
Expanded display is on.
csctoss=# select * from billing_entity where name = 'ARCA';
-[ RECORD 1 ]------------+-------------
billing_entity_id        | 793
parent_billing_entity_id | 
name                     | ARCA
phone_number1            | 919 442 2536
phone_number2            | 
fax_number1              | 
fax_number2              | 
url                      | 
preferred_timezone       | EDT
billing_entity_type      | UNKNOWN
opt_in_flag              | f

csctoss=# select * from groupname where billing_entity_id = 793;
ERROR:  column "billing_entity_id" does not exist
csctoss=# select * from groupname_default where billing_entity_id = 793;
-[ RECORD 1 ]------------+-------------------------
groupname_default_key_id | 4
groupname                | SERVICE-vzwretail_cnione
carrier                  | VZW
billing_entity_id        | 793


BEGIN;

select public.set_change_log_staff_id(3);

UPDATE static_ip_pool 
   SET billing_entity_id = 793
      ,groupname = 'SERVICE-vzwretail_cnione'
 WHERE STATIC_IP LIKE '10.81.156.%';

UPDATE static_ip_pool 
   SET billing_entity_id = 793
      ,groupname = 'SERVICE-vzwretail_cnione'
 WHERE STATIC_IP LIKE '10.81.157.%';

UPDATE static_ip_pool 
   SET billing_entity_id = 793
      ,groupname = 'SERVICE-vzwretail_cnione'
 WHERE STATIC_IP LIKE '10.81.158.%';

UPDATE static_ip_pool 
   SET billing_entity_id = 793
      ,groupname = 'SERVICE-vzwretail_cnione'
 WHERE STATIC_IP LIKE '10.81.159.%';




UPDATE static_ip_pool 
   SET carrier_id = 3
 WHERE STATIC_IP LIKE '10.81.156.%';

--

Updates complete.

csctoss=# BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
-[ RECORD 1 ]-----------+---
set_change_log_staff_id | -1

csctoss=#  UPDATE static_ip_pool 
csctoss-#    SET billing_entity_id = 793
csctoss-#       ,groupname = 'SERVICE-vzwretail_cnione'
csctoss-#  WHERE STATIC_IP LIKE '10.81.156.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
csctoss-#    SET billing_entity_id = 793
csctoss-#       ,groupname = 'SERVICE-vzwretail_cnione'
csctoss-#  WHERE STATIC_IP LIKE '10.81.157.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
csctoss-#    SET billing_entity_id = 793
csctoss-#       ,groupname = 'SERVICE-vzwretail_cnione'
csctoss-#  WHERE STATIC_IP LIKE '10.81.158.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
csctoss-#    SET billing_entity_id = 793
csctoss-#       ,groupname = 'SERVICE-vzwretail_cnione'
csctoss-#  WHERE STATIC_IP LIKE '10.81.159.%';
UPDATE 254
csctoss=# commit;
COMMIT
csctoss=# 


select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# UPDATE static_ip_pool 
csctoss-#    SET carrier_id = 3
csctoss-#  WHERE STATIC_IP LIKE '10.81.156.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
   SET carrier_id = 3
 WHERE STATIC_IP LIKE '10.81.157.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
   SET carrier_id = 3
 WHERE STATIC_IP LIKE '10.81.158.%';
UPDATE 254
csctoss=# UPDATE static_ip_pool 
   SET carrier_id = 3
 WHERE STATIC_IP LIKE '10.81.159.%';
UPDATE 254
csctoss=# commit;
COMMIT

