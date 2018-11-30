-- Test data

    par_esn_hex                        text := $1;
    par_sales_order                    text := $2;
    par_billing_entity_id              integer := $3;
    par_groupname                      text := $4;
    par_static_ip_boolean              boolean := $5;
    par_product_code                   text := $6;
    par_bypass_jbilling                boolean := $7;

select uie.value as esn_hex
      ,l.notes as sales_order
      ,l.billing_entity_id
      ,u.groupname
      ,p.product_id
  from line_equipment le
  join line l on l.line_id = le.line_id
  join plan p on p.line_id = l.line_id
  join usergroup u on u.username = l.radius_username
  join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
 where uie.value IN (
'353238060066833',
'352613070205467',
'352613070405257',
'352613070387877',
'352613070386408',
'352613070412733',
'352613070407865',
'A100004394DAB3 ',
'352613070386879',
'352613070190859',
'F616FCA8',
'F6158B75',
'352613070283910',
'352613070385566',
'353238060191136',
'352613070383264',
'352613070418441',
'352613070382894',
'352613070411180',
'352613070386846');


     esn_hex     | sales_order | billing_entity_id |        groupname         | product_id 
-----------------+-------------+-------------------+--------------------------+------------
 352613070205467 | SO-12502    |               577 | SERVICE-vzwretail_cnione |        132
 353238060066833 | SO-12503    |               699 | SERVICE-vzwretail_cnione |        156
 352613070385566 | SO-12504    |               577 | SERVICE-vzwretail_cnione |        132
 F6158B75        | SO-12505    |               863 | SERVICE-private_atm      |         33
 F616FCA8        | SO-12505    |               863 | SERVICE-private_atm      |         33
 352613070190859 | SO-12506    |               577 | SERVICE-vzwretail_cnione |        132
 352613070386879 | SO-12507    |               577 | SERVICE-vzwretail_cnione |        132
 352613070407865 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070412733 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070386408 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070387877 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070405257 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070386846 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070411180 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070382894 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070418441 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 352613070383264 | SO-12509    |               334 | SERVICE-vzwretail_cnione |        132
 353238060191136 | SO-12510    |               771 | SERVICE-vzwretail_cnione |        154
 352613070283910 | SO-12511    |               577 | SERVICE-vzwretail_cnione |        132
(19 rows)


./api_assign.sh 352613070205467 SO-12502 577 SERVICE-vzwretail_cnione TRUE 132 FALSE
./api_assign.sh 353238060066833 SO-12503 699 SERVICE-vzwretail_cnione true 156 false
./api_assign.sh 352613070385566 SO-12504 577 SERVICE-vzwretail_cnione true 132 false





select line_id, equipment_id, start_date, end_date from line_equipment
 where line_id in (select line_id from line where date_created > '2018-10-10');
 line_id | equipment_id | start_date | end_date 
---------+--------------+------------+----------
   47263 |        43887 | 2018-10-11 | 
   47262 |        44179 | 2018-10-11 | 
   47274 |        44249 | 2018-10-16 | 
   47273 |        44248 | 2018-10-16 | 
   47272 |        44247 | 2018-10-16 | 
   47271 |        44246 | 2018-10-16 | 
   47270 |        44245 | 2018-10-16 | 
   47269 |        42272 | 2018-10-15 | 
   47268 |        44164 | 2018-10-15 | 
   47267 |        44183 | 2018-10-15 | 
   47266 |        20049 | 2018-10-12 | 
   47265 |         5665 | 2018-10-12 | 
   47281 |        44185 | 2018-10-16 | 
   47264 |        44157 | 2018-10-11 | 
   47280 |        43905 | 2018-10-16 | 
   47279 |        44254 | 2018-10-16 | 
   47278 |        44253 | 2018-10-16 | 
   47277 |        44252 | 2018-10-16 | 
   47276 |        44251 | 2018-10-16 | 
   47275 |        44250 | 2018-10-16 | 
(20 rows)


select plan_id, product_id, line_id, sales_order_number
  from plan
 where line_id IN (
47262,
47263,
47267,
47268,
47270,
47271,
47272,
47264,
47273,
47274,
47275,
47276,
47277,
47278,
47279,
47280,
47281,
47265,
26314,
47266);
 plan_id | product_id | line_id
   26589 |         33 |   26314
   46612 |        132 |   47262
   46613 |        156 |   47263
   46614 |        132 |   47264
   46615 |         33 |   47265
   46616 |         33 |   47266
   46617 |        132 |   47267
   46618 |        132 |   47268
   46620 |        132 |   47270
   46621 |        132 |   47271
   46622 |        132 |   47272
   46623 |        132 |   47273
   46624 |        132 |   47274
   46625 |        132 |   47275
   46626 |        132 |   47276
   46627 |        132 |   47277
   46628 |        132 |   47278
   46629 |        132 |   47279
   46630 |        154 |   47280
   46631 |        132 |   47281


select line_id, billing_entity_id, start_date, date_created, radius_username from line where date_created > '2018-10-10';
 line_id | billing_entity_id |       start_date       |      date_created      |    radius_username    
