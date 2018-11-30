#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_soup_device.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/found_macs.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/lupe/tasks/5653/logs/missing_macs.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equipment MAC Address missing from OSS" >> $LOGFILE
echo " " >> $LOGFILE

IFS="|"
while read EQUIPID MAC MODEL SN PARTNO
do
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value = '$MAC';"`
    if [ $MACCNT -gt 0 ]; then 
        echo "$MAC" >> $LOGFILE
    else
        echo "$MAC" >> $ERRFILE
    fi
done < $DATAFILE

