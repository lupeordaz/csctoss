SELECT
  '"' || be.billing_entity_id                    || '"' AS oss_billing_entity_id,
  '"' || be.name                                 || '"' AS oss_billing_entity_name,
--  '"' || map.jbilling_customer_id                || '"' AS jbill_customer_id,
--  '"' || be.billing_entity_id                    || '"' AS jbill_external_id_customer,
--  '"' || be.name                                 || '"' AS jbill_organization_name,
--  '"' || line.notes                              || '"' AS jbill_so_number,
  '"' || line.line_id                            || '"' AS oss_line_id,
  '"' || line.start_date::timestamp(0)           || '"' AS oss_start_date,
  '"' || line.end_date::timestamp(0)             || '"' AS oss_end_date,
  '"' || prd.product_code                        || '"' AS oss_product_code,
  '"' || opt.old_product_code                    || '"' AS opt_old_product_code,
--  '"' || opt.carrier_internal_product_code       || '"' AS opentaps_product_code,
--  '"' || opt.carrier_internal_product_code_descr || '"' AS opentaps_product_code_descr,
  '"' || opt.carrier                             || '"' AS opentaps_carrier,
  '"' || line.radius_username                    || '"' AS line_radius_username,
  '"' || line.notes                              || '"' AS line_notes

FROM billing_entity be
JOIN line ON (be.billing_entity_id = line.billing_entity_id)
JOIN plan ON (line.line_id = plan.line_id)
JOIN product prd ON (plan.product_id = prd.product_id)
LEFT OUTER JOIN oss_jbill_billing_entity_mapping map ON map.oss_billing_entity_id = be.billing_entity_id
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
--AND (
--  (
--    (CASE
--      WHEN line.radius_username ~ '@vzw' THEN 'VERIZON'
--      WHEN line.radius_username ~ 'sprintpcs' THEN 'SPRINT'
--      WHEN line.radius_username ~ '@uscc' THEN 'USCC'
--      WHEN line.radius_username ~ '@m2m01' THEN 'VODAFONE'
--      ELSE 'any'
--     END
--    ) = opt.carrier)
--  OR (opt.carrier = 'any')
--)
AND line.line_id IN(44532,44835,44836,44837,44838,44839,44840,44841,44842,44843,
44844,44845,44846,44847,44848,44849,44850,44851,44852,44853,44855,44855,44856,
44857,44858,44859,44860,44861,44862,44863,44864,44865,44866,44867,44868,44869,
44870,44871,44872,44873,44874,44875,44876,44877,44878,44879,44880,44881,44882,
44882,44883,44884,44885,44886,44887,44888,44889,44890,44891,44892,44893,44894,
45039,45040,45546,45559,45595,45667,45668,45669,45670,45671,45672,45673,45674,
45675,45676,45677,46260,46261,46262,46263,46264,46265,46266,46267,46268,46269,
46270,46271,46272,46273,46274,46275,46276,46277,46278,46279,46394,46426,46641,
46672,46683,46685,46688,46689,46689,46690,46740,46750,46751,46752,46753,46787,
46788,46789,46883,46884,46929,46930,46931,46932,46933,46934,46935,46936,46937,
46938,46951,46952,46953,46954,46955,46973,46974,46975,46979,46985,46989,46990,
46991,46992,46993,46994,46995,46996,46997,46998,47013,47014,47038,47052,47055,
47056,47057,47058,47059,47060,47061,47062,47063,47087,47088,47140,47146,47147,
47148,47172,47173,47175,47176,47177,47178,47229)
ORDER BY
  be.billing_entity_id,
  oss_line_id;

--


