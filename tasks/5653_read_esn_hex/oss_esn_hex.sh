#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_device_multiesn.csv
SNFIXFILE=$BASEDIR/lupe/tasks/5653/logs/oss_fix_data.`date '+%Y%m%d'`
MISSFILE=$BASEDIR/lupe/tasks/5653/logs/oss_esn_not_found.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/oss_esn_hex_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $MISSFILE
#echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equip Id|OSS ESN HEX" >> $LOGFILE
#echo "Equip Id|SOUP ESN HEX|OSS ESN HEX" >> $ESNFIXFILE
#echo "Equip Id|ESN DEC|MAC Address" >> $ERRFILE

IFS="|"
while read EQUIPID ESN IMSI MAC MODEL SN PARTNO
do
    echo "Equip: " $EQUIPID "ESN: " $ESN
    if [[ $ESN = *","* ]]; then
      ESN1=`echo "$ESN" | cut -d',' -f1`
      ESN2=`echo "$ESN" | cut -d',' -f2`
      if [[ ${#ESN2} -gt ${#ESN1} ]]; then
          ESN=`echo $ESN2 | xargs`
      else
          ESN=`echo $ESN1 | xargs`
      fi
    fi

    echo "ESN: " $ESN
    ESNCNT=`psql -q -t -c "select count(*) 
                             from unique_identifier 
                            where unique_identifier_type = 'ESN HEX'  
                              and value = '$ESN'"`
    if [ $ESNCNT -gt 0 ]; then 
        OSSEQID=`psql -q -t -c "select uie.equipment_id
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
        if [ "$SN" = "N" ]; then
            SN=" "
        fi
        OSSSN=`psql -q -t -c "select uis.value
                                from unique_identifier uie
                                join unique_identifier uis 
                                     on uie.equipment_id = uis.equipment_id 
                                     and uis.unique_identifier_type = 'SERIAL NUMBER'
                               where uie.unique_identifier_type = 'ESN HEX'
                                 and uie.value = '$ESN'"`
        OSSSN=`echo $OSSSN | xargs`
    else
        echo "$EQUIPID|$ESN|$MAC" >> $MISSFILE
    fi
done < $DATAFILE
