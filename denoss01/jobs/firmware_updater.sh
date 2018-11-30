#!/bin/bash
#
# Downstream job to add new equipment firmware and update equipment table with latest data from GMU and SOUP.
#
# $Id: $
#
source /home/postgres/.bash_profile

DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/firmware_updater.$DATE
DATFILE=$BASEDIR/logs/firmware_updater.dat

# check for -1 in pk field for table firmware_gmu
COUNT=`psql -q -t -c "select count(*) from csctoss.firmware_gmu where firmware_gmu_id = -1"`
if [ $COUNT -ne 1 ]; then
  echo "GMU table firmware_gmu load failed or incomplete." | mail -s "Firmware Updater (GMU) Job FAILED!" dba@cctus.com
  exit 1
fi

# check for -1 in pk field for table firmware_soup
COUNT=`psql -q -t -c "select count(*) from csctoss.firmware_soup where did = -1"`
if [ $COUNT -ne 1 ]; then
  echo "SOUP table firmware_soup load failed or incomplete." | mail -s "Firmware Updater (SOUP) Job FAILED!" dba@cctus.com
  exit 2
fi

# execute function firmware_gmu_loader() to process GMU firmware and capture results
echo "Executing function firmware_gmu_loader() ..."  > $LOGFILE
echo "--------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -t -c "select * from csctoss.firmware_gmu_loader()" >> $LOGFILE

COUNT=`psql -q -t -c "select count(*) from csctoss.firmware_gmu where status = 'ERROR'"`
echo "$COUNT GMU ERRORS..." >> $LOGFILE
echo "" >> $LOGFILE

# execute function firmware_soup_loader() to process SOUP firmware and capture results
echo "Executing function firmware_soup_loader() ..." >> $LOGFILE
echo "---------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -t -c "select * from csctoss.firmware_soup_loader()" >> $LOGFILE

COUNT=`psql -q -t -c "select count(*) from csctoss.firmware_soup where status = 'ERROR'"`
echo "$COUNT SOUP ERRORS..." >> $LOGFILE
echo "" >> $LOGFILE

COUNT=`grep "SUCCESS" $LOGFILE | wc -l`
if [ $COUNT -ne 2 ]; then
  echo "GMU or SOUP Firmware Function did not result in SUCCESS." | mail -s "Firmware Updater Function Call FAILED!" dba@cctus.com
  exit 3
fi

# email the exception report
cat $LOGFILE | mail -s "Firmware Updater Job Results For $DATE" dba@cctus.com

# email the new firmware id notification
COUNT=`psql -q -t -c "select primary_key
                        from change_log
                       where table_name = '\"csctoss\".\"equipment_firmware\"'
                         and change_timestamp > current_timestamp - interval '1 days'
                         and change_type = 'I'
                    order by primary_key::integer
                       limit 1"`

COUNT=${COUNT/ /}

if [ ! -z $COUNT ]; then
  psql -q -c "select clog.primary_key as equipment_firmware_id
                            ,firm.equipment_model_id
                            ,emod.model_number1
                            ,firm.firmware_version
                        from csctoss.change_log clog
                        join csctoss.equipment_firmware firm on (clog.primary_key::integer = firm.equipment_firmware_id)
                        join csctoss.equipment_model emod using (equipment_model_id)
                       where clog.table_name = '\"csctoss\".\"equipment_firmware\"'
                         and clog.change_timestamp > current_timestamp - interval '1 days'
                         and clog.change_type = 'I'
                    order by clog.primary_key::integer" > $DATFILE

#  cat $DATFILE | mail -s "New Firmware Versions Exist" dba@cctus.com

  for NAME in {"cmitchell@cctus.com","dba@cctus.com","jprouty@cctus.com","jobrey@cctus.com"}; do
    cat $DATFILE | mail -s "New Firmware Versions Exist" $NAME
  done

fi

# remove log files older than 7 days
find $BASEDIR/logs/firmware_updater.* -mtime +7 -exec rm -f {} \;
exit 0
