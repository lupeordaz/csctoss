select e.equipment_id
      ,uie.value as MAC
  from equipment e
  join unique_identifier uie on (uie.equipment_id = le.equipment_id and uie.unique_identifier_type = 'MAC ADDRESS')
 where uis.value in 
(
3490,
4642,
4909,
7115,
7799,
7827,
7880,
7991,
8187,
8250,
8696,
11666,
11732,
11756,
11785,
11876,
12087,
12224,
12330,
12461,
12503,
13387,
13420,
13459,
14617,
14711,
15683,
16124,
16124,
16163,
16268,
16588,
17034,
17091,
19578,
19610,
19705,
31508,
32390,
32983,
33616,
33642,
34308,
35198,
35214,
35702,
35795,
36109,
36452,
36561,
40100);


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


-- select only the data where there are 2 esns in the esn field.

select count(*) from (
select d.did
      ,c.esn       
      ,c.imsi       
      ,d.eui       
      ,d.model       
      ,d.serial_number       
      ,d.part_number   
  from device d   
  join cellinfo c on d.did = c.did  
 where c.esn NOT LIKE '%,%') as total;

+----------+
| count(*) |
+----------+
|     7013 |
+----------+
1 row in set (0.05 sec)


select d.did
      ,c.esn       
      ,c.imsi       
      ,d.eui       
      ,d.model       
      ,d.serial_number       
      ,d.part_number   
  into outfile '/tmp/lo_device_oneesn.csv' 
fields terminated by '|'  
 lines terminated by '\n'   
  from device d   
  join cellinfo c on d.did = c.did  
 where c.esn NOT LIKE '%,%';

--

select count(*) from (
select d.did
      ,c.esn       
      ,c.imsi       
      ,d.eui       
      ,d.model       
      ,d.serial_number       
      ,d.part_number   
  from device d   
  join cellinfo c on d.did = c.did  
 where c.esn LIKE '%,%') as total;

+----------+
| count(*) |
+----------+
|     7717 |
+----------+
1 row in set (0.05 sec)


select d.did
      ,c.esn       
      ,c.imsi       
      ,d.eui       
      ,d.model       
      ,d.serial_number       
      ,d.part_number   
  into outfile '/tmp/lo_device_multiesn.csv' 
fields terminated by '|'  
 lines terminated by '\n'   
  from device d   
  join cellinfo c on d.did = c.did  
 where c.esn LIKE '%,%';

-- select only the data where there are is only one esn in the esn field.

select d.did
      ,c.esn
      ,c.imsi
      ,d.eui
      ,d.model
      ,d.serial_number
      ,d.part_number
  from device d
  join cellinfo c on d.did = c.did
 where c.esn NOT LIKE '%,%';



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

No Match 0FEACF
No Match 0FEAC7
No Match 1062E6
No Match 0FEF2C
No Match 10FADE
No Match 0DF62A
No Match 0F8DB2
No Match 0FEADD
No Match 0FF346
No Match 10C51C
No Match 0F3FB9
No Match 10189F
No Match 0FEAA7
No Match 0FEAC6
No Match 0FF178
No Match 0D8CE1
No Match 0FDEBC
No Match 0FEAAE
No Match 0FE85B
No Match 123A27
No Match 0E71BB
No Match 0F4022
No Match 0E2CB9
No Match 11AB18
No Match 0F58A6
No Match 0F213C
No Match 0EFA49
No Match 10A2B3
No Match 1296BC
No Match 111887
No Match 12928B
No Match 116B79
No Match 130357
No Match 130392
No Match 130338
No Match 130340
No Match 130358
No Match 130339
No Match 13034D
No Match 130346
No Match 130488
No Match 130475


--

select soup.model
      ,em.model_number2
  from soup_device_table soup
  join unique_identifier uim on uim.unique_identifier_type = 'MAC ADDRESS' and substring(uim.value,7,6) = substring(soup.eui,7,6)
  join equipment e on e.equipment_id = uim.equipment_id
  join equipment_model em on e.equipment_model_id = em.equipment_model_id
 where substring(value,7,6) = '10637D';








