#!/bin/bash

cat <<- EOS
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
[`date`]
Start to populate active/cancelled lines from OSS and JBilling.....

EOS

# Populates active/cancelled lines from OSS/JBilling
PGPASSWORD=owner /usr/bin/psql -q -h denoss01.contournetworks.net  \
                               -p 5450 -d csctoss -U csctoss_owner \
                               -f scripts/get_active_lines_from_jbill_and_oss_for_opentaps.sql
PGPASSWORD=owner /usr/bin/psql -q -h denoss01.contournetworks.net  \
                               -p 5450 -d csctoss -U csctoss_owner \
                               -f scripts/get_cancelled_lines_from_jbill_and_oss_for_opentaps.sql

cat <<- EOS

Finished putting active/cancelled lines into OpenTaps database.
[`date`]
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
EOS