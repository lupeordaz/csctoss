#!/bin/bash
#
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/5653_missing_equip.csv
FIXFILE=$BASEDIR/lupe/tasks/5653/logs/5653_fixed_data.`date '+%Y%m%d'`
MISSFILE=$BASEDIR/lupe/tasks/5653/logs/5653_mac_not_found.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/5653_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $MISSFILE
echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "Equip Id|OSS ESN HEX" >> $LOGFILE
echo "Equip Id|Line Id|Start Date|Radius Name|Serial No.|Model1|file MAC|OSS MAC|Model2" >> $FIXFILE
echo "Equip Id|Line Id|MAC Address" >> $MISSFILE

IFS=","
while read EQUIPID LINE STARTD RNAME SN MODEL1 MAC MODEL2
do
    fMAC=$MAC 
    MACCNT=`psql -q -t -c "select count(*) 
                             from equipment e
                             join unique_identifier uim
                                  on e.equipment_id = uim.equipment_id
                                  and uim.unique_identifier_type = 'MAC ADDRESS'
                            where uim.value = '$MAC'"`

    if [ $MACCNT -eq 0 ]; then
        MAC=`echo "$MAC" | cut -c7-12`

        MACCNT=`psql -q -t -c "select count(*) 
                                 from equipment e
                                 join unique_identifier uim
                                      on e.equipment_id = uim.equipment_id
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                where uim.value like '%$MAC'"`
    fi

    if [ $MACCNT -gt 0 ]; then 
        EQUIPID=`psql -q -t -c "select e.equipment_id
                                 from equipment e
                                 join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                where uim.value = '$MAC'"`
        EQUIPID=`echo $EQUIPID | xargs`
        LINEID=`psql -q -t -c "select l.line_id
                                 from equipment e
                                 join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                 join line_equipment le on le.equipment_id = e.equipment_id
                                 join line l on l.line_id = le.line_id
                                where uim.value = '$MAC'
                                  and l.line_id = $LINE
                                  and l.end_date IS NULL"`
        LINEID=`echo $LINEID | xargs`
        STDATE=`psql -q -t -c "select l.start_date
                                 from equipment e
                                 join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                 join line_equipment le on le.equipment_id = e.equipment_id
                                 join line l on l.line_id = le.line_id
                                where uim.value = '$MAC'
                                  and l.line_id = $LINE
                                  and l.end_date IS NULL"`
        STDATE=`echo $STDATE | xargs`
        RADNAME=`psql -q -t -c "select l.radius_username
                                 from equipment e
                                 join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                 join line_equipment le on le.equipment_id = e.equipment_id
                                 join line l on l.line_id = le.line_id
                                where uim.value = '$MAC'
                                  and l.line_id = $LINE
                                  and l.end_date IS NULL"`
        RADNAME=`echo $RADNAME | xargs`
      SERIALNO=`psql -q -t -c "select uis.value
                                 from unique_identifier uim 
                                 join unique_identifier uis 
                                      on uim.equipment_id = uis.equipment_id 
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                where uim.value = '$MAC'
                                      and uim.unique_identifier_type = 'MAC ADDRESS'"`
        SERIALNO=`echo $SERIALNO | xargs`

        MODL1=`psql -q -t -c "select em.model_number1
                                from equipment e
                                join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                join unique_identifier uis 
                                      on e.equipment_id = uis.equipment_id 
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                join equipment_model em 
                                      on e.equipment_model_id = em.equipment_model_id
                               where uim.value = '$MAC'"`
        MODL1=`echo $MODL1 | xargs`

        MODL2=`psql -q -t -c "select em.model_number2
                                from equipment e
                                join unique_identifier uim 
                                      on e.equipment_id = uim.equipment_id 
                                      and uim.unique_identifier_type = 'MAC ADDRESS'
                                join unique_identifier uis 
                                      on e.equipment_id = uis.equipment_id 
                                      and uis.unique_identifier_type = 'SERIAL NUMBER'
                                join equipment_model em 
                                      on e.equipment_model_id = em.equipment_model_id
                               where uim.value = '$MAC'"`
        MODL2=`echo $MODL2 | xargs`

        echo "$EQUIPID|$LINEID|$STDATE|$RADNAME|$SERIALNO|$MODL1|$fMAC|$MAC|$MODL2" >> $FIXFILE
    else
        echo "$EQUIPID|$LINE|$MAC" >> $MISSFILE
    fi
done < $DATAFILE
