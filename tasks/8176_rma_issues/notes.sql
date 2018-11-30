-- One of our customers called this morning on a device that we had shipped 
-- to them using the RMA replacement process. The device we shipped did not 
-- work because it didn't have a static IP address in its radreply. I inserted 
-- one and it started working. We need to understand if the RMA function is 
-- swapping lines but failing to assign static IPs the Verizon replacement 
-- devices (if this is the case, then we are shipping broken lines) I will run 
-- an analysis of radreply data to see if there are other Verizon usernames 
-- with Class IDs that do not have active lines, but please investigate the 
-- RMA function to see what happened.

-- line 46248 because it looks like it does not have a username associated 
-- with the line (the username is 4704217989@vzw3g.com).

select l.line_id                                                         
        ,le.equipment_id
        ,em.model_number1
        ,em.model_number2
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join equipment e on e.equipment_id = le.equipment_id
    join equipment_model em on em.equipment_model_id = e.equipment_model_id
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = '352613070220961';
 line_id | equipment_id | model_number1 | model_number2 |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+---------------+---------------+----------------------+--------------+----------+-----------------
   46133 |        43225 | SL-05-E2-CV1  | SL-05-E2-CV1  | 4706266496@vzw3g.com | 00804413A149 | S11423   | 352613070220961
   46248 |        43225 | SL-05-E2-CV1  | SL-05-E2-CV1  |                      | 00804413A149 | S11423   | 352613070220961
(2 rows)

select * from unique_identifier where equipment_id = 43225;
 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        43225 | ESN DEC                | 89148000003082926309 |       | 2017-11-09   | 
        43225 | ESN HEX                | 352613070220961      |       | 2017-11-09   | 
        43225 | MAC ADDRESS            | 00804413A149         |       | 2017-11-09   | 
        43225 | MDN                    | 4704217989           |       | 2017-11-09   | 
        43225 | MIN                    | 4704217989           |       | 2017-11-09   | 
        43225 | SERIAL NUMBER          | S11423               |       | 2017-11-09   | 
(6 rows)

select * from rma_form where old_esn_hex = '352613070220961';
-[ RECORD 1 ]-----+----------------------------------
id                | 61
name              | jason potter
username          | jpotter@safecashsystems.com
phone_number      | 6152690811
reason_id         | 3
description       | Would not connect (Tullahoma, TN)
create_date       | 2018-03-05 08:23:01+00
address1          | 6136 Cockrill Bend Circle
address2          | 
city              | Nashville
state             | TN
zipcode           | 37209
old_esn_hex       | 352613070220961
email             | jpotter@safecashsystems.com
agreement_id      | 63
new_esn_hex       | 352613070331560
shipping_tracking | 771717178912
return_tracking   | 1Z7X74R90395304107
status            | RESOLVED
freshdesk_id      | 97656

select * from rma_form where new_esn_hex = '352613070220961';
-[ RECORD 1 ]-----+-----------------------
id                | 120
name              | Jamie Meyer
username          | crichardson@cctus.com
phone_number      | 4808615281
reason_id         | 2
description       | s
create_date       | 2018-06-25 17:57:46+00
address1          | 2543 E Camellia Dr
address2          | 
city              | Gilbert
state             | AZ
zipcode           | 85296
old_esn_hex       | A100004394E8B4
email             | skyjlm@cox.net
agreement_id      | 127
new_esn_hex       | 352613070220961
shipping_tracking | NA
return_tracking   | NA
status            | RESOLVED
freshdesk_id      | 111634

--
-- original RMA was for device S11562, however a 2/3G device was mistakenly RMAed onto the line. Which was 993396.  We 
-- caught the mistake and re-RMAed the line, from that device to the S11423 device.
--
-- Freshdesk tickets were 111577 and 99326
--

select * from rma_form where freshdesk_id = 99326;
-[ RECORD 1 ]-----+-----------------------
id                | 75
name              | Jamie Meyer
username          | valleybargames@gmail.com
phone_number      | 4808615281
reason_id         | 2
description       | "yet again for probably the 5th or 6th time in 6 months or less the signal 
                    lights blink on and off and it won't connect.  This has been a recurring 
                    problem that apparently hasn't been fixed because I believe this box is 
                    less than 6 months old but definitely less than a year. Upon finding the 
                    problem, I didn't a reboot as well as holding the reset button and neither 
                    attempt brought the box back up to a working condition"
create_date       | 2018-03-19 11:09:44+00
address1          | 2543 E Camellia Dr
address2          | 
city              | Gilbert
state             | AZ
zipcode           | 85296
old_esn_hex       | A100001578C86D
email             | valleybargames@gmail.com
agreement_id      | 81
new_esn_hex       | 
shipping_tracking | 
return_tracking   | 
status            | RESOLVED
freshdesk_id      | 99326

select * from rma_form where freshdesk_id = 111577;
id                | 117
name              | Jamie Meyer
username          | crichardson@cctus.com
phone_number      | 4808615281
reason_id         | 2
description       | rebooting
create_date       | 2018-06-25 13:10:34+00
address1          | 2543 E Camellia Dr
address2          | 
city              | Gilbert
state             | AZ
zipcode           | 85296
old_esn_hex       | 352613070274588
email             | skyjlm@cox.net
agreement_id      | 124
new_esn_hex       | A100004394E8B4
shipping_tracking | 772557154368
return_tracking   | 1Z7X74R90393474820
status            | RESOLVED
freshdesk_id      | 111577


