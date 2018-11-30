#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/gordaz
DATE=`date --date='yesterday' +%Y%m%d`

INPTFILE=$BASEDIR/tasks/8938_mdn_correction/correctedMDN_MIN.csv
#INPTFILE=$BASEDIR/tasks/8938_mdn_correction/testfile.csv
DATAFILE=$BASEDIR/tasks/8938_mdn_correction/corrections.csv
LOGFILE=$BASEDIR/tasks/8938_mdn_correction/logs/correction_log.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" 
#echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
#echo "Equip Id|OSS ESN HEX" >> $LOGFILE
#echo "Equip Id|SOUP ESN HEX|OSS ESN HEX" >> $ESNFIXFILE
#echo "Equip Id|ESN DEC|MAC Address" >> $ERRFILE
echo 
IFS=","
while read USERNM EQUIPID CURRMIN CURRMDN NEWMIN NEWMDN
do
#    echo "Username: " $USERNM "   Equip. Id.: " $EQUIPID "   Correct MDN/MIN:  " $OPTMDN "/" $OPTMIN

    OLDMIN=`psql -q \
                 -h testoss01.cctus.com  \
                 -d csctoss \
                 -p 5450  \
                 -U csctoss_owner \
                 -t \
                 -c "select value 
                       from unique_identifier 
                      where equipment_id = $EQUIPID
                        and unique_identifier_type = 'MIN';"`

    OLDMDN=`psql -q \
         -h testoss01.cctus.com  \
         -d csctoss \
         -p 5450  \
         -U csctoss_owner \
         -t \
         -c "select value 
               from unique_identifier 
              where equipment_id = $EQUIPID
                and unique_identifier_type = 'MDN';"`

    echo "$USERNM,$EQUIPID,$OLDMIN,$OLDMDN,$NEWMIN,$NEWMDN" >> $DATAFILE

done < $INPTFILE

echo "Done!"
