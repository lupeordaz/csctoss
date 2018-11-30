#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/missing_macs.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equipment MAC Address missing from OSS" >> $LOGFILE
echo " " >> $LOGFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value like '%$MAC';"`
    if [ $MACCNT -gt 0 ]; then 
        read $OSSEQID $OSSESN $OSSMAC $OSSPARTNO $OSSSN $OSSMODEL <<< $(psql -q -t -c \
           "select e.equipment_id  
                  ,uie.value as ESN  
                  ,uim.value as mac 
                  ,em.part_number  
                  ,uis.value as serialno  
                  ,em.model_number2  
              from equipment e  
              join unique_identifier uie on e.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'  
              join unique_identifier uim on e.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'  
              join unique_identifier uis on e.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'  
              join equipment_model em on e.equipment_model_id = em.equipment_model_id  
             where uim.value = '%$MAC'")
        echo ${OSSEQID} ${OSSESN}
        #awk -F "|" '{ print $OSSEQID $OSSESN $ESN $OSSMAC $MAC }' 
    else
	echo "No Match:  Equip Id:  " $EQUIPID " Mac Address:  " $MAC 
    fi
done < $DATAFILE

