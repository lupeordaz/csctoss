SET TimeZone TO MST7MDT;

\pset tuples_only
\pset format unaligned
\pset fieldsep ','

\o data/jbill_oss_active_lines.csv

SELECT
  '"' || be.billing_entity_id                    || '"' AS oss_billing_entity_id,
  '"' || be.name                                 || '"' AS oss_billing_entity_name,
  '"' || jbill.jbill_customer_id                 || '"' AS jbill_customer_id,
  '"' || jbill.jbill_external_id_customer        || '"' AS jbill_external_id_customer,
  '"' || jbill.jbill_organization_name           || '"' AS jbill_organization_name,
  '"' || jbill.jbill_so_number                   || '"' AS jbill_so_number,
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
--JOIN line_equipment le ON (line.line_id = le.line_id)
--JOIN equipment eq ON (le.equipment_id = eq.equipment_id)
--JOIN equipment_model em ON (eq.equipment_model_id = em.equipment_model_id)
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
--AND opt.otaps_product_code IS NOT NULL
--AND ((em.carrier = opt.carrier) OR (opt.carrier = 'any'))
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
  be.billing_entity_id,
  oss_line_id
;

\o

