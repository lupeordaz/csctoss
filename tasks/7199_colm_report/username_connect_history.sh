#!/bin/bash
#
source /home/postgres/.bash_profile

BASEDIR=/home/postgres/dba
DATAFILE=$BASEDIR/data/fiserv_missed_names.txt
LOGFILE=$BASEDIR/logs/username_connect_history_log.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/logs/username_connect_history_err.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $ERRFILE

while read USERNAME
do

    echo "Username: " $USERNAME
    psql \
    -q -t -c "select username
                    ,framedipaddress
                    ,acctstarttime
                    ,acctstoptime
                from master_radacct
               where username = '$USERNAME'
               order by acctstarttime desc
               limit 5;"   \
    | while read UserName FramedIP Start Stop ; do

        if [[ -z $Stop ]] ; then
            echo "$UserName$FramedIP$Start" >> $LOGFILE
        else
            echo "$UserName$FramedIP$Start$Stop" >> $LOGFILE
        fi
    done

done < $DATAFILE
