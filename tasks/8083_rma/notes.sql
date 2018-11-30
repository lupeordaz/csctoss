
SELECT *                                                
        FROM unique_identifier ui
        JOIN line_equipment le ON (ui.equipment_id = le.equipment_id)
        where 1=1
           and  ui.unique_identifier_type = 'ESN HEX'
           and ui.value = 'A1000036981D4E'
           AND le.end_date IS NULL;
-[ RECORD 1 ]-------------+---------------
equipment_id              | 39911
unique_identifier_type    | ESN HEX
value                     | A1000036981D4E
notes                     | 
date_created              | 2014-10-16
date_modified             | 
line_id                   | 40191
equipment_id              | 39911
start_date                | 2014-11-11
end_date                  | 
billing_entity_address_id | 619
ship_date                 | 
install_date              | 
installed_by              | 


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
       AND l.end_date IS NULL
       ;



-[ RECORD 1 ]-----+-----------------------
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


SELECT value 
  FROM unique_identifier
 WHERE 1=1
   AND equipment_id = 39911
   AND unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]-
value | 890725

SELECT groupname 
    FROM usergroup
    WHERE username = '4049853138@vzw3g.com'
    order by priority desc
    LIMIT 1;

-[ RECORD 1 ]-----------------------
groupname | SERVICE-vzwretail_cnione


SELECT value INTO v_old_ip
    FROM radreply
    WHERE username = '4049853138@vzw3g.com'
      AND attribute = 'Framed-IP-Address';

-[ RECORD 1 ]------
v_old_ip | 10.81.21.87

SELECT ui.equipment_id INTO v_nequipid
    FROM unique_identifier ui
    JOIN equipment eq ON (ui.equipment_id = eq.equipment_id)
    WHERE 1 = 1
    AND ui.unique_identifier_type = 'ESN HEX'
    AND ui.value = in_new_esn

-[ RECORD 1 ]+------
v_nequipid | 38677


SELECT model_number1,e.equipment_model_id into v_new_model,v_new_mod_ext_id
    FROM equipment e
    JOIN equipment_model em ON (e.equipment_model_id=em.equipment_model_id)
    WHERE 1=1
       AND e.equipment_id=v_nequipid;

v_new_model      | Systech 8100EVE
v_new_mod_ext_id | 76


SELECT value INTO v_new_sn
     FROM unique_identifier
     WHERE 1=1
       and equipment_id = v_nequipid
       and unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]-
v_new_sn | 868427


SELECT value INTO v_old_sn
FROM unique_identifier
WHERE 1=1
   and equipment_id = v_oequipid
   and unique_identifier_type = 'SERIAL NUMBER';

-[ RECORD 1 ]-
v_old_sn | 890725

SELECT carrier INTO v_carrier
FROM equipment e
JOIN equipment_model em ON (e.equipment_model_id = em.equipment_model_id)
WHERE 1=1
  AND e.equipment_id = v_nequipid;

-[ RECORD 1 ]--
v_carrier | VZW


SELECT username INTO v_new_username
  FROM username u,
       unique_identifier ui
 WHERE 1=1
   AND substring(u.username FROM 1 FOR 10) = ui.value
   AND ui.equipment_id=v_nequipid
   AND ui.unique_identifier_type = 'MDN';

-[ RECORD 1 ]--+---------------------
v_new_username | 4048072812@vzw3g.com


SELECT groupname as v_new_groupname
  FROM groupname_default gd
 WHERE 1=1
   AND gd.carrier = v_carrier
   AND gd.billing_entity_id = v_beid;

-[ RECORD 1 ]---+-------------------------
v_new_groupname | SERVICE-vzwretail_cnione



select * from rt_oss_rma('A1000036981D4E','A1000043951158',925);

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
NOTICE:  [rt_oss_rma] BEFORE INSERT into line_equipment: line_id=40191, old_equipment_id=39911, new_equipment_id=38677, end_date=2018-08-06
 billing_entity_id | old_equip_id | old_model | old_sn | old_username | new_equip_id | new_model | new_sn | rma_so_num | line_id | carrier | username | groupname |
                             message                              
-------------------+--------------+-----------+--------+--------------+--------------+-----------+--------+------------+---------+---------+----------+-----------+
------------------------------------------------------------------
                   |              |           |        |              |              |           |        |            |         |         |          |           |
 Insert new row into ine_equipment with new equipment id for line
(1 row)








csctoss=# begin;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

csctoss=# UPDATE line_equipment SET end_date = '2018-08-05' WHERE line_id = 46736 AND equipment_id = 38677 AND end_date = '2018-08-06';
UPDATE 1
csctoss=# commit;
COMMIT
csctoss=# select * from oss.rt_oss_rma('A1000036981D4E','A1000043951158','Test');
ERROR:  schema "oss" does not exist
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
NOTICE:  [rt_oss_rma] Inserted into line_equipment succeeded. Move on to static IP handling.
NOTICE:  ops_api_static_ip_assign is called: parameters => [carrier=VZW][vrf=SERVICE-vzwretail_cnione][username=4048072812@vzw3g.com][line_id=40191][billing_entity_id=577]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  We found IP pool.
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  We found an available IP address in the IP pool. [IP=10.81.150.85]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  Inserting Class attribute value into radreply table. [line_id=40191]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  Inserted Class attribute value into radreply table. [line_id=40191]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  Inserting Framed-IP-Address attribute value into radreply table. [IP=10.81.150.85]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  Inserted Framed-IP-Address attribute value into radreply table. [IP=10.81.150.85]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  Updating static_ip_pool table for [IP=10.81.150.85 / VRF=SERVICE-vzwretail_cnione]
CONTEXT:  SQL statement "SELECT  * from ops_api_static_ip_assign( $1 ::text,  $2 ::text,  $3 ::text,  $4 ::integer,  $5 ::integer)"
PL/pgSQL function "rt_oss_rma" line 473 at select into variables
NOTICE:  ops_api_static_ip return: 10.81.150.85
NOTICE:  rt_oss_rma: Sucessfully updated new username  
NOTICE:  -----------  calling jbilling_rma ------------------------------------- 
NOTICE:   the sql to call jbilling_rma: SELECT * from oss.rt_jbilling_rma(577 , 76 , 'A1000036981D4E' , 'A1000043951158' , '868427' , '4048072812@vzw3g.com',40191,'Test')
NOTICE:  rt_oss_rma: Returned from Jbilling: RMA-1670
 billing_entity_id | old_equip_id |    old_model    | old_sn |     old_username     | new_equip_id |    new_model    | new_sn | rma_so_num | line_id | carrier |   
    username       |        groupname         | message 
-------------------+--------------+-----------------+--------+----------------------+--------------+-----------------+--------+------------+---------+---------+---
-------------------+--------------------------+---------
               577 |        39911 | Systech 8100EVE | 890725 | 4049853138@vzw3g.com |        38677 | Systech 8100EVE | 868427 | RMA-1670   |   40191 | VZW     | 40
48072812@vzw3g.com | SERVICE-vzwretail_cnione | Success
(1 row)

csctoss=# 