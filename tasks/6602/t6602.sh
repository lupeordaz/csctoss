#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/dba/scripts/usernames.txt
LOGFILE=$BASEDIR/dba/scripts/framedips_`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`"  > $LOGFILE
echo "Equipment MAC Address missing from OSS"  >> $LOGFILE
echo " " 

IFS="|"
while read USERNAME
do
    IPADDR=`psql -q -t -c "select framedipaddress
                             from master_radacct
                            where username = '$USERNAME'
                            group by framedipaddress, acctstarttime
                            order by framedipaddress, acctstarttime DESC limit 1;"`
    STARTTIME=`psql -q -t -c "select acctstarttime
                             from master_radacct
                            where username = '$USERNAME'
                            group by framedipaddress, acctstarttime
                            order by framedipaddress, acctstarttime DESC limit 1;"`
    echo "$USERNAME|$IPADDR|$STARTTIME" >> $LOGFILE
done < $DATAFILE
