#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_device_oneesn.csv
ESNFIXFILE=$BASEDIR/lupe/tasks/5653/logs/oss_fix_data1.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/lupe/tasks/5653/logs/mac_not_found1.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_esn_hex_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $ERRFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equip Id|SOUP ESN HEX|OSS ESN HEX" >> $ESNFIXFILE
echo "Equip Id|ESN DEC|MAC Address" >> $ERRFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    ESNCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'ESN HEX'  
                              and value = '$ESN"`
    if [ $ESNCNT -gt 0 ]; then 
        OSSEQID=`psql -q -t -c "select e.equipment_id
                                  from unique_identifier uie
                                 where uie.unique_identifier_type = 'ESN HEX'
                                   and uie.value = '$ESN'"`
        OSSEQID=`echo $OSSEQID | xargs`
        OSSMAC=`psql -q -t -c "select ltrim(uim.value)
                                  from unique_identifier uie
                                  join unique_identifier uim
                                       on uim.equipment_id = uie.equipment_id 
                                       and uim.unique_identifier_type = 'MAC ADDRESS'
                                 where uim.unique_identifier_type = 'ESN HEX'
                                   and uim.value = '$ESN'"`
        OSSMAC=`echo $OSSMAC | xargs`
        if [[ $MAC != $OSSMAC ]]; then
            echo "$OSSEQID|$MAC|$OSSMAC" >> $ESNFIXFILE
        fi
    else
    	echo "$EQUIPID|$ESN|$MAC" >> $ERRFILE
    fi
done < $DATAFILE
