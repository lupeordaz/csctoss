#!/bin/bash

source /home/postgres/.bash_profile

MYSQL=/opt/rh/mysql55/root/usr/bin/mysql

OPENTAPS_SERVER=10.17.70.22
OPENTAPS_DB_PORT=3306
OPENTAPS_DB_NAME=cct_0007
OPENTAPS_DB_PASS=cctus@admin123

CNIPORTAL_SERVER=cnipor01.contournetworks.net
CNIPORTAL_INVDTL_DIR=/var/www/html/repo-detail-folder

BASEDIR=/home/postgres/dba/jobs/invoice_detail
OTAPS_OUTFILE=${BASEDIR}/invoice_$(date +%Y%m%d).csv
CUSTID_OUTFILE=${BASEDIR}/invoice_$(date +%Y%m%d)_customer_ids.csv
INVOICE_DETAIL_OUTDIR=${BASEDIR}/$(date +%Y%m%d)
MSGFILE=/tmp/msg_$(date +%Y%m%d).txt

#
# Export OpenTaps service_line_number records.
#
#cat << EOF | ${MYSQL} -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} --skip-column-names ${OPENTAPS_DB_NAME} | nkf -Lw >> ${OTAPS_OUTFILE}
cat << EOF | ${MYSQL} -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} --skip-column-names ${OPENTAPS_DB_NAME} | /bin/sed -e 's/\t/,/g' | nkf -Lw > ${OTAPS_OUTFILE}
SELECT
  LINE_ID          ,
  PRODUCT_ID       ,
  SO_NUMBER        ,
  SO_ITEM_SEQ_ID   ,
  IS_ACTIVE        ,
  STATUS_ID        ,
  CUSTOMER_ID      ,
  DATE_OF_PROVISING
FROM service_line_number
ORDER BY
  CUSTOMER_ID,
  LINE_ID
;
EOF


#
# Load OpenTaps service_line_number data into OSS.
#
PGPASSWORD=und3rt0w psql -q -h denoss01.contournetworks.net -p 5450 -d csctoss -U postgres -c "
DELETE FROM csctoss.otaps_service_line_number;

COPY csctoss.otaps_service_line_number FROM '${OTAPS_OUTFILE}' CSV
"


#
# Create a list of customer IDs (JBilling customer IDs).
#
PGPASSWORD=owner psql -q -h denoss01.contournetworks.net -p 5450 -d csctoss -U csctoss_owner -A -t -c "
SELECT
  customer_id
FROM csctoss.otaps_service_line_number
GROUP BY
  customer_id
ORDER BY
  customer_id
" > ${CUSTID_OUTFILE}


#
# Generate individual invoice detail files.
#
mkdir ${INVOICE_DETAIL_OUTDIR}

for custid in `cat ${CUSTID_OUTFILE}`
do
  echo "sn,so_number,product_id,location_id,location_owner,location_name,location_address,processor" > ${INVOICE_DETAIL_OUTDIR}/${custid}.csv

  PGPASSWORD=owner psql -q -h denoss01.contournetworks.net -p 5450 -d csctoss -U csctoss_owner -A -t -F, -c "
SELECT
  (SELECT value FROM unique_identifier WHERE equipment_id = le.equipment_id AND unique_identifier_type = 'SERIAL NUMBER') AS sn,
  sln.so_number,
  sln.product_id,
  ll.id AS location_id,
  ll.owner AS location_owner,
  ll.name AS location_name,
  ll.address AS location_address,
  ll.processor AS processor
FROM csctoss.otaps_service_line_number sln
JOIN csctoss.line ON (sln.line_id = line.line_id)
JOIN csctoss.line_equipment le ON (line.line_id = le.line_id)
LEFT OUTER JOIN location_labels ll ON (line.line_id = ll.line_id)
WHERE 1 = 1
AND le.equipment_id = (SELECT MAX(le2.equipment_id) FROM line_equipment le2
                       WHERE le2.line_id = line.line_id)
AND line.billing_entity_id = (SELECT oss_billing_entity_id
                              FROM csctoss.oss_jbill_billing_entity_mapping
                              WHERE jbilling_customer_id = ${custid})
" >> ${INVOICE_DETAIL_OUTDIR}/${custid}.csv
done

#
# Email the generated invoice detail report.
#
(cd ${BASEDIR}; /bin/tar czf invoice_detail_$(date -d '1 month ago' +%Y%m).tgz $(date +%Y%m%d))

echo "Attached is CNI invoice detail report for `date -d '1 month ago' +%Y%m`." > ${MSGFILE}

/usr/bin/mutt -i $MSGFILE -a ${BASEDIR}/invoice_detail_$(date -d '1 month ago' +%Y%m).tgz -s "Invoice Detail Report for: `date -d '1 month ago' +%Y%m`" support@contournetworks.com -c dba@cctus.com < /dev/null

#
# Copy invoice detail files to CNI portal server (cnipor01)
#
scp -i /home/postgres/.ssh/id_rsa -Cr ${BASEDIR}/$(date +%Y%m%d) root@${CNIPORTAL_SERVER}:${CNIPORTAL_INVDTL_DIR}/`date -d '1 month ago' +%m-%Y`

