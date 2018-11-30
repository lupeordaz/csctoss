-- JBilling
-- user_id's are 44, 197, 490, 941

select user_id
      ,external_id
  from customer_external_ids_vw
 where user_id in (44,197,490,941) 
 order by 1;
 user_id | external_id 
---------+-------------
      44 |         107
     197 |         145
     490 |         239
     941 |         392
(4 rows)

-- OSS

select billing_entity_id
      ,count(line_id)
  from line 
 where end_date is null
   and billing_entity_id in (
107,145,239,392)
 group by billing_entity_id
 order by billing_entity_id;

 billing_entity_id | count 
-------------------+-------
               107 |   148
               145 |    11
               239 |    93
               392 |    14
(4 rows)

select line_id 
  from line 
 where billing_entity_id = 145
 order by 1;
 line_id 
---------
    3784
   24330
   24331
   24332
   28627
   29114
   32948
   32949
   35225
   38318
   40759
   44037
(12 rows)


select line_id 
  from line 
 where billing_entity_id = 392
 order by 1;


-- JBilling 

select line_id
  from prov_line
 where line_id in(
35225,
32949,
32948,
29114,
28627,
24332,
24331,
24330,
3784,
38318,
40759,
44037) order by 1;

 line_id 
---------
   24330
   24331
   24332
   28627
   29114
   32948
   32949
   35225
   38318
   40759
   44037
(11 rows)


-- Line id 3784 does not exist in JBilling

-- OSS

select le.line_id 
      ,l.billing_entity_id
      ,uie.equipment_id
      ,uie.value as esn_hex
      ,uis.value as serial_number
  from line_equipment le
  join line l on l.line_id = le.line_id
  join unique_identifier uie
        on le.equipment_id = uie.equipment_id
        and uie.unique_identifier_type = 'ESN HEX'
  join unique_identifier uis
        on le.equipment_id = uis.equipment_id
        and uis.unique_identifier_type = 'SERIAL NUMBER'
where le.line_id = 3784;

 line_id | billing_entity_id | equipment_id | esn_hex  | serial_number 
---------+-------------------+--------------+----------+---------------
    3784 |               145 |         3491 | F614B796 | 640802
(1 row)


--

select line_id
  from line l
 where billing_entity_id = 145
   and l.end_date IS null
 order by 1


SELECT lineid
  FROM dblink(fetch_jbilling_conn(),
                                'SELECT line_id
                                   FROM prov_line
                                  WHERE line_id = 24331'
                ) as rec_type (lineid int);


--

select line_id 
  from line 
 where billing_entity_id = 145
   and end_date is null
 order by 1;


--

task 6540

There is no outage between JBilling database and OSS for user_id 44, which translates to external_id/billing_entity_id 107 (CardTronics).  

User Id 197 (Extreme Marketing, Inc.) 

-- user_id's are 44, 197, 490, 941

select user_id
      ,external_id
  from customer_external_ids_vw
 where user_id in (44,197,490,941) 
 order by 1;
 user_id | external_id 
---------+-------------
      44 |         107
     197 |         145
     490 |         239
     941 |         392
(4 rows)

-- OSS

select billing_entity_id
      ,count(line_id)
  from line 
 where end_date is null
   and billing_entity_id in (
107,145,239,392)
 group by billing_entity_id
 order by billing_entity_id;

 billing_entity_id | count 
-------------------+-------
               107 |   148
               145 |    11
               239 |    93
               392 |    14
(4 rows)


