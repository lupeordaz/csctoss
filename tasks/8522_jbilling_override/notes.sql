­-- test data

csctoss=# select e.equipment_id
  from equipment e
 where e.equipment_id NOT IN (select l.equipment_id from line_equipment l) limit 40;
 equipment_id 
--------------
        42136
        42137
        41061
        40535
         8785
        41302
        41304
        41313
        41314
        41317
        41319
        41323
        41362
        41366
        41367
        41369
        41370
        41375
        41377
        41378
        41381
        41383
        41384
        41385
        41389
        41391
        42301
        42304
        40479
        40521
        40524
        40526
        40317
        37409
        37410
        40260
        40146
        39996
        42307
        39853
(40 rows)


SELECT i.internal_number
  FROM purchase_order po
      ,order_line ol
      ,item i
      ,item_type_map itm
 WHERE 1=1
--   AND po.public_number = ''' || par_sales_order || '''
   AND po.id = ol.order_id
   AND ol.item_id = i.id
   AND i.id = itm.item_id
   AND itm.type_id = 301
   AND internal_number LIKE 'MRC%'
 LIMIT '1';

    SELECT prod_code
      FROM public.dblink(fetch_jbilling_conn(), 
      	var_sql_2) AS rec_type (prod_code  text);




SELECT i.internal_number
  FROM purchase_order po
      ,order_line ol
      ,item i
      ,item_type_map itm
 WHERE 1=1
   AND po.public_number = 'SO-1989B'
   AND po.id = ol.order_id
   AND ol.item_id = i.id
   AND i.id = itm.item_id
   AND itm.type_id = 301
   AND internal_number LIKE 'MRC%'
 LIMIT '1';


esn_hex, sales_order, billing_entity_id



select * 
  from line_equipment 
 where start_date >= '2018-09-02' 
   and start_date <= '2018-09-10-'
 order by equipment_id, start_date;

 line_id | equipment_id | start_date |  end_date  | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+------------+---------------------------+-----------+--------------+--------------
   47170 |        14987 | 2018-09-05 |            |                       897 |           |              | 
   47154 |        29804 | 2018-09-04 |            |                       865 |           |              | 
   47155 |        29884 | 2018-09-04 |            |                       865 |           |              | 
   47164 |        31036 | 2018-09-04 |            |                       865 |           |              | 
   47157 |        31055 | 2018-09-04 |            |                       865 |           |              | 
   47158 |        31059 | 2018-09-04 |            |                       865 |           |              | 
   47162 |        31085 | 2018-09-04 |            |                       865 |           |              | 
   47161 |        31087 | 2018-09-04 |            |                       865 |           |              | 
   47160 |        31088 | 2018-09-04 |            |                       865 |           |              | 
   47165 |        31310 | 2018-09-04 |            |                       865 |           |              | 
   47159 |        31600 | 2018-09-04 |            |                       865 |           |              | 
   47166 |        31766 | 2018-09-04 |            |                       865 |           |              | 
   47169 |        35283 | 2018-09-05 | 2018-09-10 |                       366 |           |              | 
   47163 |        40237 | 2018-09-04 |            |                       865 |           |              | 
   47156 |        41048 | 2018-09-04 | 2018-09-17 |                       865 |           |              | 
   44899 |        41527 | 2018-09-10 |            |                       289 |           |              | 
   47153 |        42090 | 2018-09-04 |            |                       865 |           |              | 
   47192 |        42464 | 2018-09-10 |            |                       619 |           |              | 
   46925 |        43332 | 2018-09-05 |            |                       448 |           |              | 
   47178 |        43775 | 2018-09-05 |            |                       738 |           |              | 
   47167 |        43779 | 2018-09-04 |            |                       619 |           |              | 
   47173 |        43812 | 2018-09-05 |            |                       738 |           |              | 
   47172 |        43818 | 2018-09-05 |            |                       738 |           |              | 
   47141 |        43858 | 2018-09-05 |            |                       619 |           |              | 
   47168 |        43863 | 2018-09-05 |            |                       619 |           |              | 
   47174 |        43866 | 2018-09-05 |            |                       619 |           |              | 
   47171 |        43867 | 2018-09-05 |            |                       619 |           |              | 
   47187 |        43868 | 2018-09-07 |            |                       181 |           |              | 
   47186 |        43869 | 2018-09-07 |            |                       181 |           |              | 
   47188 |        43870 | 2018-09-07 |            |                       181 |           |              | 
   47175 |        43873 | 2018-09-05 |            |                       738 |           |              | 
   47176 |        43874 | 2018-09-05 |            |                       738 |           |              | 
   47177 |        43875 | 2018-09-05 |            |                       738 |           |              | 
   47194 |        43891 | 2018-09-10 |            |                       444 |           |              | 
   47179 |        43906 | 2018-09-07 |            |                       444 |           |              | 
   47190 |        43917 | 2018-09-10 |            |                       619 |           |              | 
   47191 |        43919 | 2018-09-10 |            |                       619 |           |              | 
   47193 |        43924 | 2018-09-10 |            |                       619 |           |              | 
   47189 |        43926 | 2018-09-10 |            |                       619 |           |              |


