#!/bin/bash
# Script to periodically backup the csctmon database to standard postgres dumpfile.
#set -x
source /home/postgres/.bash_profile

BASEDIR=/home/postgres/dba
BACKDIR=/pgdata/backups
export BAKDATE=`date '+%Y%m%d%H%M%S'`
export BAKFILE=$BACKDIR/csctmon_backup.$BAKDATE
export BAKLOG=$BASEDIR/logs/csctmon_backup.$BAKDATE.log
export CRONLOG=$BASEDIR/logs/csctmon_backup.cronlog
touch $CRONLOG

echo "CSCT `hostname` CSCTOSS Database Backup Report"                           >  $BAKLOG
echo "----------------------------------------------------"                     >> $BAKLOG
echo "Start Date: `date`"                                                       >> $BAKLOG
echo ""                                                                         >> $BAKLOG

# make sure database is up, if not send down message
if [ `pg_ctl status | grep "server is running" | wc -l` -lt 1 ]; then
  echo "CSCT `hostname` CSCTOSS Database is not running ... backup aborted"	>> $BAKLOG
  cat $BAKLOG $CRONLOG | mail -s "CSCT `hostname` DB Backup FAILED!" dba@cctus.com
  exit
fi

# remove stale backups - retain rolling set of 12
if [ `ls $BACKDIR/csctmon_backup.* | wc -l` -gt 12 ]; then
  kounter=`ls $BACKDIR/csctmon_backup.* | wc -l`
  kounter=`expr $kounter - 12`
  ls -tr $BACKDIR/csctmon_backup.* | head -$kounter | xargs -i rm {}	>> $BAKLOG
fi

# remove stale logs - retail rolling set of 12
if [ `ls $BASEDIR/logs/csctmon_backup.*.log | wc -l` -gt 12 ]; then
  kounter=`ls $BASEDIR/logs/csctmon_backup.*.log | wc -l`
  kounter=`expr $kounter - 12`
  ls -tr $BASEDIR/logs/csctmon_backup.*.log | head -$kounter | xargs -i rm {} >> $BAKLOG 
fi

# run the pg_dump command with appropriate parameters
pg_dump -C -U postgres -v csctmon > $BAKFILE
gzip $BAKFILE
BAKFILE=$BAKFILE.gz

# check to see file exists and has size (success), otherwise send failure report
if [ -s "$BAKFILE" ]; then
#  cat $BAKLOG $CRONLOG | mail -s "CSCT `hostname` DB Backup Report" dba@cctus.com
echo "Do not mail success"
else
  cat $BAKLOG $CRONLOG | mail -s "CSCT `hostname` DB Backup FAILED!!!" dba@cctus.com
fi

# cleanup and exit
cat $BAKLOG $CRONLOG > $BAKLOG.new
mv $BAKLOG.new $BAKLOG
rm -f $CRONLOG
exit 0
