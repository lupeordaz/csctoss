#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/6582/data/6582_soup_device_data.csv

#ESNFIXFILE=$BASEDIR/tasks/6582/logs/oss_fix_data2.`date '+%Y%m%d'`
ERRFILE=$BASEDIR/lupe/tasks/6582/logs/esn_not_found.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/6582/logs/soup_esn_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $ERRFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
#echo "Equip Id|SOUP ESN|OSS ESN" >> $ESNFIXFILE
#echo "Equip Id|SOUP ESN DEC|MAC Address" >> $ERRFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do

    if [[ $ESN = *","* ]]; then
        ESN1=`echo "$ESN" | cut -d',' -f1`
        ESN2=`echo "$ESN" | cut -d',' -f2`
        if [[ ${#ESN2} -gt ${#ESN1} ]]; then
            ESN=`echo $ESN2 | xargs`
        else
            ESN=`echo $ESN1 | xargs`
        fi
    fi

    ESNCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'ESN HEX'  
                              and value = '$ESN'"`
    if [ $ESNCNT -gt 0 ]; then 
       OSSEQUIP=`psql -q -t -c "select e.equipment_id
                                 from equipment e
                                 join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                where uim.value = '$MAC'"`
       OSSEQUIP=`echo $OSSEQUIP | xargs`
        OSSMODL=`psql -q -t -c "select em.model_number1
                                from equipment e
                                join unique_identifier uie
                                      on e.equipment_id = uie.equipment_id
                                      and uie.unique_identifier_type = 'ESN HEX'
                                join unique_identifier uis
                                      on e.equipment_id = uis.equipment_id
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                join equipment_model em
                                      on e.equipment_model_id = em.equipment_model_id
                               where uie.value = 'A10000157EC0D3'"`
        OSSMODL=`echo $OSSMODL | xargs`         
          OSSSN=`psql -q -t -c "select uis.value as serial_number
                                  from unique_identifier uie
                                  join unique_identifier uis
                                       on uie.equipment_id = uis.equipment_id
                                       and uis.unique_identifier_type = 'SERIAL NUMBER'
                                 where uie.value = '$ESN'
                                   and uie.unique_identifier_type = 'ESN HEX'"`
          OSSSN=`echo $OSSSN | xargs`         
         OSSMAC=`psql -q -t -c "select uis.value as mac_address
								  from unique_identifier uie
								  join unique_identifier uis 
								       on uie.equipment_id = uis.equipment_id 
								       and uis.unique_identifier_type = 'MAC ADDRESS'
								 where uie.value = '$ESN'
								   and uie.unique_identifier_type = 'ESN HEX'"`
         OSSMAC=`echo $OSSMAC | xargs`         

		echo "$OSSEQID|$ESN|$MAC|$OSSMAC|$MODEL|$OSSMODL|$SN|$OSSSN" >> $LOGFILE
    else
        echo "ESN: " $ESN >> $ERRFILE
    fi

done < $DATAFILE