-[ RECORD 1 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44835"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327118@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 2 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44836"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327119@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 3 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44837"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327125@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 4 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44838"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327129@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 5 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44839"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327131@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 6 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44840"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327148@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 7 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44841"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327141@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 8 ]-----------+----------------------------
oss_billing_entity_id   | "699"
oss_billing_entity_name | "Fiserv Cash and Logistics"
oss_line_id             | "44842"
oss_start_date          | "2017-04-09 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4705327144@vzw3g.com"
line_notes              | "SO-11384A"
-[ RECORD 9 ]-----------+----------------------------
oss_billing_entity_id   | "756"
oss_billing_entity_name | "Superior Press"
oss_line_id             | "44532"
oss_start_date          | "2017-01-30 00:00:00"
oss_end_date            | 
oss_product_code        | "MRC-CNI-SS-M-0-N-0-3"
opt_old_product_code    | 
opentaps_carrier        | 
line_radius_username    | "4704211647@vzw3g.com"
line_notes              | "SO-11219"

--

 item_id |  old_product_code  | carrier  | otaps_product_code | carrier_internal_product_code 
---------+--------------------+----------+--------------------+-------------------------------
    8804 | CNI-SC-M-0-N-0-3   | VERIZON  | CNI-SC-M-0-N-0-3   | CNI-SC-M-0-N-0-3
    8803 | CNI-SS-M-0-N-0-3   | VERIZON  | CNI-SS-M-0-N-0-3   | CNI-SS-M-0-N-0-3
     707 | MRC-002-01RP-1XU   | USCC     | O-M-2-P-0-X-0      | M-2-P-0-1-0
     707 | MRC-002-01RP-1XU   | SPRINT   | O-M-2-P-0-X-0      | M-2-P-0-2-0
     707 | MRC-002-01RP-1XU   | VERIZON  | O-M-2-P-0-X-0      | M-2-P-0-3-0
     713 | MRC-003-01RP-1XU   | USCC     | O-M-3-P-0-X-0      | M-3-P-0-1-0
     713 | MRC-003-01RP-1XU   | SPRINT   | O-M-3-P-0-X-0      | M-3-P-0-2-0
    6201 | MRC-005-01LP-1XU   | USCC     | O-M-5-P-0-X-0      | M-5-P-0-1-0-Lease
    6201 | MRC-005-01LP-1XU   | SPRINT   | O-M-5-P-0-X-0      | M-5-P-0-2-0-Lease
    6201 | MRC-005-01LP-1XU   | VERIZON  | O-M-5-P-0-X-0      | M-5-P-0-3-0-Lease
     708 | MRC-005-01RP-1XU   | USCC     | O-M-5-P-0-X-0      | M-5-P-0-1-0
     708 | MRC-005-01RP-1XU   | SPRINT   | O-M-5-P-0-X-0      | M-5-P-0-2-0
     708 | MRC-005-01RP-1XU   | VERIZON  | O-M-5-P-0-X-0      | M-5-P-0-3-0
    5600 | MRC-005-01RP-EVV   | SPRINT   | O-M-5-P-0-X-0      | M-5-P-0-2-0
    5600 | MRC-005-01RP-EVV   | VERIZON  | O-M-5-P-0-X-0      | M-5-P-0-3-0
    5600 | MRC-005-01RP-EVV   | USCC     | O-M-5-P-0-X-0      | M-5-P-0-1-0
    8501 | MRC-005-01RP-WCVF  | any      | O-M-5-P-0-X-0      | M-5-P-0-6-0
    2600 | MRC-006-01RP-1XU   | USCC     | O-M-6-P-0-X-0      | M-6-P-0-1-0
    2600 | MRC-006-01RP-1XU   | SPRINT   | O-M-6-P-0-X-0      | M-6-P-0-2-0
    2600 | MRC-006-01RP-1XU   | VERIZON  | O-M-6-P-0-X-0      | M-6-P-0-3-0
    2601 | MRC-007-01RP-1XU   | USCC     | O-M-7-P-0-X-0      | M-7-P-0-1-0
    2601 | MRC-007-01RP-1XU   | SPRINT   | O-M-7-P-0-X-0      | M-7-P-0-2-0
    2602 | MRC-008-01RP-1XU   | USCC     | O-M-8-P-0-X-0      | M-8-P-0-1-0
    2602 | MRC-008-01RP-1XU   | SPRINT   | O-M-8-P-0-X-0      | M-8-P-0-2-0
    2602 | MRC-008-01RP-1XU   | VERIZON  | O-M-8-P-0-X-0      | M-8-P-0-3-0
    2603 | MRC-009-01RP-1XU   | USCC     | O-M-9-P-0-X-0      | M-9-P-0-1-0
    2603 | MRC-009-01RP-1XU   | SPRINT   | O-M-9-P-0-X-0      | M-9-P-0-2-0
    4400 | MRC-010-01RP-EVU   | SPRINT   | O-M-10-P-0-X-0     | M-10-P-0-2-0
    4400 | MRC-010-01RP-EVU   | VERIZON  | O-M-10-P-0-X-0     | M-10-P-0-3-0
     709 | MRC-010-24WP-EMV   | any      | MRC-010-36WP-EMV   | MRC-010-24WP-EMV
     712 | MRC-010-36WP-EMV   | any      | MRC-010-36WP-EMV   | MRC-010-36WP-EMV
    3400 | MRC-015-01RP-1XU   | USCC     | O-M-15-P-0-X-0     | M-15-P-0-1-0
    3400 | MRC-015-01RP-1XU   | VERIZON  | O-M-15-P-0-X-0     | M-15-P-0-3-0
    3400 | MRC-015-01RP-1XU   | SPRINT   | O-M-15-P-0-X-0     | M-15-P-0-2-0
    2604 | MRC-020-01RP-1XU   | USCC     | O-M-20-P-0-X-0     | M-20-P-0-1-0
    2604 | MRC-020-01RP-1XU   | SPRINT   | O-M-20-P-0-X-0     | M-20-P-0-2-0
    1600 | MRC-020-01RP-4GV   | any      | O-M-20-P-0-X-0     | M-20-P-0-3-0
    5502 | MRC-025-01RP-EVV   | VERIZON  | O-M-25-P-0-X-0     | M-25-P-0-3-0
    2000 | MRC-030-01RP-1XU   | USCC     | O-M-30-P-0-X-0     | M-30-P-0-1-0
    2100 | MRC-050-01RP-1XU   | USCC     | O-M-50-P-0-X-0     | M-50-P-0-1-0
    2100 | MRC-050-01RP-1XU   | SPRINT   | O-M-50-P-0-X-0     | M-50-P-0-2-0
    2100 | MRC-050-01RP-1XU   | VERIZON  | O-M-50-P-0-X-0     | M-50-P-0-3-0
    4302 | MRC-100-01RU-EVU   | SPRINT   | O-M-100-P-0-X-0    | M-100-P-0-2-0
    4302 | MRC-100-01RU-EVU   | VERIZON  | O-M-100-P-0-X-0    | M-100-P-0-3-0
    6505 | MRC-1GB-01RP-EVS   | SPRINT   | O-M-1024-P-0-X-0   | M-1024-P-0-2-0
    6506 | MRC-1GB-01RP-EVV   | VERIZON  | O-M-1024-P-0-X-0   | M-1024-P-0-3-0
    4303 | MRC-200-01RU-EVU   | USCC     | O-M-200-P-0-X-0    | M-200-P-0-1-0
    5900 | MRC-250-01RP-EVV   | VERIZON  | O-M-250-P-0-X-0    | M-250-P-0-3-0
    6000 | MRC-2GB-01RP-EVU   | SPRINT   | O-M-2048-P-0-X-0   | M-2048-P-0-2-0
    5300 | MRC-3GB-01RP-EVU   | VERIZON  | O-M-3072-P-0-X-0   | M-3072-P-0-3-0
    5901 | MRC-400-01RU-EVU   | SPRINT   | O-M-400-P-0-X-0    | M-400-P-0-2-0
    6501 | MRC-500-01RP-EVS   | SPRINT   | O-M-500-P-0-X-0    | M-500-P-0-2-0
    6502 | MRC-500-01RP-EVV   | VERIZON  | O-M-500-P-0-X-0    | M-500-P-0-3-0
    8807 | MRC-500-01RP-VFN   | VODAFONE | O-500-P-0-X-0      | M-500-P-0-6-0
    5200 | MRC-500-01RU-EVU   | SPRINT   | O-M-500-P-0-X-0    | M-500-P-0-2-0
    5200 | MRC-500-01RU-EVU   | VERIZON  | O-M-500-P-0-3-0    | M-500-P-0-3-0
    7205 | MRC-500-01RU-HWR   | any      | O-M-500-P-0-5-0    | M-500-P-0-5-0
    5500 | MRC-500-24RU-EVV   | VERIZON  | O-M-500-P-0-X-0    | M-500-P-0-3-0
    6507 | MRC-5MB-01RP-EVV   | SPRINT   | O-M-5-P-0-X-0      | M-5-P-0-2-0
    6507 | MRC-5MB-01RP-EVV   | VERIZON  | O-M-5-P-0-X-0      | M-5-P-0-3-0
    6503 | MRC-750-01RP-EVS   | SPRINT   | O-M-750-P-0-X-0    | M-750-P-0-2-0
    6504 | MRC-750-01RP-EVV   | VERIZON  | O-M-750-P-0-X-0    | M-750-P-0-3-0
    4700 | MRC-997-24R-EV     | any      | MRC-997-24R-EV     | MRC-997-24R-EV
     710 | MRC-999-12R-EV     | any      | MRC-999-12R-EV     | MRC-999-12R-EV
     711 | MRC-999-24R-EV     | any      | MRC-999-24R-EV     | MRC-999-24R-EV
    7700 | MRC-Bill-Pro-Fee   | any      | BILL-PRO-FEE-1     | BILL-PRO-FEE-1
    8801 | MRC-CYE1-M-0-N-0-3 | VERIZON  | CYE1-M-0-N-0-3     | CYE1-M-0-N-0-3
    8802 | MRC-CYS1-M-0-N-0-3 | VERIZON  | CYS1-M-0-N-0-3     | CYS1-M-0-N-0-3
    9003 | MRC-LEASE-DIAL-LTE | Verizon  | MRC-LEASE-DIAL-LTE | MRC-LEASE-DIAL-LTE
    9004 | MRC-LEASE-TCP-LTE  | Verizon  | MRC-LEASE-TCP-LTE  | MRC-LEASE-TCP-LTE
    5700 | MRC-MISC-DATA      | any      | MRC-MISC-DATA      | MRC-MISC-DATA
    8806 | MRC-SECURED-SVC-5G | VERIZON  | SECURED-SVC-5G     | SECURED-SVC-5G
    8600 | MRC-WBK1-01RP-EVV  | VERIZON  | O-M-WB-P-0-X-0     | M-WB-P-0-3-0
    8805 | SECURED-HW         | VERIZON  | SECURED-HW         | SECURED-HW
     704 | TB-060-12-1XU      | any      | TB-060-12-1XU      | TB-060-12-1XU
     706 | TB-084-12-1XU      | any      | TB-084-12-1XU      | TB-084-12-1XU
    1706 | TB-120-12-1XU      | any      | TB-120-12-1XU      | TB-120-12-1XU
    1704 | TB-120-24-1XU      | any      | TB-120-24-1XU      | TB-120-24-1XU
    1702 | TB-180-36-1XU      | any      | TB-180-36-1XU      | TB-180-36-1XU
    1705 | TB-240-24-1XU      | any      | TB-240-24-1XU      | TB-240-24-1XU
    1703 | TB-360-36-1XU      | any      | TB-360-36-1XU      | TB-360-36-1XU


--


select * from line where line_id = 44532;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 44532
calling_station_id        | 
line_assignment_type      | CUSTOMER ASSIGNED
billing_entity_id         | 756
logical_apn               | 
disabled_apn              | 
contact_id                | 
order_id                  | 
employee_id               | 
billing_entity_address_id | 800
active_flag               | t
line_label                | 353238060067369
start_date                | 2017-01-30 00:00:00+00
end_date                  | 
date_created              | 2017-01-30 00:00:00+00
radius_username           | 4704211647@vzw3g.com
radius_password           | 
radius_auth_type          | 
static_ip_address         | 
ip_pool                   | 
proxy_access              | 
session_timeout_seconds   | 
idle_timeout_seconds      | 
primary_dns               | 
secondary_dns             | 
current_plan_id           | 
previous_line_id          | 
notes                     | SO-11219
additional_info           | 

--

oss_billing_entity_id,oss_billing_entity_name,jbill_customer_id,jbill_external_id_customer,jbill_organization_name,jbill_so_number,oss_line_id,oss_start_date,oss_end_date,oss_product_code,opentaps_product_code,opentaps_product_code_descr,opentaps_carrier,line_radius_username,line_notes




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
LEFT OUTER JOIN oss_jbill_billing_entity_mapping map ON map.oss_billing_entity_id = be.billing_entity_id
--JOIN line_equipment le ON (line.line_id = le.line_id)
--JOIN equipment eq ON (le.equipment_id = eq.equipment_id)
--JOIN equipment_model em ON (eq.equipment_model_id = em.equipment_model_id)
--JOIN dblink(fetch_jbilling_conn(),
--'
--SELECT
--  cust.user_id           AS jbill_customer_id,
--  cont.organization_name AS jbill_organization_name,
--  po.id                  AS jbill_order_id,
--  po.public_number       AS jbill_so_number,
--  po.status_id           AS jbill_status_id,
--  pl.line_id             AS jbill_line_id,
--  cust.external_id       AS jbill_external_id_customer
--FROM purchase_order po
--JOIN prov_line pl ON (po.id = pl.order_id)
--JOIN customer cust ON (po.user_id = cust.user_id)
--JOIN contact cont ON (cust.user_id = cont.user_id)
--WHERE 1 = 1
--AND po.status_id = 16
--AND po.deleted = 0
--AND pl.archived IS NULL
--') AS jbill (jbill_customer_id int, jbill_organization_name text, jbill_order_id int, jbill_so_number text, jbill_status_id int, jbill_line_id int, jbill_external_id_customer int)
--ON (line.line_id = jbill.jbill_line_id)

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

-- Added by Shibuya
AND prd.product_code IN ('MRC-CYS1-M-0-N-0-3','MRC-CNI-SS-M-0-N-0-3','MRC-CNI-SC-M-0-N-0-3')

-- Added by Shibuya
AND opt.old_product_code IN ('MRC-CYS1-M-0-N-0-3','CNI-SS-M-0-N-0-3','CNI-SC-M-0-N-0-3')

ORDER BY
  be.billing_entity_id,
  oss_line_id
;


UPDATE otaps_product_code_translation
   SET old_product_code = 'MRC-CNI-SS-M-0-N-0-3'
 WHERE item_id = 8803;

UPDATE otaps_product_code_translation
   SET old_product_code = 'MRC-CNI-SC-M-0-N-0-3'
 WHERE item_id = 8804;