csctoss=# select equipment_id, value as esn_hex
  from unique_identifier
 where unique_identifier_type = 'ESN HEX' 
   AND equipment_id in (
14987, 29804, 29884, 31036, 31055, 31059,
31085, 31087, 31088, 31310, 31600, 31766,
35283, 40237, 41048, 41527, 42090, 42464,
43332, 43775, 43779, 43812, 43818, 43858,
43863, 43866, 43867, 43868, 43869, 43870,
43873, 43874, 43875, 43891, 43906, 43917,
43919, 43924, 43926);
 equipment_id |     esn_hex     
--------------+-----------------
        14987 | F6160330
        29804 | A10000157F1797
        29884 | A10000157F17B5
        31036 | A10000157F178E
        31055 | A10000157EDD42
        31059 | A10000157E35F6
        31085 | A10000157EDF6A
        31087 | A10000157F2548
        31088 | A10000157ED731
        31310 | A1000012C20166
        31600 | A10000369B29C5
        31766 | A10000157F11E1
        35283 | A10000157EBB21
        40237 | A100003690E28D
        41048 | A10000438723E0
        41527 | A100004388A59C
        42090 | A000003361271B
        42464 | A10000157D1D3D
        43332 | 352613070200179
(19 rows)


select ui.value as esn_hex
      ,l.notes
      ,l.billing_entity_id
      ,ug.groupname
      ,p.product_id
      ,le.equipment_id
      ,l.line_id
  from line_equipment le
  join line l on l.line_id = le.line_id
  join plan p on l.line_id = p.line_id
  join username un on un.username = l.radius_username
  join usergroup ug on ug.username = un.username
  join unique_identifier ui on ui.equipment_id = le.equipment_id and ui.unique_identifier_type = 'ESN HEX'
 where le.equipment_id in (
14987, 29804, 29884, 31036, 31055, 31059,
31085, 31087, 31088, 31310, 31600, 31766,
35283, 40237, 41048, 41527, 42090, 42464,
43332, 43775, 43779, 43812, 43818, 43858,
43863, 43866, 43867, 43868, 43869, 43870,
43873, 43874, 43875, 43891, 43906, 43917,
43919, 43924, 43926);



-- oss test
     esn_hex     |  notes   | billing_entity_id |        groupname         | product_id | equipment_id | line_id 
