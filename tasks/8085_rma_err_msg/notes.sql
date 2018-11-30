-- rt_oss_rma('A1000036981D4E','A1000043951158'

select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = 'A1000036981D4E';
 line_id | equipment_id | start_date | end_date |   radius_username    |     mac      | serialno |    esn_hex     
---------+--------------+------------+----------+----------------------+--------------+----------+----------------
   40191 |        39911 | 2014-11-11 |          | 4049853138@vzw3g.com | 008044118832 | 890725   | A1000036981D4E
(1 row)


select l.line_id                                                         
        ,le.equipment_id
        ,le.start_date
        ,le.end_date
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le                                                                                         
    join line l on l.line_id = le.line_id                                                                      
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uie.value = 'A1000043951158';
 line_id | equipment_id | start_date |  end_date  |   radius_username    |     mac      | serialno |    esn_hex     
---------+--------------+------------+------------+----------------------+--------------+----------+----------------
   38898 |        38677 | 2014-06-20 | 2015-08-14 | 4047091141@vzw3g.com | 0080441115E4 | 868427   | A1000043951158
   46736 |        38677 | 2018-05-15 |            | 4048072812@vzw3g.com | 0080441115E4 | 868427   | A1000043951158
(2 rows)


SELECT ui.value ,
        l.radius_username ,
        be.billing_entity_id ,
        be.name ,
        l.line_id ,
        ui.equipment_id ,
        l.start_date ,
        l.end_date ,
        le.start_date ,
        le.end_date ,
        l.notes
    FROM unique_identifier ui
       JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
       JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
       JOIN line l ON (le.line_id = l.line_id)
       JOIN billing_entity be ON (l.billing_entity_id = be.billing_entity_id)
       WHERE 1 = 1
       AND ui.unique_identifier_type = 'ESN HEX'
       AND ui.value = 'A1000036981D4E'
       AND le.end_date IS NULL
       AND l.end_date IS NULL;


v_esnhex             | A1000036981D4E
v_old_username       | 4049853138@vzw3g.com
v_beid               | 577
v_bename             | ACFN
v_line_id            | 40191
v_oequipid           | 39911
v_lstrtdat           | 2014-11-11 00:00:00+00
v_lenddat            | 
v_lestrtdat          | 2014-11-11
v_leenddat           | 
v_notes              | SO-9293

v_old_sn             | 890725
v_old_groupname      | SERVICE-vzwretail_cnione
v_old_ip             | 10.81.21.87




SELECT value as v_old_sn
  FROM unique_identifier
 WHERE 1=1
   AND equipment_id = 39911
   AND unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]----
v_old_sn | 890725

SELECT groupname as v_old_groupname
FROM usergroup
WHERE username = '4049853138@vzw3g.com'
order by priority desc
LIMIT 1;

-[ RECORD 1 ]---+-------------------------
v_old_groupname | SERVICE-vzwretail_cnione

SELECT value as v_old_ip
FROM radreply
WHERE username = '4049853138@vzw3g.com'
  AND attribute = 'Framed-IP-Address';

-[ RECORD 1 ]---------
v_old_ip | 10.81.21.87


--

SELECT ui.equipment_id as v_nequipid
FROM unique_identifier ui
JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
WHERE 1 = 1
AND ui.unique_identifier_type = 'ESN HEX'
AND ui.value = 'A1000043951158';

v_nequipid | 38677

--

SELECT model_number1 as v_new_model
      ,e.equipment_model_id as v_new_mod_ext_id
FROM equipment e
JOIN equipment_model em ON (e.equipment_model_id=em.equipment_model_id)
WHERE 1=1
   AND e.equipment_id=38677;

-[ RECORD 1 ]----+----------------
v_new_model      | Systech 8100EVE
v_new_mod_ext_id | 76


SELECT value as v_new_sn
  FROM unique_identifier
 WHERE 1=1
   and equipment_id = 38677
   and unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]----
v_new_sn | 868427


SELECT value as v_old_sn
FROM unique_identifier
WHERE 1=1
   and equipment_id = 39911
   and unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]----
v_old_sn | 890725


--

SELECT carrier aS v_carrier
FROM equipment e
JOIN equipment_model em ON (e.equipment_model_id = em.equipment_model_id)
WHERE 1=1
  AND e.equipment_id = 38677;

-[ RECORD 1 ]--
v_carrier | VZW

--

SELECT username AS v_new_username
  FROM username u,
       unique_identifier ui
WHERE 1=1
  AND substring(u.username FROM 1 FOR 10) = ui.value
  AND ui.equipment_id=38677
  AND ui.unique_identifier_type = 'MIN'
--          AND u.end_date = to_date('2999-12-31','yyyy-mm-dd')
    ;

-[ RECORD 1 ]--+---------------------
v_new_username | 4048072812@vzw3g.com


SELECT groupname INTO v_new_groupname
FROM groupname_default gd
WHERE 1=1
  AND gd.carrier = 'VZW'
  AND gd.billing_entity_id = 577;

-[ RECORD 1 ]---+-------------------------
v_new_groupname | SERVICE-vzwretail_cnione

