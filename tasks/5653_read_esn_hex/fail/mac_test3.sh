#!/bin/bash
#
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/lupe/tasks/5653/data/lo_test_device.csv
LOGFILE=$BASEDIR/lupe/tasks/5653/logs/missing_macs.`date '+%Y%m%d'`

#IFS='|'
read EQUIPID <<< $(psql \
    -X \
    -U postgres \
    -d csctoss \
    --no-align \
    -t \
    -q \
    -c "select e.equipment_id  
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
         where uim.value like '%10637D'")

OSSEQID=`echo $EQUIPID | awk '{print $1}'` 
OSSESN=`echo $EQUIPID | awk '{print $2}'`
OSSMAC=`echo $EQUIPID | awk '{print $3}'` 
OSSPARTNO=`echo $EQUIPID | awk '{print $4}'` 
OSSSN=`echo $EQUIPID | awk '{print $5}'` 
OSSMODEL=`echo $EQUIPID | awk '{print $6}'`
echo $EQUIPID
echo "Equipment Id:  $OSSEQID"  
echo "ESN HEX:       $OSSESN"
echo "Mac Address:   $OSSMAC"  
echo "Part Number:   $OSSPARTNO"
echo "Serial No:     $OSSSN"
echo "Model No:      $OSSSN"
