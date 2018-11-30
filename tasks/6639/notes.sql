csctoss=# \e
 equipment_id 
--------------
        15500
(1 row)

csctoss=# select line_id from line_equipment where equipment_id = 15500;
 line_id 
---------
   14815
(1 row)

csctoss=# 

csctoss=# select * from unique_identifier where equipment_id = 15500;
 equipment_id | unique_identifier_type |    value    | notes | date_created | date_modified 
--------------+------------------------+-------------+-------+--------------+---------------
        15500 | ESN DEC                | 24601501612 |       | 2010-04-28   | 
        15500 | ESN HEX                | F616E9AC    |       | 2010-04-28   | 
        15500 | MAC ADDRESS            | 0DF495      |       | 2010-08-24   | 
        15500 | MDN                    | 3124376744  |       | 2010-04-28   | 
        15500 | MIN                    | 3124376744  |       | 2010-04-28   | 
        15500 | SERIAL NUMBER          | 621797      |       | 2010-08-24   | 
(6 rows)


SELECT value 
    FROM radreply
    WHERE username = '3124376744@uscc.net'
    AND attribute = 'Framed-IP-Address';


     value     
---------------
 10.56.113.199
(1 row)



IF NOT EXISTS( 

SELECT TRUE 
  FROM usergroup 
 WHERE username LIKE '3124376744@uscc.net' 
   AND groupname LIKE '%disconnected' 
   AND priority = 1
 bool 
------
(0 rows)


----  JBilling side

--  archive_equipment()

-- Get the order_id
SELECT order_id
  FROM prov_line
 WHERE end_date IS NULL
 AND archived IS NULL
 AND start_date IS NOT NULL
 --AND acct_start_date IS NOT NULL
 AND esn_hex = 'F616E9AC'
 LIMIT 1;


var_order_id
----------
var_order_id=5401


--public_number:

SELECT public_number, create_datetime::date
  FROM purchase_order po
 WHERE status_id = 16
   AND id = 5401;

var_public_number | SO-1889O
var_rev_created   | 2016-12-12

Creating a new sales order revision for SO-1889O passing in 

par_esn_hex       :  'F616E9AC'
var_public_number :  'SO-1889O'


-- Get purchase_order.id based on current active purchase order.

SELECT id 
  FROM purchase_order
 WHERE public_number = 'SO-1889O' 
   AND status_id = 16
   and deleted = 0;

var_old_po_id | 5401

Old Purchase Order ID: 5401 


-- Call to get_unique_id_for_jbilling

SELECT purchase_order_id, 
          contact_id,
          order_line_id,
          contact_map_id
     INTO 
          var_new_po_id,
          var_new_contact_id,
          var_new_ol_id,
          var_new_contact_map_id
   FROM  oss.get_unique_id_for_jbilling() ;
   RAISE NOTICE 'New Purchase Order ID: %', var_new_po_id;


 purchase_order_id | contact_id | order_line_id | contact_map_id 
-------------------+------------+---------------+----------------
              8595 |       8866 |         20524 |           8061




SELECT * 
  FROM contact_map
 WHERE table_id = 21  -- purchase_order table
   AND foreign_id = 5401;
   id   | contact_id | type_id | table_id | foreign_id | optlock 
--------+------------+---------+----------+------------+---------
   5116 |       5614 |       1 |       21 |       5401 |       1
 684601 |       6701 |       1 |       21 |       5401 |       




jbilling=# BEGIN;
BEGIN
jbilling=# select * from oss.archive_equipment('F616E9AC');
INFO:  var_order_id=5401
INFO:  Creating a new sales order revision for SO-1889O.
NOTICE:  Old Purchase Order ID: 5401
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Purchase Order ID: 8574
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Got new IDs [purchase_order_id=8574, contact_id=8845, order_line_id=20368, contact_map_id=8040]
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20368
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20368 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20369
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20369 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Create a new contact_map. [var_new_contact_id=8845, var_new_po_id=8574, var_new_contact_map_id=8040, var_old_po_id=5401
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) SELECT  $1 , type_id,  $2 , '21', 1,  $3  FROM contact_map WHERE table_id = 21 AND foreign_id =  $4 "
PL/pgSQL function "create_new_revision" line 165 at SQL statement
PL/pgSQL function "archive_equipment" line 50 at IF
jbilling=# rollback;
ROLLBACK

jbilling=# \d+ contact_map
                                           Table "public.contact_map"
   Column   |  Type   |                            Modifiers                            | Storage | Description 
------------+---------+-----------------------------------------------------------------+---------+-------------
 id         | integer | not null default nextval(('"contact_map_seq"'::text)::regclass) | plain   | 
 contact_id | integer |                                                                 | plain   | 
 type_id    | integer | not null                                                        | plain   | 
 table_id   | integer | not null                                                        | plain   | 
 foreign_id | integer | not null                                                        | plain   | 
 optlock    | integer | not null                                                        | plain   | 
Indexes:
    "contact_map_pkey" PRIMARY KEY, btree (id)
    "contact_map_i_1" btree (table_id, foreign_id, type_id)
    "contact_map_i_3" btree (contact_id)
Foreign-key constraints:
    "contact_map_fk_1" FOREIGN KEY (table_id) REFERENCES jbilling_table(id)
    "contact_map_fk_2" FOREIGN KEY (type_id) REFERENCES contact_type(id)
    "contact_map_fk_3" FOREIGN KEY (contact_id) REFERENCES contact(id) ON DELETE CASCADE
Triggers:
    contact_map_audit AFTER INSERT OR DELETE OR UPDATE ON contact_map FOR EACH ROW EXECUTE PROCEDURE audit.if_modified_func()
Has OIDs: no

jbilling=# 


--


var_old_po_id           : 5401

var_new_contact_id      : 8845
var_new_po_id           : 8574
var_new_contact_map_id  : 8040

SELECT * 
  FROM contact_map
 WHERE table_id = 21  -- purchase_order table
   AND foreign_id = 5401;
   id   | contact_id | type_id | table_id | foreign_id | optlock 
--------+------------+---------+----------+------------+---------
   5116 |       5614 |       1 |       21 |       5401 |       1
 684601 |       6701 |       1 |       21 |       5401 |       

--
                8845         1         21         

-- Create a new contact_map.
INSERT INTO contact_map
 (contact_id, type_id, foreign_id, table_id, OPTLOCK, id)
SELECT
 var_new_contact_id, type_id, var_new_po_id, '21', 1, var_new_contact_map_id 
FROM contact_map
WHERE table_id = 21  -- purchase_order table
AND foreign_id = var_old_po_id;

GET DIAGNOSTICS var_num_affected = ROW_COUNT;
IF var_num_affected = 0 THEN
 RAISE EXCEPTION '[oss.create_new_revision(text, text)] Inserting a new contact_map failed.';
END IF;


NOTICE:  Create a new contact_map. [var_new_contact_id=8845, var_new_po_id=8574, var_new_contact_map_id=8040, var_old_po_id=5401
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement 

    "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) 
     SELECT  $1 
            ,type_id
            ,$2 
            ,'21'
            ,1
            ,$3  
       FROM contact_map 
      WHERE table_id = 21 
        AND foreign_id =  $4 "

$1 - 8845
$2 - 8574
$3 - 8040

$4 - 5401

PL/pgSQL function "create_new_revision" line 165 at SQL statement
PL/pgSQL function "archive_equipment" line 50 at IF


SELECT  8845 
       ,type_id
       ,8574
       ,'21'
       , 1
       ,8040
  FROM contact_map 
 WHERE table_id = 21 
   AND foreign_id = 5401;
 ?column? | type_id | ?column? | ?column? | ?column? | ?column? 
----------+---------+----------+----------+----------+----------    |
     8845 |       1 |     8574 | 21       |        1 |     8040     |  Causes the duplicates
     8845 |       1 |     8574 | 21       |        1 |     8040     |
(2 rows)



jbilling=# select * from contact_map where contact_id = 8845;
  id  | contact_id | type_id | table_id | foreign_id | optlock 
------+------------+---------+----------+------------+---------
 8040 |       8845 |       1 |       21 |       8574 |       1
(1 row)



--- 

var_old_po_id           : 5002

var_new_contact_id      : 8866
var_new_po_id           : 8595
var_new_contact_map_id  : 8061


NOTICE:  Create a new contact_map. [var_new_contact_id=8866, var_new_po_id=8595, var_new_contact_map_id=8061, var_old_po_id=5002
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement 
      "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) 
       SELECT 8061 
              ,type_id
              ,8595
              ,'21'
              ,1
              ,8866  
        FROM contact_map 
       WHERE table_id = 21 
         AND foreign_id =  5002 "



-- Unable to cancel device in JBilling A10000157ED68C


BEGIN;
BEGIN
jbilling=# select * from oss.archive_equipment('F616E9AC');
INFO:  var_order_id=5401
INFO:  Creating a new sales order revision for SO-1889O.
NOTICE:  Old Purchase Order ID: 5401
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Purchase Order ID: 8595
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Got new IDs [purchase_order_id=8595, contact_id=8866, order_line_id=20524, contact_map_id=8061]
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20524
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20524 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20525
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20525 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Create a new contact_map. [var_new_contact_id=8866, var_new_po_id=8595, var_new_contact_map_id=8061, var_old_po_id=5401
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) SELECT  $1 , type_id,  $2 , '21', 1,  $3  FROM contact_map WHERE table_id = 21 AND foreign_id =  $4 "
PL/pgSQL function "create_new_revision" line 165 at SQL statement
PL/pgSQL function "archive_equipment" line 50 at IF
jbilling=# rollback;
ROLLBACK

INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) 
SELECT 8866 
      ,type_id
      ,8595
      ,'21'
      ,1
      ,8061  
FROM contact_map 
WHERE table_id = 21 
 AND foreign_id =  5401;


-- Unable to cancel device in JBilling A10000157ED68C

begin;
BEGIN
jbilling=# select * from oss.archive_equipment('A10000157ED68C');
INFO:  var_order_id=5002
INFO:  Creating a new sales order revision for SO-9996B.
NOTICE:  Old Purchase Order ID: 5002
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Purchase Order ID: 8595
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Got new IDs [purchase_order_id=8595, contact_id=8866, order_line_id=20524, contact_map_id=8061]
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20524
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20524 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20525
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20525 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Create a new contact_map. [var_new_contact_id=8866, var_new_po_id=8595, var_new_contact_map_id=8061, var_old_po_id=5002
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) SELECT  $1 , type_id,  $2 , '21', 1,  $3  FROM contact_map WHERE table_id = 21 AND foreign_id =  $4 "
PL/pgSQL function "create_new_revision" line 165 at SQL statement
PL/pgSQL function "archive_equipment" line 50 at IF
jbilling=# rollback;
ROLLBACK


SELECT 8061 
      ,type_id
      ,8595
      ,'21'
      ,1
      ,8866  
  FROM contact_map 
 WHERE table_id = 21 
   AND foreign_id =  5002;

 ?column? | type_id | ?column? | ?column? | ?column? | ?column? 
----------+---------+----------+----------+----------+----------
     8061 |       1 |     8595 | 21       |        1 |     8866
     8061 |       1 |     8595 | 21       |        1 |     8866
(2 rows)



----
Create a new contact_map. [

var_new_contact_id       =8866
var_new_po_id            =8595
var_new_contact_map_id   =8061
var_old_po_id            =5401

var_new_contact_id, type_id, var_new_po_id, '21', 1, var_new_contact_map_id

"INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) 
SELECT 8866 
      ,type_id
      ,8595
      ,'21'
      ,1
      ,8061
  FROM contact_map 
 WHERE table_id = 21 
   AND foreign_id = 5401"

SELECT 8866 
      ,type_id
      ,8595
      ,'21'
      ,1
      ,8061
  FROM contact_map 
 WHERE table_id = 21 
   AND foreign_id = 5401;
 ?column? | type_id | ?column? | ?column? | ?column? | ?column? 
----------+---------+----------+----------+----------+----------
     8866 |       1 |     8595 | 21       |        1 |     8061
     8866 |       1 |     8595 | 21       |        1 |     8061
(2 rows)


-- contact id 8061 already exists

select * from contact_map where contact_id = 8061;

  id  | contact_id | type_id | table_id | foreign_id | optlock 
------+------------+---------+----------+------------+---------
 7452 |       8061 |       1 |       21 |       7938 |       1
(1 row)

--

BEGIN
jbilling=# select * from oss.archive_equipment('A10000157ED68C');
INFO:  var_order_id=5002
INFO:  Creating a new sales order revision for SO-9996B.
NOTICE:  Old Purchase Order ID: 5002
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Purchase Order ID: 8595
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Got new IDs [purchase_order_id=8595, contact_id=8866, order_line_id=20524, contact_map_id=8061]
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20524
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20524 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  New Order Line ID: 20525
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  order line inserted count: 1 id: 20525 
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
NOTICE:  Create a new contact_map. [var_new_contact_id=8866, var_new_po_id=8595, var_new_contact_map_id=8061, var_old_po_id=5002
CONTEXT:  PL/pgSQL function "archive_equipment" line 50 at IF
ERROR:  duplicate key value violates unique constraint "contact_map_pkey"
CONTEXT:  SQL statement "INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) SELECT  $1 , type_id,  $2 , '21', 1,  $3  FROM contact_map WHERE table_id = 21 AND foreign_id =  $4 "
PL/pgSQL function "create_new_revision" line 165 at SQL statement
PL/pgSQL function "archive_equipment" line 50 at IF
jbilling=# rollback;
ROLLBACK


var_new_contact_id            8866
var_new_po_id                 8595
var_new_contact_map_id        8061

var_old_po_id                 5002

"INSERT INTO contact_map (contact_id, type_id, foreign_id, table_id, OPTLOCK, id) 
SELECT $1
     ,type_id
     ,$2
     ,'21'
     ,1
     ,$3
 FROM contact_map 
WHERE table_id = 21 
  AND foreign_id = $4"

SELECT 8866
     ,type_id
     ,8595
     ,'21'
     ,1
     ,8061
 FROM contact_map 
WHERE table_id = 21 
  AND foreign_id = 5002;

 ?column? | type_id | ?column? | ?column? | ?column? | ?column? 
----------+---------+----------+----------+----------+----------
     8866 |       1 |     8595 | 21       |        1 |     8061
     8866 |       1 |     8595 | 21       |        1 |     8061
(2 rows)







-----


UPDATE prov_line
   SET end_date = '2018-04-18'
      ,archived = 1
      ,archived_date = '2018-04-18'
      ,archived_reason = 'Cust. Cancelled'
 where line_id = 42050;
