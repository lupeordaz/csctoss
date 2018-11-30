/*
mysql> desc service_line_number;
+-----------------------+--------------+------+-----+---------+-------+
| Field                 | Type         | Null | Key | Default | Extra |
+-----------------------+--------------+------+-----+---------+-------+
| LINE_ID               | varchar(255) | NO   | PRI |         |       |
| PRODUCT_ID            | varchar(20)  | YES  |     | NULL    |       |
| SO_NUMBER             | varchar(20)  | YES  |     | NULL    |       |
| SO_ITEM_SEQ_ID        | varchar(20)  | YES  |     | NULL    |       |
| IS_ACTIVE             | varchar(20)  | YES  |     | NULL    |       |
| STATUS_ID             | varchar(20)  | YES  |     | NULL    |       |
| CUSTOMER_ID           | varchar(20)  | YES  |     | NULL    |       |
| DATE_OF_PROVISING     | datetime     | YES  |     | NULL    |       |
| LAST_UPDATED_STAMP    | datetime     | YES  |     | NULL    |       |
| LAST_UPDATED_TX_STAMP | datetime     | YES  | MUL | NULL    |       |
| CREATED_STAMP         | datetime     | YES  |     | NULL    |       |
| CREATED_TX_STAMP      | datetime     | YES  | MUL | NULL    |       |
+-----------------------+--------------+------+-----+---------+-------+
12 rows in set (0.01 sec)

mysql> desc service_line_detail;
+-----------------------+--------------+------+-----+---------+-------+
| Field                 | Type         | Null | Key | Default | Extra |
+-----------------------+--------------+------+-----+---------+-------+
| LINE_ID               | varchar(255) | NO   | PRI |         |       |
| DETAIL_TYPE           | varchar(20)  | NO   | PRI | NULL    |       |
| PRODUCT_ID            | varchar(20)  | YES  |     | NULL    |       |
| DATE                  | datetime     | YES  |     | NULL    |       |
| STATUS_ID             | varchar(250) | YES  |     | NULL    |       |
| LAST_UPDATED_STAMP    | datetime     | YES  |     | NULL    |       |
| LAST_UPDATED_TX_STAMP | datetime     | YES  | MUL | NULL    |       |
| CREATED_STAMP         | datetime     | YES  |     | NULL    |       |
| CREATED_TX_STAMP      | datetime     | YES  | MUL | NULL    |       |
| RETURN_ID             | varchar(20)  | YES  |     | NULL    |       |
+-----------------------+--------------+------+-----+---------+-------+
10 rows in set (0.02 sec)
*/


DROP TABLE IF EXISTS cct_0007.temp_jbill_oss_active_lines;
DROP TABLE IF EXISTS cct_0007.temp_jbill_oss_cancelled_lines;

CREATE TABLE cct_0007.temp_jbill_oss_active_lines (
  oss_billing_entity_id int,
  oss_billing_entity_name text,
  jbill_customer_id int,
  jbill_external_id_customer int,
  jbill_organization_name text,
  jbill_so_number text,
  oss_line_id int,
  oss_start_date datetime,
  oss_end_date datetime,
  oss_product_code text,
  opentaps_product_code text,
  opentaps_product_code_descr text,
  opentaps_carrier text,
  line_radius_username text,
  line_notes text
);

CREATE TABLE cct_0007.temp_jbill_oss_cancelled_lines (
  oss_billing_entity_id int,
  oss_billing_entity_name text,
  jbill_customer_id int,
  jbill_external_id_customer int,
  jbill_organization_name text,
  jbill_so_number text,
  oss_line_id int,
  oss_start_date datetime,
  oss_end_date datetime,
  oss_product_code text,
  opentaps_product_code text,
  opentaps_product_code_descr text,
  opentaps_carrier text,
  line_radius_username text,
  line_notes text
);



