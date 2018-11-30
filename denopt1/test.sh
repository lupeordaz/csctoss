#!/bin/bash

PGPASSWORD=owner psql -h denoss01.contournetworks.net -p 5450 -d csctoss -U csctoss_owner -f get_active_lines_from_jbill_and_oss_for_opentaps_20180801.sql
PGPASSWORD=owner psql -h denoss01.contournetworks.net -p 5450 -d csctoss -U csctoss_owner -f get_cancelled_lines_from_jbill_and_oss_for_opentaps_20180801.sql