select * from rma_form where new_esn_hex = '352613070220961';
-[ RECORD 1 ]-----+-----------------------
id                | 120
name              | Jamie Meyer
username          | crichardson@cctus.com
phone_number      | 4808615281
reason_id         | 2
description       | s
create_date       | 2018-06-25 17:57:46+00
address1          | 2543 E Camellia Dr
address2          | 
city              | Gilbert
state             | AZ
zipcode           | 85296
old_esn_hex       | A100004394E8B4
email             | skyjlm@cox.net
agreement_id      | 127
new_esn_hex       | 352613070220961 
shipping_tracking | NA
return_tracking   | NA
status            | RESOLVED
freshdesk_id      | 111634

select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,em.model_number1
        ,em.model_number2
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join equipment e on e.equipment_id = le.equipment_id
    join equipment_model em on em.equipment_model_id = e.equipment_model_id
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = 'A100004394E8B4';


-[ RECORD 1 ]---+---------------------
line_id         | 46248
equipment_id    | 42363
start_date      | 2018-06-25
end_date        | 2018-06-25
model_number1   | SL-05-E2-CVE
model_number2   | SL-05-E2-CVE
radius_username | 
mac             | 008044132072
serialno        | 993396
esn_hex         | A100004394E8B4


-[ RECORD 2 ]---+---------------------
line_id         | 46737
equipment_id    | 42363
start_date      | 2018-05-11
end_date        | 2018-05-15
model_number1   | SL-05-E2-CVE
model_number2   | SL-05-E2-CVE
radius_username | 
mac             | 008044132072
serialno        | 993396
esn_hex         | A100004394E8B4
-[ RECORD 3 ]---+---------------------
line_id         | 44598
equipment_id    | 42363
start_date      | 2017-02-24
end_date        | 2017-12-12
model_number1   | SL-05-E2-CVE
model_number2   | SL-05-E2-CVE
radius_username | 4707174351@vzw3g.com
mac             | 008044132072
serialno        | 993396
esn_hex         | A100004394E8B4

select * from unique_identifier where equipment_id = 42363;
 equipment_id | unique_identifier_type |       value        | notes | date_created | date_modified 
--------------+------------------------+--------------------+-------+--------------+---------------
        42363 | ESN DEC                | 270113184309758900 |       | 2017-02-22   | 
        42363 | ESN HEX                | A100004394E8B4     |       | 2017-02-22   | 
        42363 | MAC ADDRESS            | 008044132072       |       | 2017-02-22   | 
        42363 | MDN                    | 4705229144         |       | 2017-02-22   | 
        42363 | MIN                    | 4705229144         |       | 2017-02-22   | 
        42363 | SERIAL NUMBER          | 993396             |       | 2017-02-22   | 
(6 rows)




BEGIN;

select public.set_change_log_staff_id(3);

UPDATE line
   SET radius_username = '4704217989@vzw3g.com'
      ,end_date = null
 WHERE line_id = 46248;

 COMMIT;

--


 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |      table_name       | primary_key | column_name |           previous_value            
---------------+-------------------------------+---------------+----------+-------------+-----------------------+-------------+-------------+-------------------------------------
       3446663 | 2017-11-09 15:11:01.710332-07 | csctoss_owner |        3 | I           | "csctoss"."usergroup" | 107522      |             | 
       3448354 | 2017-11-10 15:29:27.653126-07 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 107522      | id          | 107522
       3448355 | 2017-11-10 15:29:27.653126-07 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 107522      | username    | 4704217989@vzw3g.com
       3448356 | 2017-11-10 15:29:27.653126-07 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 107522      | groupname   | SERVICE-vzw_inventory
       3448357 | 2017-11-10 15:29:27.653126-07 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 107522      | priority    | 50000
       3448358 | 2017-11-10 15:29:27.653126-07 | csctoss_owner |        3 | I           | "csctoss"."usergroup" | 107645      |             | 
       3525040 | 2018-03-06 10:07:43.999757-07 | postgres      |        3 | U           | "csctoss"."usergroup" | 107645      | groupname   | SERVICE-vzwretail_cnione
       3569891 | 2018-06-25 15:59:48.73363-06  | postgres      |        3 | D           | "csctoss"."usergroup" | 107645      | id          | 107645
       3569892 | 2018-06-25 15:59:48.73363-06  | postgres      |        3 | D           | "csctoss"."usergroup" | 107645      | username    | 4704217989@vzw3g.com
       3569893 | 2018-06-25 15:59:48.73363-06  | postgres      |        3 | D           | "csctoss"."usergroup" | 107645      | groupname   | SERVICE-rma_vzwretail_cnione
       3569894 | 2018-06-25 15:59:48.73363-06  | postgres      |        3 | D           | "csctoss"."usergroup" | 107645      | priority    | 50000
       3569895 | 2018-06-25 15:59:48.73363-06  | postgres      |        3 | I           | "csctoss"."usergroup" | 112485      |             | 
       3577483 | 2018-07-19 16:33:57.051468-06 | csctoss_owner |        3 | I           | "csctoss"."usergroup" | 112927      |             | 
       3578391 | 2018-07-25 15:08:11.242664-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112927      | id          | 112927
       3578392 | 2018-07-25 15:08:11.242664-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112927      | username    | 4704217989@vzw3g.com
       3578393 | 2018-07-25 15:08:11.242664-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112927      | groupname   | SERVICE-vzwretail_wallgarden_cnione
       3578394 | 2018-07-25 15:08:11.242664-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112927      | priority    | 2
       3578395 | 2018-07-25 15:08:16.297364-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112485      | id          | 112485
       3578396 | 2018-07-25 15:08:16.297364-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112485      | username    | 4704217989@vzw3g.com
       3578397 | 2018-07-25 15:08:16.297364-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112485      | groupname   | SERVICE-vzwretail_cnione
       3578398 | 2018-07-25 15:08:16.297364-06 | csctoss_owner |        3 | D           | "csctoss"."usergroup" | 112485      | priority    | 50000
(21 rows)