-----------------+----------+-------------------+--------------------------+------------+--------------+---------
 F6160330        | SO-12434 |               855 | SERVICE-private_atm      |         33 |        14987 |   47170
 A10000157F1797  | SO-12429 |               822 | SERVICE-vzwretail_cnione |        133 |        29804 |   47154
 A10000157F17B5  | SO-12429 |               822 | SERVICE-vzwretail_cnione |        133 |        29884 |   47155
 A10000157F178E  | SO-12427 |               822 | SERVICE-vzwretail_cnione |        133 |        31036 |   47164
 A10000157EDD42  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31055 |   47157
 A10000157E35F6  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31059 |   47158
 A10000157EDF6A  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31085 |   47162
 A10000157F2548  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31087 |   47161
 A10000157ED731  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31088 |   47160
 A1000012C20166  | SO-12427 |               822 | SERVICE-vzwretail_cnione |        133 |        31310 |   47165
 A10000369B29C5  | SO-12426 |               822 | SERVICE-private_atm      |        146 |        31600 |   47159
 A10000157F11E1  | SO-12427 |               822 | SERVICE-vzwretail_cnione |        133 |        31766 |   47166
 A100003690E28D  | SO-12425 |               822 | SERVICE-vzwretail_cnione |        132 |        40237 |   47163
 A100004388A59C  | SO-10703 |               332 | SERVICE-vzwretail_cnione |         33 |        41527 |   43501
 A100004388A59C  | SO-11386 |               162 | SERVICE-vzwretail_cnione |        132 |        41527 |   44899
 A000003361271B  | SO-12430 |               822 | SERVICE-private_atm      |        133 |        42090 |   47153


 A10000157D1D3D  | SO-12444 |               577 | SERVICE-acfn             |         33 |        42464 |   47192
 352613070200179 | SO-12298 |               400 | SERVICE-vzwretail_cnione |        132 |        43332 |   46925
 353238060035945 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43775 |   47178
 352613070408087 | SO-12431 |               577 | SERVICE-vzwretail_cnione |        132 |        43779 |   47167
 353238060039236 | SO-12436 |               699 | SERVICE-vzwretail_cnione |        156 |        43812 |   47173
 353238060034021 | SO-12436 |               699 | SERVICE-vzwretail_cnione |        156 |        43818 |   47172
 352613070119338 | SO-12414 |               577 | SERVICE-vzwretail_cnione |        132 |        43858 |   47141
 352613070311158 | SO-12433 |               577 | SERVICE-vzwretail_cnione |        132 |        43863 |   47168
 352613070309996 | SO-12437 |               577 | SERVICE-vzwretail_cnione |        132 |        43866 |   47174
 352613070293687 | SO-12435 |               577 | SERVICE-vzwretail_cnione |        132 |        43867 |   47171
 359072060914716 | SO-12421 |               112 | SERVICE-vzwretail_cnione |        132 |        43868 |   47187
 359072060914559 | SO-12421 |               112 | SERVICE-vzwretail_cnione |        132 |        43869 |   47186
 359072060914674 | SO-12421 |               112 | SERVICE-vzwretail_cnione |        132 |        43870 |   47188
 353238060192126 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43873 |   47175
 353238060025201 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43874 |   47176
 353238060061024 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43875 |   47177
 353238060032850 | SO-12446 |               396 | SERVICE-vzwretail_cnione |        154 |        43891 |   47194
 353238060195780 | SO-12440 |               396 | SERVICE-vzwretail_cnione |        154 |        43906 |   47179
 352613070440908 | SO-12442 |               577 | SERVICE-vzwretail_cnione |        132 |        43917 |   47190
 352613070394477 | SO-12443 |               577 | SERVICE-vzwretail_cnione |        132 |        43919 |   47191
 352613070252451 | SO-12445 |               577 | SERVICE-vzwretail_cnione |        132 |        43924 |   47193
 352613070446004 | SO-12442 |               577 | SERVICE-vzwretail_cnione |        132 |        43926 |   47189
(38 rows)


-- oss test
    esn_hex     |  notes   | billing_entity_id |             groupname              | product_id | equipment_id | line_id 
