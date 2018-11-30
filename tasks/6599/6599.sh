#!/bin/bash
#
BASEDIR=/home/postgres
DATE=`date --date='today' +%Y%m%d`

LOGFILE=$BASEDIR/lupe/tasks/6599/logs/6599_higi_convert.`date '+%Y%m%d'`
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE

IFS=","
while read LINEID OLDIP <&3 && read NEWIP <&4;
do 
    echo "Line Id: " $LINEID >> $LOGFILE

    psql -q -t -c "select * from ops_change_static_ip($LINEID,'$OLDIP', '$NEWIP')" >> $LOGFILE
    
done 3<test/test_ip_file.csv 4<test/6599_test_ip.txt

echo "Finished!"
