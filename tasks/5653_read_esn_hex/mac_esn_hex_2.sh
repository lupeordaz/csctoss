#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_device_multiesn.csv

ESNFIXFILE=$BASEDIR/lupe/tasks/5653/logs/oss_fix_data2.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/lupe/tasks/5653/logs/mac_not_found2.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_esn_hex_2_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $ERRFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equip Id|SOUP ESN|OSS ESN" >> $ESNFIXFILE
echo "Equip Id|SOUP ESN DEC|MAC Address" >> $ERRFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value like '%$MAC'"`
    if [ $MACCNT -gt 0 ]; then 
        
        echo "MAC    :" $MAC >> $LOGFILE

        OSSEQID=`psql -q -t -c "select e.equipment_id
                                  from unique_identifier uim
                                  join equipment e  
                                       on uim.equipment_id = e.equipment_id 
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`

        ESN1=`echo "$ESN" | cut -d',' -f1`
        ESN2=`echo "$ESN" | cut -d',' -f2`
        if [[ ${#ESN2} -gt ${#ESN1} ]]; then
            ESNH=`echo $ESN2 | xargs`
        else
            ESNH=`echo $ESN1 | xargs`
        fi
        
        echo "ESNH   :" $ESNH >> $LOGFILE

        OSSESNH=`psql -q -t -c "select ltrim(uie.value) as ESN
                                  from unique_identifier uim
                                  join unique_identifier uie
                                       on uim.equipment_id = uie.equipment_id 
                                       and uie.unique_identifier_type = 'ESN HEX'
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`

        OSSESNH=`echo "$OSSESNH" | xargs`
        echo "OSS ESN:" $OSSESNH >> $LOGFILE

        if [[ $ESNH != $OSSESNH ]]; then
            echo "$OSSEQID|$ESNH|$OSSESNH" >> $ESNFIXFILE
        fi
    else
        echo "$EQUIPID|$ESN|$MAC" >> $ERRFILE
    fi
done < $DATAFILE