TRUNCATE TABLE cct_0007.temp_jbill_oss_active_lines;
TRUNCATE TABLE cct_0007.temp_jbill_oss_cancelled_lines;
TRUNCATE TABLE cct_0007.service_line_number;
TRUNCATE TABLE cct_0007.service_line_detail;

LOAD DATA LOCAL INFILE '/opt/scripts/jbill_oss_active_lines.csv' INTO TABLE
  cct_0007.temp_jbill_oss_active_lines FIELDS TERMINATED BY ',' ENCLOSED BY '"';

LOAD DATA LOCAL INFILE '/opt/scripts/jbill_oss_cancelled_lines.csv' INTO TABLE
  cct_0007.temp_jbill_oss_cancelled_lines FIELDS TERMINATED BY ',' ENCLOSED BY '"';


--
-- For active lines
--
INSERT INTO cct_0007.service_line_number (
  LINE_ID,
  PRODUCT_ID,
  SO_NUMBER,
  SO_ITEM_SEQ_ID,
  IS_ACTIVE,
  STATUS_ID,
  CUSTOMER_ID,
  DATE_OF_PROVISING
)
SELECT
  oss_line_id,
  opentaps_product_code,
  jbill_so_number,
  '0001',
  'Y',
  'SHIPPED',
  jbill_customer_id,
  oss_start_date
FROM cct_0007.temp_jbill_oss_active_lines
;


INSERT INTO cct_0007.service_line_detail (
  LINE_ID,
  DETAIL_TYPE,
  PRODUCT_ID,
  DATE,
  STATUS_ID
)
SELECT
  oss_line_id,
  'SO',
  opentaps_product_code,
  oss_start_date,
  'Start Date'
FROM cct_0007.temp_jbill_oss_active_lines
;


--
-- For cancelled lines
--
INSERT INTO cct_0007.service_line_number
(
  LINE_ID,
  PRODUCT_ID,
  SO_NUMBER,
  SO_ITEM_SEQ_ID,
  IS_ACTIVE,
  STATUS_ID,
  CUSTOMER_ID,
  DATE_OF_PROVISING
)
SELECT
  oss_line_id,
  opentaps_product_code,
  jbill_so_number,
  '0001',
  'Y',
  'SHIPPED',
  jbill_customer_id,
  oss_start_date
FROM cct_0007.temp_jbill_oss_cancelled_lines tmp
WHERE 1 = 1
AND NOT EXISTS
  (SELECT * FROM cct_0007.service_line_number sl
   WHERE sl.line_id = tmp.oss_line_id)
;


/*
UPDATE cct_0007.service_line_number sn
       JOIN cct_0007.temp_jbill_oss_cancelled_lines tmp
       ON (sn.line_id = tmp.oss_line_id)
  SET sn.is_active = 'N'
WHERE 1 = 1
AND sn.date_of_provising < tmp.oss_end_date
AND sn.is_active = 'Y'
;
*/


-- Add initial shipped information.
INSERT INTO cct_0007.service_line_detail (
  LINE_ID,
  DETAIL_TYPE,
  PRODUCT_ID,
  DATE,
  STATUS_ID
)
SELECT
  oss_line_id,
  'SO',
  opentaps_product_code,
  oss_start_date,
  'Start Date'
FROM cct_0007.temp_jbill_oss_cancelled_lines tmp
WHERE 1 = 1
AND NOT EXISTS
  (SELECT line_id FROM cct_0007.service_line_detail sl
   WHERE sl.line_id = tmp.oss_line_id)
;


-- Add cancelled information.
INSERT INTO cct_0007.service_line_detail (
  LINE_ID,
  DETAIL_TYPE,
  PRODUCT_ID,
  DATE,
  STATUS_ID
)
SELECT
  oss_line_id,
  'RMA',
  opentaps_product_code,
  oss_end_date,
  'End Date'
FROM cct_0007.temp_jbill_oss_cancelled_lines
;



