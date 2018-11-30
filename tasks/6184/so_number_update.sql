BEGIN;
SELECT public.set_change_log_staff_id(3);

UPDATE line
   SET notes = (SELECT t1.public_number )
                  FROM ( SELECT line.line_id AS line_id
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
                          ORDER BY line.line_id) as t1
 WHERE 1 = 1
   AND line.line_id = t1.line_id;

rollback;
                                                                                                                                                          