--
v_static_ip:=true;
--

      RAISE NOTICE '----- Begin Function data ----------';
      RAISE NOTICE 'old ESN           : %',A1000036981D4E;
      RAISE NOTICE 'old ip            : %',10.81.21.87;
      RAISE NOTICE 'old username      : %',4049853138@vzw3g.com;
      RAISE NOTICE 'old groupname     : %',SERVICE-vzwretail_cnione;
      RAISE NOTICE 'old equipment id  : %',39911;
      RAISE NOTICE 'old model         : %',v_old_model;
      RAISE NOTICE 'new ESN           : %',A1000043951158;
      RAISE NOTICE 'new equipment id  : %',38677;
      RAISE NOTICE 'new model         : %',Systech 8100EVE;
      RAISE NOTICE 'carrier           : %',VZW;
      RAISE NOTICE 'billing entity    : %',577;
      RAISE NOTICE 'billing entity nm : %',ACFN;
      RAISE NOTICE 'new username      : %',4048072812@vzw3g.com;
      RAISE NOTICE 'new groupname     : %',SERVICE-vzwretail_cnione;
      RAISE NOTICE 'static ip?        : %',true;
      RAISE NOTICE '----- End of Function data ----------';



select * from line_equipment where equipment_id = 38677;

 line_id | equipment_id | start_date |  end_date  | billing_entity_address_id | ship_date | install_date | installed_by 
---------+--------------+------------+------------+---------------------------+-----------+--------------+--------------
   38898 |        38677 | 2014-06-20 | 2015-08-14 |                       619 |           |              | 
   46736 |        38677 | 2018-05-15 |            |                       181 |           |              | 
(2 rows)

BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

UPDATE line_equipment SET end_date = '2018-08-07' where line_id = 46736 and equipment_id = 38677;
UPDATE 1
commit;
COMMIT




csctoss=# select * from rt_oss_rma('A1000036981D4E','A1000043951158','Test');
NOTICE:  -----------  IN RT_OSS_RMA FUNCTION NOW  ---------------------------
NOTICE:  rt_oss_rma: setting change_log_staff_id
NOTICE:  rt_oss_rma:  change_log_staff_id has been set
NOTICE:  rt_oss_rma: looking for new ESN in UI table: A1000043951158
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  Billing Entity: 577: ACFN
NOTICE:  -------------------------------------------------------------------------------------------------
NOTICE:  rt_oss_rma: Verifying groupname present for old username
NOTICE:  rt_oss_rma:  Serial number found for original esn: A1000036981D4E equip id: 39911
NOTICE:  ----- Begin Function data ----------
NOTICE:  old ESN           : A1000036981D4E
NOTICE:  old ip            : 10.81.21.87
NOTICE:  old username      : 4049853138@vzw3g.com
NOTICE:  old groupname     : SERVICE-vzwretail_cnione
NOTICE:  old equipment id  : 39911
NOTICE:  old model         : <NULL>
NOTICE:  new ESN           : A1000043951158
NOTICE:  new equipment id  : 38677
NOTICE:  new model         : Systech 8100EVE
NOTICE:  carrier           : VZW
NOTICE:  billing entity    : 577
NOTICE:  billing entity nm : ACFN
NOTICE:  new username      : 4048072812@vzw3g.com
NOTICE:  new groupname     : SERVICE-vzwretail_cnione
NOTICE:  static ip?        : t
NOTICE:  ----- End of Function data ----------
NOTICE:  Deleted 2 rows related to old username(4049853138@vzw3g.com) rows from radreply % 
NOTICE:  Deleted 1 rows related to old username  from radcheck: % 
NOTICE:  Deleted 1 rows related to new username from radcheck: % 
NOTICE:  this sql: UPDATE usergroup SET groupname =SERVICE-rma_vzwretail_cnione , priority=50000 WHERE 1=1 AND username=4049853138@vzw3g.com
NOTICE:  Deletion completed- now beginning insert of new usergroup data for username: 4048072812@vzw3g.com
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=40191, old_equipment_id=39911, new_equipment_id=38677, end_date=2018-08-07
NOTICE:  rt_oss_rma: when raise_exception:Insert new row into ine_equipment with new equipment id for line
-[ RECORD 1 ]-----+-----------------------------------------------------------------
billing_entity_id | 
old_equip_id      | 
old_model         | 
old_sn            | 
old_username      | 
new_equip_id      | 
new_model         | 
new_sn            | 
rma_so_num        | 
line_id           | 
carrier           | 
username          | 
groupname         | 
message           | Insert new row into ine_equipment with new equipment id for line

--


--         Validate replacement line_equipment end_date
     v_errmsg:='Line_equipment end_date for replacement unit cannot be current date';
     select count(*) into v_count 
       from line_equipment
      where 1=1
        and le.line_id = v_line_id
        and le.end_date = current_date;
     IF v_count > 0 then
          RAISE NOTICE 'DATA ERROR: %',v_errmsg;
          RAISE EXCEPTION  '';
     END IF;



     INSERT INTO line_equipment
         ( SELECT v_line_id::integer,v_nequipid::integer,current_date,
                  null,billing_entity_address_id,ship_date,install_date,installed_by
           from line_equipment le
           where 1=1
             and le.line_id=v_line_id
             and le.equipment_id=v_oequipid
             and le.end_date =current_date);
     GET DIAGNOSTICS v_numrows = ROW_COUNT;


