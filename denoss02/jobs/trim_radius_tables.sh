#!/bin/bash
# Script to trim radius table master_radacct to 7 days.
#
source /home/postgres/.bash_profile 1

LOGFILE=/home/postgres/dba/logs/trim_radius_tables.log
ERRORLOG=/home/postgres/dba/logs/trim_radius_tables.err

# make sure database is up, if not send error message
if [ `pg_ctl status | grep "server is running" | wc -l` -lt 1 ]; then
   echo "CSCTMON `hostname`  Database is not running ... "      > $ERRORLOG
   cat $ERRORLOG | mail -s "CSCTMON `hostname` Trim Radius Tables Job Failed!" dba@cctus.com
  exit 1
fi

# log begin, counts, end to rolling logfile
echo "BEG: `date '+%Y%m%d%H%M%S'`"                              >> $LOGFILE

#psql -U csctmon_owner -c "delete from csctmon.master_radacct where acctstarttime < (current_date-7)" > ./mrac.tmp
psql -U csctmon_owner -c "delete from csctmon.master_radacct where acctstarttime < (current_date-35)" > ./mrac.tmp

echo "===> `head -1 ./mrac.tmp` MRAC rows" >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of report------------------------------" >> $LOGFILE

rm -f ./mrac.tmp
exit 0
