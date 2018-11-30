#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device10.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_oss_data.`date '+%Y%m%d'`

IFS="|"
while read EQUIPID SESN IMSI MAC MODEL SN PARTNO
do
    if [[ $SESN = *","* ]]; then
       ESND=`echo "$SESN" | cut -d',' -f1`
       ESNH=`echo "$SESN" | cut -d',' -f2`
       if [[ ${#ESNH} -gt ${#ESND} ]]; then
            ESN=$ESNH
       else
            ESN=$ESND
       fi
    else
       ESN=$SESN
    fi
    echo "$MAC|$SESN|$ESN"
done < $DATAFILE

