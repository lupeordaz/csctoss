#!/bin/bash

source ~/.bash_profile


SQL=$(cat << EOD
SET TimeZone TO EST5EDT;
SELECT
  be.billing_entity_id,
  be.name AS billing_entity_name,
  line.line_id,
  line.radius_username,
  line.start_date::date AS line_start_date,
  line.end_date::date AS line_end_date,
  le.equipment_id,
  le.start_date AS equip_start_date,
  le.end_date AS equip_end_date,
  (SELECT unique_identifier.value FROM unique_identifier WHERE le.equipment_id = unique_identifier.equipment_id AND unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text) AS sn,
  (SELECT unique_identifier.value FROM unique_identifier WHERE le.equipment_id = unique_identifier.equipment_id AND unique_identifier.unique_identifier_type = 'MDN'::text) AS mdn,
  (SELECT unique_identifier.value FROM unique_identifier WHERE le.equipment_id = unique_identifier.equipment_id AND unique_identifier.unique_identifier_type = 'MIN'::text) AS min,
  (SELECT unique_identifier.value FROM unique_identifier WHERE le.equipment_id = unique_identifier.equipment_id AND unique_identifier.unique_identifier_type = 'ESN HEX'::text) AS esn_hex,
  (SELECT unique_identifier.value FROM unique_identifier WHERE le.equipment_id = unique_identifier.equipment_id AND unique_identifier.unique_identifier_type = 'ESN DEC'::text) AS esn_dec,
  em.model_number1 AS equipment_model,
  em.model_note,
  em.vendor,
  loc.id AS location_id,
  loc.owner AS location_owner,
  loc.name AS location_name,
  loc.address AS location_address,
  loc.processor AS location_processor,
  ARRAY(SELECT usergroup.groupname FROM usergroup WHERE usergroup.username::text = line.radius_username) AS groupname,
  (SELECT radreply.value FROM radreply WHERE radreply.username::text = line.radius_username AND radreply.attribute::text = 'Framed-IP-Address'::text) AS static_ip_address,
  mrad.total_usage_kb_for_last30days AS total_usage_kb_for_last30days
FROM billing_entity be
 JOIN line ON be.billing_entity_id = line.billing_entity_id
 JOIN line_equipment le ON line.line_id = le.line_id
 JOIN equipment eq ON le.equipment_id = eq.equipment_id
 JOIN equipment_model em ON eq.equipment_model_id = em.equipment_model_id
 LEFT JOIN location_labels loc ON loc.line_id = line.line_id
 LEFT JOIN dblink(( SELECT fetch_csctlog_conn.fetch_csctlog_conn
 FROM fetch_csctlog_conn()),
 'SELECT
    username,
    MAX(acctstarttime::timestamp(0)) AS last_connected_timestamp,
    TRUNC(SUM(acctinputoctets + acctoutputoctets) / 1024) AS total_usage_kb_for_last30days
  FROM csctlog.master_radacct mrad
  WHERE 1 = 1
  AND acctstarttime >= (now() - ''30 days''::INTERVAL)
  GROUP BY username'::text)
  mrad(username text, last_connected_timestamp timestamp with time zone, total_usage_kb_for_last30days bigint)
  ON line.radius_username = mrad.username
WHERE 1 = 1
AND (eq.equipment_id IN (
  SELECT unique_identifier.equipment_id FROM unique_identifier
  WHERE unique_identifier.unique_identifier_type = 'SERIAL NUMBER'::text
  AND (unique_identifier.value IN (SELECT device_monitor.serial_number FROM device_monitor))))
EOD
)


echo ${SQL} | psql \
  -h 127.0.0.1 \
  -p 5450 \
  -d csctoss \
  -U csctoss_owner \
  --no-align \
  -t \
  --field-separator '|' \
  -q \
| while IFS='|' read billing_entity_id billing_entity_name line_id radius_username line_start_date line_end_date equipment_id equip_start_date equip_end_date sn mdn min esn_hex esn_dec equipment_model model_note vendor location_id location_owner location_name location_address location_processor groupname static_ip_address total_usage_kb_for_last30days ; do

cat <<EOD
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
[Device Information]
billing_entity_id   : ${billing_entity_id}
billing_entity_name : ${billing_entity_name}
line_id             : ${line_id}
radius_username     : ${radius_username}
line_start_date     : ${line_start_date}
line_end_date       : ${line_end_date}
equipment_id        : ${equipment_id}
equip_start_date    : ${equip_start_date}
equip_end_date      : ${equip_end_date}
sn                  : ${sn}
mdn                 : ${mdn}
min                 : ${min}
esn_hex             : ${esn_hex}
esn_dec             : ${esn_dec}
equipment_model     : ${equipment_model}
model_note          : ${model_note}
vendor              : ${vendor}
location_id         : ${location_id}
location_owner      : ${location_owner}
location_name       : ${location_name}
location_address    : ${location_address}
location_processor  : ${location_processor}
groupname           : ${groupname}
static_ip_address   : ${static_ip_address}
total_usage_kb      : ${total_usage_kb_for_last30days} (for last 30 days)

[Session history for last 3 days (TimeZone is EST7EDT (America/New_York))]
EOD


SQL=$(cat << EOD
SET TimeZone TO EST5EDT;
SELECT
  acctstarttime::timestamp(0) AS acctstarttime,
  acctstoptime::timestamp(0) AS acctstoptime,
  acctsessiontime AS acctsessiontime,
  (acctinputoctets / 1024) AS acctinputoctets_kb,
  (acctoutputoctets / 1024) AS acctoutputoctets_kb,
  acctterminatecause
FROM master_radacct
WHERE acctstarttime >= (current_date - '3 days'::interval)
AND username = '${radius_username}'
ORDER BY acctstarttime DESC
EOD
)

echo ${SQL} | PGPASSWORD=reader psql \
  -h denlog02.contournetworks.net \
  -p 5450 \
  -d csctlog \
  -U csctlog_reader \
  -q \
  --pset border=2

cat <<EOD
=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=



EOD

done

