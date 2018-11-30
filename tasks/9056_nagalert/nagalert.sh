#!/bin/bash

cat <<- EOS
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
[`date`]

Total records > 5 days from nagalert database.....

EOS

# Display number of records to delete from nagalert 
#/usr/bin/mysql -D Syslog -e "SELECT count(*) AS records_older_than_five_days from nagalert where fwstart_time < (NOW() - INTERVAL 5 DAY);"
psql -q \
     -t \
     -h testoss01.cctus.com -d csctoss -p 5450 -U csctoss_owner \
     -c "select count(*)
           from line_equipmenx
          where equipment_id > 10000"
RETCODE=$?
echo "RETCODE:  " $RETCODE
if [ "$RETCODE" -ne "0" ]; then
	mail -s "CRON job failure for NAGALERT" gordaz@cctus.com 
fi

#cat <<- EOS
#
#Delete records older than five days ...
#
#EOS

cat <<- EOS
Finished Processing!

[`date`]
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
EOS

#cat <<- EOS
#
#Delete records older than five days ...
#
#EOS
#
#/usr/bin/mysql -D Syslog -e "delete from nagalert where fwstart_time < (NOW() - INTERVAL 5 DAY);"
#
#
#Finished putting active/cancelled lines into OpenTaps database.
#
#mail -s "CRON job ran on NAGALERT."