---------+-------------------+------------------------+------------------------+-----------------------
   47262 |               577 | 2018-10-11 00:00:00+00 | 2018-10-11 00:00:00+00 | 4708291866@vzw3g.com
   47263 |               699 | 2018-10-11 00:00:00+00 | 2018-10-11 00:00:00+00 | 4708082947@vzw3g.com
   47264 |               577 | 2018-10-11 00:00:00+00 | 2018-10-11 00:00:00+00 | 4708290267@vzw3g.com
   47265 |               863 | 2018-10-12 00:00:00+00 | 2018-10-12 00:00:00+00 | 3123887029@uscc.net
   47266 |               863 | 2018-10-12 00:00:00+00 | 2018-10-12 00:00:00+00 | 3129961537@uscc.net
   47267 |               577 | 2018-10-15 00:00:00+00 | 2018-10-15 00:00:00+00 | 4708291870@vzw3g.com
   47268 |               577 | 2018-10-15 00:00:00+00 | 2018-10-15 00:00:00+00 | 4708290319@vzw3g.com
   47269 |               577 | 2018-10-15 00:00:00+00 | 2018-10-15 00:00:00+00 | 4704213077@vzw3g.com
   47270 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4704461063@vzw3g.com
   47271 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4704461084@vzw3g.com
   47272 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4704641643@vzw3g.com
   47273 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705320904@vzw3g.com 
   47274 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705325009@vzw3g.com
   47275 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705325800@vzw3g.com
   47276 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705721694@vzw3g.com
   47277 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705724375@vzw3g.com
   47278 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705830534@vzw3g.com
   47279 |               334 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4705831029@vzw3g.com
   47280 |               771 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4708082965@vzw3g.com
   47281 |               577 | 2018-10-16 00:00:00+00 | 2018-10-16 00:00:00+00 | 4708291872@vzw3g.com
(20 rows)

select id, username, groupname from usergroup
csctoss-# where username in (select radius_username from line where date_created > '2018-10-10');
   id   |       username        |        groupname         
--------+-----------------------+--------------------------
 114488 | 4704213077@vzw3g.com  | SERVICE-vzwretail_cnione
 114513 | 4705325009@vzw3g.com  | SERVICE-vzwretail_cnione
 114373 | 4708290267@vzw3g.com  | SERVICE-vzwretail_cnione
 114516 | 4705724375@vzw3g.com  | SERVICE-vzwretail_cnione
 114456 | 4708291870@vzw3g.com  | SERVICE-vzwretail_cnione
 114514 | 4705325800@vzw3g.com  | SERVICE-vzwretail_cnione
 114369 | 4708291866@vzw3g.com  | SERVICE-vzwretail_cnione
 114519 | 4708082965@vzw3g.com  | SERVICE-vzwretail_cnione
 114512 | 4705320904@vzw3g.com  | SERVICE-vzwretail_cnione
 114521 | 4708291872@vzw3g.com  | SERVICE-vzwretail_cnione
 114517 | 4705830534@vzw3g.com  | SERVICE-vzwretail_cnione
 114370 | 4708082947@vzw3g.com  | SERVICE-vzwretail_cnione
 114510 | 4704461084@vzw3g.com  | SERVICE-vzwretail_cnione
 114518 | 4705831029@vzw3g.com  | SERVICE-vzwretail_cnione
 114487 | 4708290319@vzw3g.com  | SERVICE-vzwretail_cnione
 114509 | 4704461063@vzw3g.com  | SERVICE-vzwretail_cnione
 114377 | 3123887029@uscc.net   | SERVICE-private_atm
 114378 | 3129961537@uscc.net   | SERVICE-private_atm
 114511 | 4704641643@vzw3g.com  | SERVICE-vzwretail_cnione
 114515 | 4705721694@vzw3g.com  | SERVICE-vzwretail_cnione
(20 rows)

select * 
  from unique_identifier
 where unique_identifier_type = 'ESN HEX' 
   and equipment_id in (
43887,44179,44249,44248,44247,44246,44245,
42272,44164,44183,20049,5665,44185,44157,
43905,44254,44253,44252,44251,44250);
 equipment_id | unique_identifier_type |      value      | notes | date_created | date_modified 
