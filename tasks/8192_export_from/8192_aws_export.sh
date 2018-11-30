#!/bin/bash

DBMON=`date --date='yesterday' +%Y%m`
DB_DATE=`date --date='yesterday' +%Y-%m-%d`
DB_DATE="'$DB_DATE'"
FILDATE=`date --date='yesterday' +%Y%m%d`

BASEDIR=/home/gordaz
DATADIR=$BASEDIR/data
NASDIR=$BASEDIR/mnt/public/linelog_$DBMON/
LOGFILE=$BASEDIR/log/aws_log.`date '+%Y%m%d'`
TMPFILE=$DATADIR/temp.sql

echo '***************************************************************************' > $LOGFILE
echo `date +%H:%M:%S` >> $LOGFILE
echo "Start processing $DATADIR/linelog_$FILDATE.csv ....." >> $LOGFILE
echo '' >>$LOGFILE

# Create temporary sql script
ASTER="*"
echo "\\COPY (SELECT $ASTER FROM linelog_$DBMON WHERE time_received::date = $DB_DATE limit 20) TO $DATADIR/linelog_$FILDATE.csv CSV HEADER" > $TMPFILE

# Populates AWS data to NAS drive

PGPASSWORD=qzvuuuv7 psql -q \
                         -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
                         -p 5432 \
                         -d bi \
                         -U bi_reader \
                         -f $TMPFILE

tar -cvzf /home/gordaz/mnt/public/linelog_$DBMON/linelog_$FILDATE.csv.gz $DATADIR/linelog_$FILDATE.csv

echo "File $NASDIR/linelog_$FILDATE.csv.gz has been created." >> $LOGFILE
echo '' >>$LOGFILE
echo "AWS Data copy:  SUCCESS"
echo `date +%H:%M:%S` >> $LOGFILE
echo '***************************************************************************' >> $LOGFILE

#Finished putting active/cancelled lines into OpenTaps database.