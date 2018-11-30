#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_device_oneesn_test.csv
SNFIXFILE=$BASEDIR/lupe/tasks/5653/logs/oss_sn_fix_data.`date '+%Y%m%d'`
MISSFILE=$BASEDIR/lupe/tasks/5653/logs/oss_esn_not_found1.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/oss_esn_hex_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $MISSFILE
#echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equip Id|ESN|OSS Serial No." >> $LOGFILE
echo "Equip Id|Serial No.|OSS Serial No." >> $SNFIXFILE
echo "Equip Id|ESN|Serial No." >> $MISSFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    ESNCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'ESN HEX'  
                              and value = '$ESN'"`
    if [ $ESNCNT -gt 0 ]; then 
        echo $SN

        if [ "$SN" = "N" ]; then
            SN=" "
        fi
        OSSEQID=`psql -q -t -c "select uie.equipment_id
                                  from unique_identifier uie
                                 where uie.unique_identifier_type = 'ESN HEX'
                                   and uie.value = '$ESN'"`
        OSSEQID=`echo $OSSEQID | xargs`
        OSSSN=`psql -q -t -c "select uis.value
                                from unique_identifier uie
                                join unique_identifier uis 
                                     on uie.equipment_id = uis.equipment_id 
                                     and uis.unique_identifier_type = 'SERIAL NUMBER'
                               where uie.unique_identifier_type = 'ESN HEX'
                                 and uie.value = '$ESN'"`
        OSSSN=`echo $OSSSN | xargs`

        if [[ $SN != $OSSSN ]]; then
            echo $SN $OSSSN
            echo "$OSSEQID|$SN|$OSSSN" >> $SNFIXFILE
        else
            echo "$OSSEQID|$ESN|$OSSSN" >> $LOGFILE
        fi
    else
        echo "$EQUIPID|$ESN|$SN" >> $MISSFILE
    fi
done < $DATAFILE
