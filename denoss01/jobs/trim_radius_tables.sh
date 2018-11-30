#!/bin/bash
# Script to trim radius tables master_radacct, master_radpostauth and sprint_master_radacct to 7 days.
#
source /home/postgres/.bash_profile 1

LOGFILE=/home/postgres/dba/logs/trim_radius_tables.log
ERRORLOG=/home/postgres/dba/logs/trim_radius_tables.err

# make sure database is up, if not send error message
if [ `pg_ctl status | grep "postmaster is running" | wc -l` -lt 1 ]; then
   echo "CSCTOSS `hostname`  Database is not running ... "      > $ERRORLOG
   cat $ERRORLOG | mail -s "CSCTOSS `hostname` Trim Radius Tables Job Failed!" dba@cctus.com
  exit 1
fi

# log begin, counts, end to rolling logfile
echo "BEG: `date '+%Y%m%d%H%M%S'`"                              >> $LOGFILE

psql -U csctoss_owner -c "delete from csctoss.master_radacct where acctstarttime < (current_date-3)" > ./mrac.tmp
psql -U csctoss_owner -c "delete from csctoss.master_radpostauth where authdate < (current_date-3)" > ./mrpa.tmp
psql -U csctoss_owner -c "delete from csctoss.sprint_master_radacct where acctstarttime < (current_date-3)" > ./smrac.tmp

echo "===> `head -1 ./mrac.tmp` MRAC rows  :  `head -1 ./mrpa.tmp` MRPA rows  :  `head -1 ./smrac.tmp` SMRAC rows" >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of report------------------------------" >> $LOGFILE

rm -f ./mrac.tmp ./mrpa.tmp ./smrac.tmp
exit 0
