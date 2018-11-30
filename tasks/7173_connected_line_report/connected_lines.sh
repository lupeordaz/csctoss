#!/bin/bash
#
source /home/postgres/.bash_profile

#BASEDIR=/home/postgres/dba
BASEDIR=/home/postgres/lupe/tasks/7173
LOGFILE=$BASEDIR/logs/connected_lines_log.`date '+%Y%m%d'`
TEMPFILE=$BASEDIR/logs/connected_lines.out
#ERRFILE=$BASEDIR/lupe/tasks/6827/logs/oss_info_not_found.`date '+%Y%m%d'`

echo "Connected Lines as of: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

psql -q \
     -t \
     -c "select p.radius_username
           from portal_active_lines_vw p
           join unique_identifier ui ON ui.value = p.esn_hex AND ui.unique_identifier_type = 'ESN HEX'
           join unique_identifier uim ON uim.equipment_id = ui.equipment_id
          where p.is_connected = 'YES'
            and uim.unique_identifier_type = 'MAC ADDRESS'
          order by 1" >> $LOGFILE

# log results and cleanup
echo "" >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of replication report------------------------------" >> $LOGFILE
#mutt -s "Test Mail" gordaz@cctus.com -a mutt_message.txt < mutt_message.txt

mutt -s "Connected Lines as of: `date '+%Y/%m/%d-%H:%M:%S'`" "support@contournetworks.com" -a $LOGFILE < /dev/null
