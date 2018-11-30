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

select uis.value as serial_number
  from unique_identifier uie
  join unique_identifier uis
       on uie.equipment_id = uis.equipment_id
       and uis.unique_identifier_type = 'SERIAL NUMBER'
 where uie.value = '$ESN'
   and uie.unique_identifier_type = 'ESN HEX';



EQUIPID ESN IMSI MAC MODEL SN PARTNO

OSSEQID OSSMAC OSSMODL1 OSSSN OSSPARTNO


         OSSSN=`psql -q -t -c "select uis.value as serial_number
                                 from unique_identifier uie
                                 join unique_identifier uis
                                      on uie.equipment_id = uis.equipment_id
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                where uie.value = '$ESN'
                                  and uie.unique_identifier_type = 'ESN HEX'"`
         OSSSN=`echo $OSSSN | xargs`         


        MODL1=`psql -q -t -c "select em.model_number1
                                from equipment e
                                join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                join unique_identifier uis 
                                      on e.equipment_id = uis.equipment_id 
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                join equipment_model em 
                                      on e.equipment_model_id = em.equipment_model_id
                               where uim.value = '$MAC'"`






        OSSMODL=`psql -q -t -c "select em.part_number
                                from equipment e
                                join unique_identifier uie
                                      on e.equipment_id = uie.equipment_id
                                      and uie.unique_identifier_type = 'ESN HEX'
                                join unique_identifier uis
                                      on e.equipment_id = uis.equipment_id
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                join equipment_model em
                                      on e.equipment_model_id = em.equipment_model_id
                               where uie.value = 'A10000157EC0D3'"`
