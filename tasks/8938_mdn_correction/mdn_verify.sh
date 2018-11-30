#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/gordaz
DATE=`date --date='yesterday' +%Y%m%d`

#INPTFILE=$BASEDIR/tasks/8938_mdn_correction/correctedMDN_MIN.csv
INPTFILE=$BASEDIR/tasks/8938_mdn_correction/testfile.csv

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" 
echo 

IFS=","
while read USERNM EQUIPID CURRMIN CURRMDN NEWMIN NEWMDN
do
#    echo "$USERNM,$EQUIPID,$CURRMIN,$CURRMDN,$NEWMIN,$NEWMDN"

    UPDMIN=`psql -q \
                 -h testoss01.cctus.com  \
                 -d csctoss \
                 -p 5450  \
                 -U csctoss_owner \
                 -t \
                 -c "select value 
                       from unique_identifier 
                      where equipment_id = $EQUIPID
                        and unique_identifier_type = 'MIN';"`

    UPDMDN=`psql -q \
         -h testoss01.cctus.com  \
         -d csctoss \
         -p 5450  \
         -U csctoss_owner \
         -t \
         -c "select value 
               from unique_identifier 
              where equipment_id = $EQUIPID
                and unique_identifier_type = 'MDN';"`

    if [[ "$NEWMIN" -ne "$UPDMIN" ]]; then
        echo "MIN Outage!"
        echo "$EQUIPID,$NEWMIN,$UPDMIN" 
    fi

    if [[ "$NEWMDN" -ne "$UPDMDN" ]]; then
        echo "MDN Outage!"
        echo "$EQUIPID,$NEWMDN,$UPDMDN" 
    fi

done < $INPTFILE

echo "Done!"
