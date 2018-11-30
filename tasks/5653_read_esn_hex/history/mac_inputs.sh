#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
#DATAFILE=$BASEDIR/dba/scripts/soup_mac_data.csv
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device.csv
#LOGFILE=$BASEDIR/dba/logs/mac_updates.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_test.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE

#psql -q -t -c "BEGIN;"
#psql -q -t -c "select * from  public.set_change_log_staff_id(3);"
 
IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value LIKE '%$MAC';"`
    if [ $MACCNT > 0 ]; then 

        read OSSEQID OSSESN OSSMAC OSSPARTNO OSSSN OSSMODEL <<< $(psql -q -t -c \
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
        echo "$OSSEQID, $OSSESN, $ESN, $OSSMAC, $MAC, $OSSMODEL, $MODEL, $OSSSN, $SN, $OSSPARTNO, $PARTNO"
    else
        echo "$ESN, $MAC, $MODEL, $SN, $PARTNO"
    fi
done < $DATAFILE

