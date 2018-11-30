csctoss=# select line_id                                                     
      ,billing_entity_id
      ,start_date
      ,end_date
      ,notes
  from line
 where end_date is null
   and ((notes is null) OR (notes NOT like 'SO-%'))
 order by 1;
 line_id | billing_entity_id |       start_date       | end_date |                                    notes                                     
---------+-------------------+------------------------+----------+------------------------------------------------------------------------------
      43 |                 2 | 2008-01-11 07:00:00+00 |          | Randy McClellan Testing
      50 |                 2 | 2008-01-22 00:00:00+00 |          | Justice Obrey - Testing
      86 |                11 | 2008-01-30 00:00:00+00 |          | CSCT Denver - card swap 2/27/08
     341 |                25 | 2008-02-28 00:00:00+00 |          | Currently on trial with CSCT with possibility of becoming a reseller/partner
     860 |                36 | 2008-08-15 00:00:00+00 |          | 
     862 |                36 | 2008-08-15 00:00:00+00 |          | 
     865 |                36 | 2008-08-15 00:00:00+00 |          | 
     872 |                36 | 2008-08-15 00:00:00+00 |          | 
     874 |                36 | 2008-08-15 00:00:00+00 |          | 
    1028 |                36 | 2009-02-24 00:00:00+00 |          | 
    1031 |                36 | 2009-02-24 00:00:00+00 |          | 
    1033 |                36 | 2009-02-24 00:00:00+00 |          | 
    1034 |                36 | 2009-02-24 00:00:00+00 |          | 
    1037 |                36 | 2009-02-24 00:00:00+00 |          | 
    1108 |                36 | 2009-02-24 00:00:00+00 |          | 
    2565 |                 2 | 2008-10-07 00:00:00+00 |          | Randy testing airjack-1.0.12 code
    2595 |               121 | 2009-06-27 00:00:00+00 |          | Monitoring for TEC VRF
   18368 |                22 | 2011-01-01 00:00:00+00 |          | 
   39648 |               112 | 2014-08-07 00:00:00+00 |          | 
   39649 |               112 | 2014-08-07 00:00:00+00 |          | 
   39650 |               112 | 2014-08-07 00:00:00+00 |          | 
   39651 |               112 | 2014-08-07 00:00:00+00 |          | 
(22 rows)

--

SELECT
  cust.user_id           AS jbill_customer_id,                -- 
  cont.organization_name AS jbill_organization_name,          -- billing_entity.name
  po.id                  AS jbill_order_id,                   -- 
  po.public_number       AS jbill_so_number,                  --
  po.status_id           AS jbill_status_id,                  --
  pl.line_id             AS jbill_line_id,                    --
  cust.external_id       AS jbill_external_id_customer        -- billing_entity.billing_entity_id
FROM purchase_order po
JOIN prov_line pl ON (po.id = pl.order_id)
JOIN customer cust ON (po.user_id = cust.user_id)
JOIN contact cont ON (cust.user_id = cont.user_id)
WHERE 1 = 1
AND po.status_id = 16
AND po.deleted = 0
AND pl.archived IS NULL




SELECT line.line_id           AS line_id
      ,cust.user_id           AS jbill_customer_id,
      ,cust.external_id       AS jbill_external_id_customer
      ,cont.organization_name AS jbill_organization_name,
      ,po.public_number       AS jbill_so_number,
  FROM line
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,pl.sn AS sn
                                      ,po.public_number AS public_number
                                      ,po.status_id AS status_id
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                  JOIN customer cust ON (po.user_id = cust.user_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, sn text, public_number text, status_id int, customer text)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   AND line.end_date IS NULL
   AND line.notes <> jbill.public_number
 ORDER BY line.line_id;




SELECT line.line_id AS line_id
      ,jbill.public_number AS public_number
  FROM line
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,pl.sn AS sn
                                      ,po.public_number AS public_number
                                      ,po.status_id AS status_id
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, sn text, public_number text, status_id int)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   AND line.end_date IS NULL
   AND line.notes <> jbill.public_number
 ORDER BY line.line_id;


--


SELECT line.line_id AS line_id
      ,jbill.line_id
      ,map.jbilling_customer_id
      ,cust_id as customer_id
      ,be.billing_entity_id
      ,bill_entity
      ,be.name
      ,org_name
      ,line.notes
      ,public_number AS so_number
  FROM line
  JOIN billing_entity be on be.billing_entity_id = line.billing_entity_id
  JOIN oss_jbill_billing_entity_mapping map ON map.oss_billing_entity_id = be.billing_entity_id
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,cust.user_id as customer_id
                                      ,cust.external_id
                                      ,cont.organization_name
                                      ,po.public_number AS so_number
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                  JOIN customer cust ON (po.user_id = cust.user_id)
                                  JOIN contact cont ON (cust.user_id = cont.user_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, cust_id text, bill_entity int, org_name text, public_number text)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   AND line.end_date is null;