--------------+------------------------+-----------------+-------+--------------+---------------
        43887 | ESN HEX                | 353238060066833 |       | 2018-09-05   | 
        44179 | ESN HEX                | 352613070205467 |       | 2018-10-09   | 
        44249 | ESN HEX                | 352613070405257 |       | 2018-10-16   | 
        44248 | ESN HEX                | 352613070387877 |       | 2018-10-16   | 
        44247 | ESN HEX                | 352613070386408 |       | 2018-10-16   | 
        44246 | ESN HEX                | 352613070412733 |       | 2018-10-16   | 
        44245 | ESN HEX                | 352613070407865 |       | 2018-10-16   | 
        42272 | ESN HEX                | A100004394DAB3  |       | 2016-12-07   | 
        44164 | ESN HEX                | 352613070386879 |       | 2018-10-03   | 
        44183 | ESN HEX                | 352613070190859 |       | 2018-10-09   | 
        20049 | ESN HEX                | F616FCA8        |       | 2010-07-14   | 
         5665 | ESN HEX                | F6158B75        |       | 2009-09-24   | 
        44185 | ESN HEX                | 352613070283910 |       | 2018-10-09   | 
        44157 | ESN HEX                | 352613070385566 |       | 2018-10-03   | 
        43905 | ESN HEX                | 353238060191136 |       | 2018-09-05   | 
        44254 | ESN HEX                | 352613070383264 |       | 2018-10-16   | 
        44253 | ESN HEX                | 352613070418441 |       | 2018-10-16   | 
        44252 | ESN HEX                | 352613070382894 |       | 2018-10-16   | 
        44251 | ESN HEX                | 352613070411180 |       | 2018-10-16   | 
        44250 | ESN HEX                | 352613070386846 |       | 2018-10-16   | 
(20 rows)



select * 
  from unique_identifier
 where unique_identifier_type = 'ESN HEX' 
   and equipment_id in (
43887,44179,44249,44248,44247,44246,44245,
42272,44164,44183,20049,5665,44185,44157,
43905,44254,44253,44252,44251,44250);
 equipment_id | unique_identifier_type |      value      | notes | date_created | date_modified 
--------------+------------------------+-----------------+-------+--------------+---------------
        43887 | ESN HEX                | 353238060066833 |       | 2018-09-05   | 
        44179 | ESN HEX                | 352613070205467 |       | 2018-10-09   | 
        44249 | ESN HEX                | 352613070405257 |       | 2018-10-16   | 
        44248 | ESN HEX                | 352613070387877 |       | 2018-10-16   | 
        44247 | ESN HEX                | 352613070386408 |       | 2018-10-16   | 
        44246 | ESN HEX                | 352613070412733 |       | 2018-10-16   | 
        44245 | ESN HEX                | 352613070407865 |       | 2018-10-16   | 
        42272 | ESN HEX                | A100004394DAB3  |       | 2016-12-07   | 
        44164 | ESN HEX                | 352613070386879 |       | 2018-10-03   | 
        44183 | ESN HEX                | 352613070190859 |       | 2018-10-09   | 
        20049 | ESN HEX                | F616FCA8        |       | 2010-07-14   | 
         5665 | ESN HEX                | F6158B75        |       | 2009-09-24   | 
        44185 | ESN HEX                | 352613070283910 |       | 2018-10-09   | 
        44157 | ESN HEX                | 352613070385566 |       | 2018-10-03   | 
        43905 | ESN HEX                | 353238060191136 |       | 2018-09-05   | 
        44254 | ESN HEX                | 352613070383264 |       | 2018-10-16   | 
        44253 | ESN HEX                | 352613070418441 |       | 2018-10-16   | 
        44252 | ESN HEX                | 352613070382894 |       | 2018-10-16   | 
        44251 | ESN HEX                | 352613070411180 |       | 2018-10-16   | 
        44250 | ESN HEX                | 352613070386846 |       | 2018-10-16   | 
(20 rows)


select * from radreply 
 where username in (select radius_username from line where date_created > '2018-10-10') 
   and attribute = 'Class';
  id   |       username        | attribute | op | value | priority 
-------+-----------------------+-----------+----+-------+----------
 82980 | 4704213077@vzw3g.com  | Class     | =  | 47269 |       10
 82990 | 4705325009@vzw3g.com  | Class     | =  | 47274 |       10
 82970 | 4708290267@vzw3g.com  | Class     | =  | 47264 |       10
 82996 | 4705724375@vzw3g.com  | Class     | =  | 47277 |       10
 82976 | 4708291870@vzw3g.com  | Class     | =  | 47267 |       10
 82992 | 4705325800@vzw3g.com  | Class     | =  | 47275 |       10
 82964 | 4708291866@vzw3g.com  | Class     | =  | 47262 |       10
 83002 | 4708082965@vzw3g.com  | Class     | =  | 47280 |       10
 82988 | 4705320904@vzw3g.com  | Class     | =  | 47273 |       10
 83004 | 4708291872@vzw3g.com  | Class     | =  | 47281 |       10
 82998 | 4705830534@vzw3g.com  | Class     | =  | 47278 |       10
 82966 | 4708082947@vzw3g.com  | Class     | =  | 47263 |       10
 82984 | 4704461084@vzw3g.com  | Class     | =  | 47271 |       10
 83000 | 4705831029@vzw3g.com  | Class     | =  | 47279 |       10
 82978 | 4708290319@vzw3g.com  | Class     | =  | 47268 |       10
 82982 | 4704461063@vzw3g.com  | Class     | =  | 47270 |       10
 82972 | 3123887029@uscc.net   | Class     | =  | 47265 |       10
 82973 | 3129961537@uscc.net   | Class     | =  | 47266 |       10
 82986 | 4704641643@vzw3g.com  | Class     | =  | 47272 |       10
 82994 | 4705721694@vzw3g.com  | Class     | =  | 47276 |       10
(20 rows)