----------------+----------+-------------------+------------------------------------+------------+--------------+---------
 F6160330       | SO-1294  |               376 | SERVICE-private_atm                |         33 |        14987 |   10565
 A10000157F1797 | SO-5643  |               396 | SERVICE-vzwretail_cnione           |        133 |        29804 |   28985
 A10000157F17B5 | SO-5677A |               396 | SERVICE-vzwretail_cnione           |        133 |        29884 |   29058
 A10000157F178E | SO-5973  |               396 | SERVICE-vzwretail_cnione           |        133 |        31036 |   30414
 A10000157EDD42 | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31055 |   30707
 A10000157E35F6 | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31059 |   30712
 A10000157EDF6A | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31085 |   30717
 A10000157F2548 | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31087 |   30716
 A10000157ED731 | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31088 |   30715
 A1000012C20166 | SO-6055A |               396 | SERVICE-vzwretail_cnione           |        133 |        31310 |   31019
 A10000369B29C5 | SO-6048E |               396 | SERVICE-private_atm                |        146 |        31600 |   30714
 A10000157F11E1 | SO-6178A |               396 | SERVICE-vzwretail_cnione           |        133 |        31766 |   31444
 A100003690E28D | SO-9798  |               396 | SERVICE-vzwretail_cnione           |        132 |        40237 |   41482
 A10000438723E0 | SO-5939  |               396 | SERVICE-vzwretail_cnione           |        133 |        41048 |   30278
 A100004388A59C | SO-10703 |               332 | SERVICE-vzwretail_cnione           |         33 |        41527 |   43501
 A100004388A59C | SO-12114 |               112 | SERVICE-vzwretail_inventory_cnione |        132 |        41527 |   46539
 A000003361271B | SO-12284 |               396 | SERVICE-private_atm                |        133 |        42090 |   46888
(17 rows)


select * from ops_api_assign(352613070200179, 'SO-12298', 400, 'SERVICE-vzwretail_cnione', )




select * 
  from groupname_default 
 where billing_entity_id in (400,577,699,112,396);
 groupname_default_key_id |        groupname         |    carrier    | billing_entity_id 
--------------------------+--------------------------+---------------+-------------------
                      655 | SERVICE-acfn             | SPRINT        |               577
                      714 | SERVICE-vzwwholesale     | VZW_WHOLESALE |               577
                      776 | SERVICE-acfn             | USCC          |               577
                      685 | SERVICE-vzwretail_cnione | VZW           |               577
                      741 | SERVICE-fiservcashlog    | USCC          |               699
                      742 | SERVICE-fiservcashlog    | SPRINT        |               699
                      744 | SERVICE-vzwwholesale     | VZW_WHOLESALE |               699
                      743 | SERVICE-vzwretail_cnione | VZW           |               699
(8 rows)


     esn_hex     |  notes   | billing_entity_id |        groupname         | product_id | equipment_id | line_id 
-----------------+----------+-------------------+--------------------------+------------+--------------+---------
 A10000157D1D3D  | SO-12444 |               577 | SERVICE-acfn             |         33 |        42464 |   47192
 353238060035945 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43775 |   47178
 352613070408087 | SO-12431 |               577 | SERVICE-vzwretail_cnione |        132 |        43779 |   47167
 353238060039236 | SO-12436 |               699 | SERVICE-vzwretail_cnione |        156 |        43812 |   47173
 353238060034021 | SO-12436 |               699 | SERVICE-vzwretail_cnione |        156 |        43818 |   47172
 352613070119338 | SO-12414 |               577 | SERVICE-vzwretail_cnione |        132 |        43858 |   47141
 352613070311158 | SO-12433 |               577 | SERVICE-vzwretail_cnione |        132 |        43863 |   47168
 352613070309996 | SO-12437 |               577 | SERVICE-vzwretail_cnione |        132 |        43866 |   47174
 352613070293687 | SO-12435 |               577 | SERVICE-vzwretail_cnione |        132 |        43867 |   47171
 353238060192126 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43873 |   47175
 353238060025201 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43874 |   47176
 353238060061024 | SO-12438 |               699 | SERVICE-vzwretail_cnione |        156 |        43875 |   47177
 352613070440908 | SO-12442 |               577 | SERVICE-vzwretail_cnione |        132 |        43917 |   47190
 352613070394477 | SO-12443 |               577 | SERVICE-vzwretail_cnione |        132 |        43919 |   47191
 352613070252451 | SO-12445 |               577 | SERVICE-vzwretail_cnione |        132 |        43924 |   47193
 352613070446004 | SO-12442 |               577 | SERVICE-vzwretail_cnione |        132 |        43926 |   47189
(38 rows)