--


SELECT
  '"' || be.billing_entity_id                    || '"' AS oss_billing_entity_id,
  '"' || be.name                                 || '"' AS oss_billing_entity_name,
  '"' || map.jbilling_customer_id                || '"' AS jbill_customer_id,
  '"' || be.billing_entity_id                    || '"' AS jbill_external_id_customer,
  '"' || be.name                                 || '"' AS jbill_organization_name,
  '"' || line.notes                              || '"' AS jbill_so_number,
  '"' || line.line_id                            || '"' AS oss_line_id,
  '"' || line.start_date::timestamp(0)           || '"' AS oss_start_date,
  '"' || line.end_date::timestamp(0)             || '"' AS oss_end_date,
  '"' || prd.product_code                        || '"' AS oss_product_code,
  '"' || opt.carrier_internal_product_code       || '"' AS opentaps_product_code,
  '"' || opt.carrier_internal_product_code_descr || '"' AS opentaps_product_code_descr,
  '"' || opt.carrier                             || '"' AS opentaps_carrier,
  '"' || line.radius_username                    || '"' AS line_radius_username,
  '"' || line.notes                              || '"' AS line_notes
  FROM billing_entity be
  JOIN line ON (be.billing_entity_id = line.billing_entity_id)
  JOIN plan ON (line.line_id = plan.line_id)
  JOIN product prd ON (plan.product_id = prd.product_id)
  JOIN oss_jbill_billing_entity_mapping map ON map.oss_billing_entity_id = be.billing_entity_id
  LEFT OUTER JOIN
      (SELECT
              item_id,
              old_product_code,
              product_code_descr,
              carrier,
              otaps_product_code,
              carrier_internal_product_code,
              carrier_internal_product_code_descr
         FROM otaps_product_code_translation) opt ON (prd.product_code = opt.old_product_code)
 WHERE 1 = 1
   AND be.billing_entity_type <> 'INTERNAL'
   AND line.end_date is null;



BEI Name  CID BE2 OSS Name  L.Notes LineId  Start Date  EndDate Product Code  Carr Prod Cd  Carr Int Prod Desc  Carrier Radius Name L.Notes


select count(*) from (
SELECT line.notes
      ,jbill.public_number
  FROM line
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,po.public_number AS so_number
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, public_number text)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   and line.notes <> jbill.public_number
   AND line.end_date is null) as total;
 count 
-------
  4040
(1 row)


SELECT line.notes
      ,jbill.public_number
  FROM line
  JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,po.public_number AS so_number
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, public_number text)
                                      ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   and line.notes <> jbill.public_number
   AND line.end_date is null;
   notes   | public_number 
-----------+---------------
 SO-9713   | SO-9713A
 SO-1673D  | SO-1673E
 SO-1673D  | SO-1673E
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1402K  | SO-1402M
 SO-1534I  | SO-1534K
 SO-1534I  | SO-1534K
 SO-1534I  | SO-1534K
 SO-1534I  | SO-1534K
.
.
.
 SO-1922C  | SO-1922F
 SO-1922C  | SO-1922F
 SO-1922C  | SO-1922F
 SO-12148  | SO-12148A
 SO-1151   | SO-1151A
 SO-4222   | SO-4222A
 SO-5302   | SO-5302A
(4040 rows)





