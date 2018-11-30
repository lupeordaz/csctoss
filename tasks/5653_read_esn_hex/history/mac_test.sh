#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/mac_oss_data.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equipment MAC Address missing from OSS" >> $LOGFILE
echo " " >> $LOGFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    MACCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'MAC ADDRESS'  
                              and value like '%$MAC'"`
    echo "MACCNT: $MACCNT"
    if [ $MACCNT -gt 0 ]; then 
        OSSEQID=`psql -q -t -c "select e.equipment_id
                                  from unique_identifier uim
                                  join equipment e  
                                       on uim.equipment_id = e.equipment_id 
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC'"`
#        if [[ $ESN = *","* ]]; then
#          count=0
#          IFS=','
#          for esn in $(echo "$ESN"); do
#            count=`expr $count + 1`
#            if [ $count = 1 ]; then
#              ESND=`echo "$esn" | xargs`
#            else
#              ESNH=`echo "$esn" | xargs`
#            fi
#          done
#        else
#          ESND=' '
#          ESNH=$ESN
#        fi
        OSSESN=`psql -q -t -c "select uie.value as ESN
                                  from unique_identifier uim
                                  join unique_identifier uie
                                       on uim.equipment_id = uie.equipment_id 
                                       and uie.unique_identifier_type = 'ESN HEX'
                                 where uim.unique_identifier_type = 'MAC ADDRESS'
                                   and uim.value like '%$MAC' limit 10"`
#        OSSMODL=`psql -q -t -c "select em.model_number2
#                                  from unique_identifier uim
#                                  join equipment e  
#                                       on uim.equipment_id = e.equipment_id 
#                                  join equipment_model em 
#                                       on e.equipment_model_id = em.equipment_model_id 
#                                 where uim.unique_identifier_type = 'MAC ADDRESS'
#                                   and uim.value like '%$MAC'"`
#        OSSPART=`psql -q -t -c "select em.part_number
#                                  from unique_identifier uim
#                                  join equipment e  
#                                       on uim.equipment_id = e.equipment_id 
#                                  join equipment_model em 
#                                       on e.equipment_model_id = em.equipment_model_id 
#                                 where uim.unique_identifier_type = 'MAC ADDRESS'
#                                   and uim.value like '%$MAC'"`
#        OSSSN=`psql -q -t -c "select uis.value
#                                  from unique_identifier uim
#                                  join unique_identifier uis 
#                                       on uim.equipment_id = uis.equipment_id 
#                                       and uis.unique_identifier_type = 'SERIAL NUMBER'
#                                 where uim.unique_identifier_type = 'MAC ADDRESS'
#                                   and uim.value like '%$MAC'"`

#        echo "OSSEQID ESN DEC ESN HEX OSSESN PARTNO OSS PART# MODEL OSSMODL SERNUM OSSSN" >> $LOGFILE
#        echo "$OSSEQID $ESND $ESNH $OSSESN $PARTNO $OSSPART $MODEL $OSSMODL $SN $OSSSN" >> $LOGFILE
        echo "OSSEQID ESN  OSSESN" >> $LOGFILE
        echo "$OSSEQID $ESN $OSSESN" >> $LOGFILE
	#awk -F "|" '{ print $MAC $OSSEQID $OSSESN $OSSMODL $OSSPART $OSSSN }'
    else
    	echo "No Match $MAC"
    fi
done < $DATAFILE

