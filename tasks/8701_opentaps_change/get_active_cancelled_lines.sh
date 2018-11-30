#!/bin/bash

#cat <<- EOS
#/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
#[`date`]
#Start to populate active/cancelled lines from OSS and JBilling.....
#
#EOS
#
## Populates active/cancelled lines from OSS/JBilling
#PGPASSWORD=owner /usr/bin/psql -q -h testopt02.cctus.com -p 5450 -d csctoss -U csctoss_owner -f /opt/scripts/get_active_lines_from_jbill_and_oss_for_opentaps.sql
#PGPASSWORD=owner /usr/bin/psql -q -h testopt02.cctus.com -p 5450 -d csctoss -U csctoss_owner -f /opt/scripts/get_cancelled_lines_from_jbill_and_oss_for_opentaps.sql
#
#cat <<- EOS
#Populated active/cancelled lines.
#
#Before refresh OpenTaps service_line_number/service_line_detail tables, calculate number of records.....
#EOS

# Import active cancelled lines into OpenTaps database
/usr/bin/mysql -A -h 192.168.144.78 -P 3306 -u root --password=cctus@admin123 cct_0007 -e "SELECT count(*) AS number_of_service_line_number_table_records FROM cct_0007.service_line_number"
/usr/bin/mysql -A -h 192.168.144.78 -P 3306 -u root --password=cctus@admin123 cct_0007 -e "SELECT count(*) AS number_of_service_line_detail_table_records FROM cct_0007.service_line_detail"

cat <<- EOS

Start putting active/cancelled lines into OpenTaps database......
EOS

/usr/bin/mysql -A -h 192.168.144.78 -P 3306 -u root --password=cctus@admin123 cct_0007 < /opt/scripts/load_lines_into_opentaps.sql

cat <<- EOS
Finished putting active/cancelled lines into OpenTaps database."

Calculate number of records on service_line_number/service_line_detail tables.....
EOS

/usr/bin/mysql -A -h 192.168.144.78 -P 3306 -u root --password=cctus@admin123 cct_0007 -e "SELECT count(*) AS number_of_service_line_number_table_records FROM cct_0007.service_line_number"
/usr/bin/mysql -A -h 192.168.144.78 -P 3306 -u root --password=cctus@admin123 cct_0007 -e "SELECT count(*) AS number_of_service_line_detail_table_records FROM cct_0007.service_line_detail"

cat <<- EOS

Finished putting active/cancelled lines into OpenTaps database.
[`date`]
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
EOS