with jbill as (SELECT line.notes
                     ,jbill.public_number
                 FROM line
                 JOIN public.dblink((SELECT * FROM fetch_jbilling_conn()),
                                              'SELECT pl.line_id AS line_id
                                                     ,po.public_number AS so_number
                                                 FROM prov_line pl
                                                 JOIN purchase_order po ON (po.id = pl.order_id)
                                                WHERE 1 = 1
                                                  AND pl.archived IS NULL')
                                               jbill (line_id int, public_number text)
                                                     ON (line.line_id = jbill.line_id)
 WHERE 1 = 1
   and line.notes <> jbill.public_number
   AND line.end_date is null )




BEGIN;

select public.set_change_log_staff_id(3);

UPDATE line
   SET notes = jbill.public_number
  FROM public.dblink((SELECT * FROM fetch_jbilling_conn()),
                               'SELECT pl.line_id AS line_id
                                      ,po.public_number AS so_number
                                  FROM prov_line pl
                                  JOIN purchase_order po ON (po.id = pl.order_id)
                                 WHERE 1 = 1
                                   AND pl.archived IS NULL')
                                jbill (line_id int, public_number text)
 WHERE 1 = 1
   and line.line_id = jbill.line_id
   and line.notes <> jbill.public_number
   AND line.end_date is null;

ROLLBACK;



-- Run on Opentaps server (production)

[root@denopt01 scripts]# . get_active_cancelled_lines.sh
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
[Wed Aug  1 15:39:56 MDT 2018]
Start to populate active/cancelled lines from OSS and JBilling.....

Populated active/cancelled lines.

Before refresh OpenTaps service_line_number/service_line_detail tables, calculate number of records.....
+---------------------------------------------+
| number_of_service_line_number_table_records |
+---------------------------------------------+
|                                       16788 |
+---------------------------------------------+
+---------------------------------------------+
| number_of_service_line_detail_table_records |
+---------------------------------------------+
|                                       17059 |
+---------------------------------------------+

Start putting active/cancelled lines into OpenTaps database......
Finished putting active/cancelled lines into OpenTaps database."

Calculate number of records on service_line_number/service_line_detail tables.....
+---------------------------------------------+
| number_of_service_line_number_table_records |
+---------------------------------------------+
|                                       16799 |
+---------------------------------------------+
+---------------------------------------------+
| number_of_service_line_detail_table_records |
+---------------------------------------------+
|                                       17076 |
+---------------------------------------------+

Finished putting active/cancelled lines into OpenTaps database.
[Wed Aug  1 15:40:03 MDT 2018]
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
[root@denopt01 scripts]# 

--

SELECT
  '"' || be.billing_entity_id                    || '"' AS oss_billing_entity_id,
  '"' || be.name                                 || '"' AS oss_billing_entity_name,
  '"' || jbill.jbill_customer_id                 || '"' AS jbill_customer_id,
  '"' || jbill.jbill_external_id_customer        || '"' AS jbill_external_id_customer,
  '"' || jbill.jbill_organization_name           || '"' AS jbill_organization_name,
  '"' || jbill.jbill_so_number                   || '"' AS jbill_so_number
FROM billing_entity be
JOIN line ON (be.billing_entity_id = line.billing_entity_id)
JOIN plan ON (line.line_id = plan.line_id)
JOIN product prd ON (plan.product_id = prd.product_id)
JOIN dblink(fetch_jbilling_conn(),
'
SELECT
  cust.user_id           AS jbill_customer_id,
  cont.organization_name AS jbill_organization_name,
  po.id                  AS jbill_order_id,
  po.public_number       AS jbill_so_number,
  po.status_id           AS jbill_status_id,
  pl.line_id             AS jbill_line_id,
  cust.external_id       AS jbill_external_id_customer
FROM purchase_order po
JOIN prov_line pl ON (po.id = pl.order_id)
JOIN customer cust ON (po.user_id = cust.user_id)
JOIN contact cont ON (cust.user_id = cont.user_id)
WHERE 1 = 1
AND po.status_id = 16
AND po.deleted = 0
AND pl.archived IS NULL
') AS jbill (jbill_customer_id int, jbill_organization_name text, jbill_order_id int, jbill_so_number text, jbill_status_id int, jbill_line_id int, jbill_external_id_customer int)
ON (line.line_id = jbill.jbill_line_id)

LEFT OUTER JOIN
  (SELECT
           item_id,
     old_product_code,
     product_code_descr,
     carrier,
     otaps_product_code,
     carrier_internal_product_code,
     carrier_internal_product_code_descr
         FROM otaps_product_code_translation) opt ON (prd.product_code = opt.old_product_code)

WHERE 1 = 1
AND be.billing_entity_type <> 'INTERNAL'
AND ( line.start_date <= (DATE_TRUNC('month', now()) - '1 day'::interval)::date AND (line.end_date >= (DATE_TRUNC('month', now())) OR line.end_date IS NULL) )


AND (
  (
    (CASE
      WHEN line.radius_username ~ '@vzw' THEN 'VERIZON'
      WHEN line.radius_username ~ 'sprintpcs' THEN 'SPRINT'
      WHEN line.radius_username ~ '@uscc' THEN 'USCC'
      WHEN line.radius_username ~ '@m2m01' THEN 'VODAFONE'
      ELSE 'any'
     END
    ) = opt.carrier)
  OR (opt.carrier = 'any')
)

ORDER BY
  be.billing_entity_id
;











