#!/bin/bash
#
source /home/postgres/.bash_profile

BASEDIR=/home/postgres/dba
DATAFILE=$BASEDIR/data/fiserv_usernames_test.txt
LOGFILE=$BASEDIR/logs/connected_lines_log.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/logs/connected_lines_err.`date '+%Y%m%d'`
TEMPFILE=$BASEDIR/logs/connected_lines.out

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $ERRFILE

while read USERNAME
do
    echo "Username: " $USERNAME
    read UserName FramedIP Start Stop <<< $(psql \
    -q -t -c "select username
                    ,framedipaddress
                    ,acctstarttime
                    ,acctstoptime
                from master_radacct
               where username = '$USERNAME'
                 and acctstarttime > '2018-02-01 00:00:00'::timestamp with time zone
               order by acctstarttime desc
               limit 1")

    if [[ -z $UserName ]] ; then
        echo $USERNAME >> $ERRFILE
    else
        if [[ -z $Stop ]] ; then
            echo 'Connected!'
            echo "$UserName$FramedIP$Start" "Connected" >> $LOGFILE
        else
            echo "$UserName$FramedIP$Start$Stop" >> $LOGFILE
        fi
    fi

done < $DATAFILE
