-- SOUP
-- To write to a csv file, include the following lines:
--      into outfile '/tmp/lo_device.csv'
--    fields terminated by ','
--    enclosed by '"'
--     lines terminated by '\n'

select d.did
      ,c.esn
      ,c.imsi
      ,d.eui
      ,d.model
      ,d.serial_number
      ,d.part_number
--  into outfile '/tmp/lo_device.csv'
--fields terminated by ','
--enclosed by '"'
-- lines terminated by '\n'
  from device d
  join cellinfo c on d.did = c.did
 limit 20

+-----+--------------------------+-----------------+--------------+----------------+---------------+----------------+
| did | esn                      | imsi            | mac          | model          | serial_number | part_number    |
+-----+--------------------------+-----------------+--------------+----------------+---------------+----------------+
|   4 | 80A45998, A10000157EC0D3 | 310008322073560 | 00804410637D | IPG/8110E      | 770263        |  65-800902     |
|   5 | A1000043888A18           | 310004049808523 | 0080441200F2 | SL-08-E2-P-CVE | 927220        |  65-801091     |
|   6 | 8044C9B7, A10000157E50C9 | 310008038637235 | 00804411108E | IPG/8100E      | 868315        |  65-800907     |
|   7 | F61602CD                 | 310004049867727 | 0080440E2A08 | IPG/7310       | 618744        | 65-800811-9-00 |
|   8 | F615DBA2                 | 310004049810693 | 0080440E1746 | IPG/7310       | 607414        | 65-800811-9-00 |
|   9 | A100003690E2C6           | 310004049873459 | 00804411C5B8 | SL-08-E2-CVE   | 909319        |  65-801043     |
|  10 | A1000043952373           | 310004042077096 | 008044132B35 | SL-08-E2-P-CVE | 972144        |  65-801091     |
|  11 | 80FE3447, A100001574C597 | 310005052667350 | 00804411344B | IPG/8100E      | 856229        |  65-800907     |
|  12 | F61588C2                 | 310004049881572 | 0080440DE044 | IPG/7310       | 642793        | 65-800811-9-00 |
|  13 | F615F86A                 | 310004049904448 | 0080440E2C93 | IPG/7310       | 619845        | 65-800811-9-00 |
|  14 | F615C5AB                 | 310008435913007 | 0080440E0943 | IPG/7310       | 614011        | 65-800811-9-00 |
|  15 | A1000009420AB1, 807BCD6C | 310009172559181 | 0080440E9691 | IPG/7710       | 680921        | 65-800832-2-00 |
|  16 | F616F991                 | 310004049898763 | 0080440DE8DE | IPG/7310       | 626654        | 65-800811-9-00 |
|  17 | 801A6097, A10000157E357B | 310009172816280 | 0080440FE283 | IPG/8100E      | 749313        |  65-800901     |
|  18 | 803AF11F, A10000157EC8CA | 310008322071913 | 008044102E96 | IPG/8110E      | 767876        |  65-800902     |
|  19 | F615FEFA                 | 310004049811744 | 0080440E36EA | IPG/7310       | 615976        | 65-800811-9-00 |
|  20 | 807CE84E, A1000012C291DC | 310004049847843 | 00804411AC82 | IPG/8101E      | 895468        |  65-800940     |
|  21 | F615FD5E                 | 310004049896844 | 0080440E2B3E | IPG/7310       | 618614        | 65-800811-9-00 |
|  22 | F616ED86                 | 310004049657830 | 0080440DF025 | IPG/7310       | 621135        | 65-800811-9-00 |
|  23 | 806223B8, A10000157E3593 | 000009172747519 | 0080440FFB2A | IPG/8100E      | 749271        |  65-800901     |
+-----+--------------------------+-----------------+--------------+----------------+---------------+----------------+
20 rows in set (0.00 sec)



-- 


'00804410F638',
'008044106379',
'0080441028AD',
'00804410637D',
'0080441200F2',
'00804411108E',
'0080440E2A08',
'0080440E1746',
'00804411C5B8',
'008044132B35',
'00804411344B',
'0080440DE044',
'0080440E2C93',
'0080440E0943',
'0080440E9691',
'0080440DE8DE',
'0080440FE283',
'008044102E96',
'0080440E36EA',
'00804411AC82')
order by 3;
 equipment_id |       esn       |     mac      | part_number | serialno | model_number2 
--------------+-----------------+--------------+-------------+----------+---------------
        32445 | A10000157E357B  | 0080440FE283 | 65-800901   | 749313   | IPG/8100E
        33486 | A10000157ECC4C  | 0080441028AD |             | 765574   | IPG/8110ESP
        39512 | 990000940212113 | 00804410F638 | 65-800993   | 903871   | SL-1-E2-CVL
        38724 | A10000157E50C9  | 00804411108E | 65-800907   | 868315   | IPG/8100E
        37781 | A100001574C597  | 00804411344B | 65-800907   | 856229   | IPG/8100E
        39845 | A1000012C291DC  | 00804411AC82 |             | 895468   | IPG-8101-VE
        40264 | A100003690E2C6  | 00804411C5B8 | 65-801043   | 909319   | SL-08-CVE
        40827 | A1000043888A18  | 0080441200F2 |             | 927220   | SL-08-P-CVE
        43004 | A1000043952373  | 008044132B35 |             | 972144   | SL-08-P-CVE
(9 rows)



-- MAC address from SOUP data on OSS

select uim.value as mac
      ,em.model_number2
      ,uis.value as serialno
      ,em.part_number
      ,e.equipment_id
  from equipment e
  join unique_identifier uim on e.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uis on e.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
  join equipment_model em on e.equipment_model_id = em.equipment_model_id
 where uim.value = '00804412F029';

     mac      | model_number2 | serialno | part_number | equipment_id 
--------------+---------------+----------+-------------+--------------
 00804412F029 | SL-05-E2-CVE  | S03381   | 65-801043   |        42812
(1 row)



select uim.value as mac
      ,uis.value as serialno
      ,uie.value as esnhex
      ,em.part_number
      ,em.model_number2
      ,e.equipment_id
  from equipment e
  join unique_identifier uim on e.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
  join unique_identifier uis on e.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
  join equipment_model em on e.equipment_model_id = em.equipment_model_id
 where uim.value = '00804412F029';

     mac      | serialno |     esnhex     | part_number | model_number2 | equipment_id 
--------------+----------+----------------+-------------+---------------+--------------
 00804412F029 | S03381   | A100003E42C2DC | 65-801043   | SL-05-E2-CVE  |        42812
(1 row)


--

select did, create_date, substring(eui,7,6), model, serial_number, part_number
  from device
  into outfile '/home/gordaz/device.csv'
fields terminated by ','
enclosed by '"'
 lines terminated by '\n';


--