SELECT
  line.line_id AS line_id,
  line.start_date::date AS line_start_date,
  line.end_date::date AS line_end_date,
  line.radius_username AS radius_username,
  jbill.public_number AS jbill_so_value,
  line.notes AS oss_so_value
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