--


 select l.line_id                                                         
      ,le.equipment_id
      ,le.start_date
      ,le.end_date
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
 where le.end_date is not null
   and em.carrier = 'VZW';

 line_id | equipment_id | start_date |  end_date  |        radius_username         |             mac             |       serialno       |       esn_hex        
---------+--------------+------------+------------+--------------------------------+-----------------------------+----------------------+----------------------
   42367 |        40724 | 2015-08-03 | 2016-08-24 | 4043097565@vzw3g.com           | 008044121893                | 922742               | 000A10000438945FD
   45726 |        43044 | 2017-09-08 | 2017-10-10 | 4704461468@vzw3g.com           | 008044135030                | S05513               | 00A1000051C1EDCE
   45132 |        42707 | 2017-05-23 | 2017-05-23 | 4705122536@vzw3g.com           | 00804412CE5B                | A09997               | 00A1000051C2DC89
   45089 |        42650 | 2017-05-16 | 2017-06-06 | 4703665345@vzw3g.com           | 00804412CEDD                | A10101               | 00A1000051C2DD68
   45119 |        42708 | 2017-05-23 | 2017-05-23 | 4704213351@vzw3g.com           | 00804412CE74                | A10031               | 00A1000051C2DF73
   45557 |        42903 | 2017-08-14 | 2018-04-04 |                                | 00804412F052                | S03390               | 00A1000051E72CF9
   45515 |        42855 | 2017-08-02 | 2018-02-02 |                                | 00804412F07C                | S03401               | 00A1000051E72D0C
   45512 |        42907 | 2017-08-02 | 2018-01-30 |                                | 00804412F04F                | S03393               | 00A1000051E72D0D
   45510 |        42904 | 2017-08-02 | 2018-01-30 |                                | 00804412F086                | S03464               | 00A1000051E7350D
   45514 |        42847 | 2017-08-02 | 2018-01-30 |                                | 00804412F068                | S03413               | 00A1000051E73761
   45266 |        42798 | 2017-06-20 | 2017-10-02 | 4704461450@vzw3g.com           | 00804412F064                | S03422               | 00A1000051E73792
   45293 |        42804 | 2017-06-22 | 2018-06-14 |                                | 00804412F062                | S03421               | 00A1000051E73CE2
    1748 |          971 | 2008-11-03 | 2015-06-19 |                                | 000C43256101                | 8H08101232           | 0830776E
   42538 |        40571 | 2015-09-04 | 2016-08-02 |                                | 0008044101FC4               | 0760994              | 0A10000157DC938
   44010 |        40571 | 2016-09-07 | 2017-01-10 |                                | 0008044101FC4               | 0760994              | 0A10000157DC938
   44480 |        40571 | 2017-01-11 | 2017-04-26 |                                | 0008044101FC4               | 0760994              | 0A10000157DC938
   40400 |        39993 | 2014-12-19 | 2015-10-20 | 4046158286@vzw3g.com           | 008044117C1F                | 890547               | 270113183009977701-o
   46695 |        43462 | 2018-04-27 | 2018-05-10 | 4707174366@vzw3g.com           | 00804413B8B1                | S15816               | 352613070136233
   41248 |        43336 | 2018-01-03 | 2018-01-05 | 4707174357@vzw3g.com           | 00804413A14A                | S11424               | 352613070168657
   46246 |        43334 | 2017-12-20 | 2018-01-15 | 4706265802@vzw3g.com           | 00804413A108                | S11497               | 352613070210434
   46156 |        43281 | 2017-11-16 | 2018-03-12 |                                | 008044139F5A                | S09169               | 352613070215896
   46133 |        43225 | 2017-11-10 | 2018-03-06 | 4706266496@vzw3g.com           | 00804413A149                | S11423               | 352613070220961
   46258 |        43329 | 2017-12-21 | 2018-06-13 | 4706069250@vzw3g.com           | 00804413A12B                | S11406               | 352613070222652
   46448 |        43446 | 2018-02-27 | 2018-02-27 | 4706265774@vzw3g.com           | 00804413B423                | S15873               | 352613070227719
   46396 |        43429 | 2018-01-26 | 2018-03-09 | 4706265778@vzw3g.com           | 00804413B3C0                | S15919               | 352613070247261
   33375 |        33242 | 2013-03-07 | 2015-09-25 | 4047800000@vzw3g.com           | 00804410155C                | 761926               | 352613070261775
   39021 |        33242 | 2016-06-10 | 2016-07-12 | 4702497892@vzw3g.com           | 00804410155C                | 761926               | 352613070261775
   41596 |        33242 | 2017-10-06 | 2017-10-06 | 4047802184@vzw3g.com           | 00804410155C                | 761926               | 352613070261775


select * from rt_oss_rma('A1000036981D4E','352613070136233','Test');