[postgres@testoss01 5653]$ . mac_esn_hex.sh 
-bash: [[: 00A1000051E72D21: value too great for base (error token is "00A1000051E72D21")
-bash: [[: 00A1000051E734CF: value too great for base (error token is "00A1000051E734CF")
-bash: [[: 00A1000051C1FB92: value too great for base (error token is "00A1000051C1FB92")
-bash: [[: 0A10000157E5CD9: value too great for base (error token is "0A10000157E5CD9")
-bash: [[: 89148000002683906637
 89148000003082925624: syntax error in expression (error token is "89148000003082925624")
-bash: [[: 00A1000051E71130: value too great for base (error token is "00A1000051E71130")
-bash: [[: 00A1000051C2E00E: value too great for base (error token is "00A1000051C2E00E")
-bash: [[: 00A100004D9682B5: value too great for base (error token is "00A100004D9682B5")
-bash: [[: 00A1000051C2E020: value too great for base (error token is "00A1000051C2E020")
-bash: [[: 00A1000051E73534: value too great for base (error token is "00A1000051E73534")
-bash: [[: 00A1000051C2D785: value too great for base (error token is "00A1000051C2D785")
-bash: [[: 00A1000051E7376C: value too great for base (error token is "00A1000051E7376C")
-bash: [[: F6158D71
 F616F80B: syntax error in expression (error token is "F616F80B")
-bash: [[: 00A1000051C2D6C8: value too great for base (error token is "00A1000051C2D6C8")
-bash: [[: 00A1000051E73750: value too great for base (error token is "00A1000051E73750")
-bash: [[: F616EC88
 A1000009420AAA: syntax error in expression (error token is "A1000009420AAA")
-bash: [[: F616038F
 F616F8F1: syntax error in expression (error token is "F616F8F1")
-bash: [[: 00A1000051E734DB: value too great for base (error token is "00A1000051E734DB")
-bash: [[: 00A1000051C1F34D: value too great for base (error token is "00A1000051C1F34D")




11|80FE3447, A100001574C597|310005052667350|11344B|IPG/8100E|856229| 65-800907
12|F61588C2|310004049881572|0DE044|IPG/7310|642793|65-800811-9-00
13|F615F86A|310004049904448|0E2C93|IPG/7310|619845|65-800811-9-00
14|F615C5AB|310008435913007|0E0943|IPG/7310|614011|65-800811-9-00
15|A1000009420AB1, 807BCD6C|310009172559181|0E9691|IPG/7710|680921|65-800832-2-00
76|00A1000051E72D21|310006785459561|12F056|SL-05-E2-CVE|S03394| 65-801103
145|00A1000051E734CF|310006785468115|12F031|SL-05-E2-CVE|S03457| 65-801103
236|00A1000051C1FB92|310002252442751|13506F|SL-05-E2-CVE|S05607| 65-801103
306|804A7CA3, A10000157E5CD9|310009134870045|108065|IPG/8100E|776949| 65-800901
489|89148000003082925459|311480308241126|08E8B1|TransPort WR21|583857|65-123456789






-----







select le.equipment_id
      ,le.line_id
      ,l.start_date
      ,l.radius_username
      ,em.model_number1
      ,em.model_number2
      ,em.part_number
      packet_write_wait: Connection to 10.17.73.10 port 22: Broken pipe
[gordaz@cctlix03 ~]$ qle
  join line l on le.line_id = l.line_id
  join equipment e on le.equipment_id = e.equipment_id
  join equipment_model em on e.equipment_model_id = em.equipment_model_id
  join unique_identifier uim
       on le.equipment_id = uim.equipment_id
       and uim.unique_identifier_type = 'MAC ADDRESS'
 where le.line_id = 3783;




 