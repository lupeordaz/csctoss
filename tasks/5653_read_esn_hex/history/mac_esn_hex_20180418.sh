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
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value like '%$MAC'"`
    if [ $MACCNT -gt 0 ]; then 
        OSSEQID=`psql -q -t -c "select e.equipment_id
                                  from unique_identifier uim
                                  join equipment e  
                                       on uim.equipment_id = e.equipment_id 
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`
        OSSEQID=`echo $OSSEQID | xargs`
        OSSESNH=`psql -q -t -c "select uie.value as ESN
                                  from unique_identifier uim
                                  join unique_identifier uie
                                       on uim.equipment_id = uie.equipment_id 
                                       and uie.unique_identifier_type = 'ESN HEX'
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`
        OSSESNH=`echo $OSSESNH | xargs`
        if [[ $ESN != $OSSESNH ]]; then
            echo "$OSSEQID|$ESN|$OSSESNH" >> $ESNFIXFILE
        fi
    else
    	echo "$EQUIPID|$ESN|$MAC" >> $ERRFILE
    fi
done < $DATAFILE
