#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/gordaz
DATE=`date --date='yesterday' +%Y%m%d`

DATAFILE=$BASEDIR/tasks/8938_mdn_correction/correctedMDN_MIN.csv
#DATAFILE=$BASEDIR/tasks/8938_mdn_correction/testfile.csv
LOGFILE=$BASEDIR/tasks/8938_mdn_correction/logs/correction_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" 
#echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
#echo "Equip Id|OSS ESN HEX" >> $LOGFILE
#echo "Equip Id|SOUP ESN HEX|OSS ESN HEX" >> $ESNFIXFILE
#echo "Equip Id|ESN DEC|MAC Address" >> $ERRFILE

IFS=","
while read USERNM EQUIPID CURRMIN CURRMDN NEWMIN NEWMDN
do
    echo "Username: " $USERNM "   Equip. Id.: " $EQUIPID "   Correct MDN/MIN:  " $NEWMIN "/" $NEWMDN

    psql -q \
         -h testoss01.cctus.com  \
         -d csctoss \
         -p 5450  \
         -U csctoss_owner \
         -t \
         -c "SELECT public.set_change_log_staff_id (3);
             update unique_identifier
                set value = '$NEWMIN'
              where equipment_id = $EQUIPID
                and unique_identifier_type = 'MIN'
                AND value = '$CURRMIN'"

    psql -q \
         -h testoss01.cctus.com  \
         -d csctoss \
         -p 5450  \
         -U csctoss_owner \
         -t \
         -c "SELECT public.set_change_log_staff_id (3);
             update unique_identifier
                set value = '$NEWMDN'
              where equipment_id = $EQUIPID
                and unique_identifier_type = 'MDN'
                AND value = '$CURRMDN'"

done < $DATAFILE

echo "Done!"
