#!/bin/bash

psql -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner -c \
"BEGIN;

DELETE FROM csctoss.oss_jbill_billing_entity_mapping;

INSERT INTO csctoss.oss_jbill_billing_entity_mapping (oss_billing_entity_id, jbilling_customer_id)
SELECT
  external_id,
  user_id
FROM dblink((SELECT * FROM fetch_jbilling_conn()),
'SELECT external_id, user_id FROM public.customer WHERE external_id IS NOT NULL')
AS jbill (external_id int, user_id int);

COMMIT;"