select * from ops_api_assign('A10000157D1D3D', 'SO-12444',577, 'SERVICE-acfn' ,TRUE, 33, FALSE);


 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        43812 | ESN DEC                | 89148000003298404612 |       | 2018-08-09   | 
        43812 | ESN HEX                | 353238060039236      |       | 2018-08-09   | 
        43812 | MAC ADDRESS            | 00042D0666B4         |       | 2018-08-09   | 
        43812 | MDN                    | 4043271503           |       | 2018-08-09   | 
        43812 | MIN                    | 4043271503           |       | 2018-08-09   | 
        43812 | SERIAL NUMBER          | 419508               |       | 2018-08-09   | 
(6 rows)


select * from ops_api_assign('353238060039236', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);

   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;

select * from ops_api_activate('353238060039236'
                              , '89148000003298404612'
                              , '4043271503'
                              , '4043271503'
                              , '419508'
                              , '00042D0666B4'
                              , 171
                              , 'vzw3g'
                              , 'vzw3g')


select * from ops_api_activate('353238060034021'
                              , '89148000003298403028'
                              , '4043271521'
                              , '4043271521'
                              , '419510'
                              , '00042D0666B6'
                              , 171
                              , 'vzw3g'
                              , 'vzw3g')


select * from ops_api_assign('353238060034021', 'SO-12436', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
select * from ops_api_assign('352613070119338', 'SO-12414', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070311158', 'SO-12433', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070309996', 'SO-12437', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070293687', 'SO-12435', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('353238060035945', 'SO-12438', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
select * from ops_api_assign('353238060192126', 'SO-12438', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
select * from ops_api_assign('353238060025201', 'SO-12438', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
select * from ops_api_assign('353238060061024', 'SO-12438', 699, 'SERVICE-vzwretail_cnione', TRUE, 156, FALSE);
select * from ops_api_assign('352613070408087', 'SO-12431', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070440908', 'SO-12442', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070394477', 'SO-12443', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070252451', 'SO-12445', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);
select * from ops_api_assign('352613070446004', 'SO-12442', 577, 'SERVICE-vzwretail_cnione', TRUE, 132, FALSE);






select * 
  from unique_identifier 
 where unique_identifier_type = 'ESN HEX'
   and value in (
'A10000157D1D3D',
'353238060039236',
'353238060034021',
'352613070119338',
'352613070311158',
'352613070309996',
'352613070293687',
'353238060035945',
'353238060192126',
'353238060025201',
'353238060061024',
'352613070408087',
'352613070440908',
'352613070394477',
'352613070252451',
'352613070446004');
 equipment_id | unique_identifier_type |      value      | notes | date_created | date_modified 
--------------+------------------------+-----------------+-------+--------------+---------------
        42464 | ESN HEX                | A10000157D1D3D  |       | 2017-03-24   | 
        43728 | ESN HEX                | 353238060039236 |       | 2018-09-18   | 
(2 rows)



   par_esn_hex                 text    := $1;
   par_esn_dec	               text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;





INSERT INTO receiving_lot (receiving_lot_id, description, receiving_status, purchase_order_date, ship_date, received_date, item_count, vendor)

INSERT INTO equipment(equipment_id, equipment_type, equipment_model_id, receiving_lot_id, enabled_flag)

INSERT INTO equipment_status(equipment_id, equipment_status_type, date_created)



INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)
INSERT INTO unique_identifier(equipment_id, unique_identifier_type, value, date_created)



INSERT INTO username(username, billing_entity_id, primary_service, enabled, start_date, end_date, date_created, auth_pod)



INSERT INTO radcheck(username, attribute, op, value)
INSERT INTO radcheck(username, attribute, op, value)



INSERT INTO usergroup(username, groupname, priority)


 equipment_id |     esn_hex     
--------------+-----------------
        42464 | A10000157D1D3D
        43812 | 353238060039236
        43818 | 353238060034021
        43858 | 352613070119338
        43863 | 352613070311158
        43866 | 352613070309996
        43867 | 352613070293687
        43775 | 353238060035945
        43873 | 353238060192126
        43874 | 353238060025201
        43875 | 353238060061024
        43779 | 352613070408087
        43917 | 352613070440908
        43919 | 352613070394477
        43924 | 352613070252451
        43926 | 352613070446004
(16 rows)


select line_id
  from line_equipment
 where equipment_id in
(
 42464
 ,43812
 ,43818
 ,43858
 ,43863
 ,43866
 ,43867
 ,43775
 ,43873
 ,43874
 ,43875
 ,43779
 ,43917
 ,43919
 ,43924
 ,43926
);

select * from unique_identifier where equipment_id = 43866;
 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        43866 | ESN DEC                | 89148000004023158895 |       | 2018-08-28   | 
        43866 | ESN HEX                | 352613070309996      |       | 2018-08-28   | 
        43866 | MAC ADDRESS            | 00804413A3B1         |       | 2018-08-28   | 
        43866 | MDN                    | 4704215622           |       | 2018-08-28   | 
        43866 | MIN                    | 4704215622           |       | 2018-08-28   | 
        43866 | SERIAL NUMBER          | S11554               |       | 2018-08-28   | 
(6 rows)

csctoss=# \e
 equipment_id | equipment_model_id | model_number1 
--------------+--------------------+---------------
        43866 |                186 | SL-05-E2-CV1


ESN HEX                 352613070309996      
ESN DEC                 89148000004023158895 
MDN                     4704215622           
MIN                     4704215622           
SERIAL NUMBER           S11554               
MAC ADDRESS             00804413A3B1         


   par_esn_hex                 text    := $1;
   par_esn_dec                 text    := $2;
   par_mdn                     text    := $3;
   par_min                     text    := $4;
   par_serial_number           text    := $5;
   par_mac_address             text    := $6;
   par_equipment_model_id      integer := $7;
   par_realm                   text    := $8;
   par_carrier                 text    := $9;


select * from ops_api_activate('352613070309996'
                              , '89148000004023158895'
                              , '4704215622'
                              , '4704215622'
                              , 'S11554'
                              , '00804413A3B1'
                              , 186
                              , 'vzw3g'
                              , 'vzw3g');

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
   where uie.value = '352613070309996';
 line_id | equipment_id |   radius_username    |     mac      | serialno |     esn_hex     
---------+--------------+----------------------+--------------+----------+-----------------
   47174 |        43866 | 4704215622@vzw3g.com | 00804413A3B1 | S11554   | 352613070309996
(1 row)



    par_esn_hex                        352613070309996
    par_sales_order                    SO-12437
    par_billing_entity_id              577
    par_groupname                      SERVICE-vzwretail_cnione
    par_static_ip_boolean              TRUE
    par_product_code                   'MRC-005-01RP-EVV'


csctoss=# BEGIN;
BEGIN
select * from ops_api_assign('352613070309996', 'SO-12437', 577, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-005-01RP-EVV', FALSE);
NOTICE:  Sales Order: SO-12437
NOTICE:  ESN: 352613070309996
NOTICE:  CARRIER: VZW
NOTICE:  MDN/MIN: 4704215622
NOTICE:  USERNAME: 4704215622@vzw3g.com USERGROUP: SERVICE-vzwretail_cnione
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4704215622@vzw3g.com][line_id=46965][billing_entity_id=577]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found IP pool.
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.150.59]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Class attribute value into radreply table. [line_id=46965]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Class attribute value into radreply table. [line_id=46965]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.150.59]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.150.59]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  Updating static_ip_pool table for [IP=10.81.150.59 / VRF=SERVICE-vzwretail_cnione]
CONTEXT:  SQL statement "SELECT  * FROM ops_api_static_ip_assign( $1 , $2 , $3 , $4 , $5 )"
PL/pgSQL function "ops_api_assign" line 293 at select into variables
NOTICE:  STATIC IP: 10.81.150.59
NOTICE:  Inserting Warranty Info into equipment_warranty table
 result_code |            error_message             
-------------+--------------------------------------
 t           | Line assignment is done succesfully.
(1 row)

csctoss=# commit;
COMMIT
csctoss=# 



select * from ops_api_assign('352613070309996', 'SO-12437', 577, 'SERVICE-vzwretail_cnione', TRUE, 'MRC-005-01RP-EVV', FALSE);



