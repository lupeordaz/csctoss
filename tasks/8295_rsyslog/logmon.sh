#!/bin/bash
#

source /home/gordaz/.bash_profile

DATE=`date +%Y%m%d`
BASEDIR=/home/gordaz
DATAFILE='/var/log/policyid1623.log'

while IFS=" " read -r SYSLOG
do
    start_date=`echo $SYSLOG | cut -d" " -f9-10`
    sent=`echo $SYSLOG | cut -d" " -f20`
    rcvd=`echo $SYSLOG | cut -d" " -f21`
    src_ip=`echo $SYSLOG | cut -d" " -f22`

    src_ip=`echo $src_ip | cut -c5-`
    start_date=`echo $start_date | cut -c12-`
    start_date=`echo $start_date | tr -d '"'`
    sent=`echo $sent | cut -c6-`
    rcvd=`echo $rcvd | cut -c6-`

 mysql -D Syslog <<SQL
 insert into nagalert(source_ip, start_date, sent, rcvd)
 values ('$src_ip', '$start_date', $sent, $rcvd);
SQL

done < $DATAFILE
