
Original Equipment:
Model:VODAFONE SIM
ESN :89314404000148029870
S/N :89314404000148029870
Tracking #: n/a

New Equipment:
Model:Systech 8110EVE
ESN :89314404000148030134
S/N :89314404000148030134
Tracking # :773214615186



in_old_esn              89314404000148029870
in_new_esn              89314404000148030134
in_new_usergroup        text:=$3;
in_beid                 integer:=$4;
in_static_ip            boolean:=$5;
in_sales_order          text:=$6;


SELECT * FROM rt_oss_rma(89314404000148029870,89314404000148030134,384792, TRUE);



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
   where uie.value = '89314404000148029870';

 line_id | equipment_id |           radius_username            |         mac          |       serialno       |       esn_hex        
---------+--------------+--------------------------------------+----------------------+----------------------+----------------------
   45389 |        42931 | 882393256289441@m2m01.contournet.net | 89314404000148029870 | 89314404000148029870 | 89314404000148029870
(1 row)

csctoss=# select * from line_equipment where equipment_id = 42931;
 line_id | equipment_id | start_date | end_date | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+----------+---------------------------+-----------+--------------+--------------
   45389 |        42931 | 2017-06-29 |          |                       832 |           |              | 
(1 row)

csctoss=# select billing_entity_id from line where line_id = 45389;
 billing_entity_id 
-------------------
               789
(1 row)



IF v_carrier != 'USCC' THEN
        SELECT username INTO v_new_username
        FROM username u,
             unique_identifier ui
        WHERE 1=1
             AND substring(u.username FROM 1 FOR 10) = ui.value
             AND ui.equipment_id=v_nequipid
             AND ui.unique_identifier_type = 'MDN';


select position('@' in username) from username where username = '882393256289467@m2m01.contournet.net';

SELECT username 
  FROM username u,
       unique_identifier ui
 WHERE 1=1
     AND substring(u.username FROM 1 FOR (position('@' in username) - 1) = ui.value
     AND ui.equipment_id = 42931
     AND ui.unique_identifier_type = 'MDN';


csctoss=# select length(value) 
  from unique_identifier ui 
 where ui.equipment_id = 42931
   AND ui.unique_identifier_type = 'MDN';
 length 
--------
     15
(1 row)

csctoss=# SELECT username 
  FROM username u,
       unique_identifier ui
 WHERE 1=1                               
   AND ui.equipment_id = 42931
   AND ui.unique_identifier_type = 'MDN'
   AND substring(u.username, 1, 15) = ui.value;
               username               
--------------------------------------
 882393256289441@m2m01.contournet.net
(1 row)




INSERT INTO equipment_warranty
SELECT 43927
      ,current_date
      ,current_date + (ewr.num_of_months::text || ' month')::interval
FROM equipment_warranty_rule ewr
WHERE ewr.equipment_model_id = 160;

