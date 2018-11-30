#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device10.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_oss_data.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equipment MAC Address missing from OSS" >> $LOGFILE
echo " " >> $LOGFILE
echo "MAC|ESND|OSSESND|ESNH|OSSESNH" >> $LOGFILE

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

        if [[ $ESN = *","* ]]; then
           ESND=`echo "$ESN" | cut -d',' -f1`
           ESNH=`echo "$ESN" | cut -d',' -f2`
        else
          ESND=' '
          ESNH=$ESN
        fi

        OSSESND=`psql -q -t -c "select uie.value as ESN
                                  from unique_identifier uim
                                  join unique_identifier uie
                                       on uim.equipment_id = uie.equipment_id 
                                       and uie.unique_identifier_type = 'ESN DEC'
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`
        OSSESNH=`psql -q -t -c "select uie.value as ESN
                                  from unique_identifier uim
                                  join unique_identifier uie
                                       on uim.equipment_id = uie.equipment_id 
                                       and uie.unique_identifier_type = 'ESN HEX'
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`

        echo "$MAC|$ESND|$OSSESND|$ESNH|$OSSESNH" >> $LOGFILE
    else
    	echo "No Match $MAC"
    fi
done < $DATAFILE

