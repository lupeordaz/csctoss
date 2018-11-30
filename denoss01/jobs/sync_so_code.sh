#!/bin/bash
#
# Synchronize product code between OSS and JBilling.
# This script updates OSS database based on JBilling plan information.
#
# $Id: $
#

source /home/postgres/.bash_profile
DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/sync_product_code.$DATE

#echo "CSCTOSS LINE/CLASS REPORT FOR $DATE" > $LOGFILE
echo "" > $LOGFILE

# identify lines with missing class and output to logfile
echo "------------------------------------------------------" >> $LOGFILE
echo "THE FOLLOWING LINES HAVE DIFFERENT PRODUCT_CODE IN OSS" >> $LOGFILE
echo "------------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -c "
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
" >> $LOGFILE

# Correct different product_code in OSS based on JBilling.
psql -q -c "
" >> $LOGFILE

#if [ `grep "(0 rows)" $LOGFILE | wc -l` -eq 3 ]; then
if [ `grep "(0 rows)" $LOGFILE | wc -l` -eq 1 ]; then
  echo "" >> $LOGFILE
  echo "No rows found. Do not mail empty results." >> $LOGFILE
else

  echo "" >> $LOGFILE
  echo "NOTE: The discrepancies have been auto corrected ..." >> $LOGFILE
  echo "" >> $LOGFILE

  cat $LOGFILE | mail -s "CSCTOSS MRC PRODUCT CODE CORRECTOR REPORT FOR: $DATE" dba@cctus.com

  # this chunk of code corrects the most common error so we dont have to do it manually
  qry=`psql -q << EOF

SELECT public.set_change_log_staff_id(3);

UPDATE plan SET product_id = (SELECT product_id FROM product prd2 WHERE prd2.product_code = t1.jbill_product_code)
FROM (
SELECT
  be.billing_entity_id AS billing_entity_id,
  be.name AS billing_entity_name,
  line.line_id AS line_id,
  line.start_date::date AS line_start_date,
  line.end_date::date AS line_end_date,
  line.radius_username AS radius_username,
  prd.product_code AS oss_product_code,
  jbill.internal_number AS jbill_product_code,
  jbill.public_number AS public_number,
  line.notes AS line_notes
FROM billing_entity be
JOIN line ON (be.billing_entity_id = line.billing_entity_id)
JOIN plan pl ON (line.line_id = pl.line_id)
JOIN product prd ON (pl.product_id = prd.product_id)
JOIN dblink((SELECT * FROM fetch_jbilling_conn()),
'SELECT
  po.id AS order_id,
  po.public_number AS public_number,
  po.status_id AS status_id,
  ol.item_id AS item_id,
  (SELECT internal_number FROM item WHERE id = ol.item_id) AS internal_number,
  pl.line_id AS line_id,
  pl.sn AS sn,
  pl.esn_hex AS esn_hex,
  pl.username AS username
FROM purchase_order po
JOIN order_line ol ON (po.id = ol.order_id)
JOIN prov_line pl ON (ol.order_id = pl.order_id)
JOIN item_type_map itm ON (ol.item_id = itm.item_id)
WHERE 1 = 1
AND po.status_id = 16
AND itm.type_id = 301
AND pl.archived IS NULL
AND (SELECT internal_number FROM item WHERE id = ol.item_id) LIKE ''MRC-%''
') jbill (order_id int, public_number text, status_id int, item_id int, internal_number text, line_id int, sn text, esn_hex text, username text)
ON (line.line_id = jbill.line_id)

WHERE 1 = 1
AND line.end_date IS NULL
AND prd.product_code <> jbill.internal_number

ORDER BY be.billing_entity_id, line.line_id
) AS t1

WHERE 1 = 1
AND plan.line_id = t1.line_id
;
  \q`
fi

# remove log files older than 7 days
find $BASEDIR/logs/sync_product_code* -mtime +7 -exec rm -f {} \;
exit 0

