#!/bin/bash
# Script to periodically backup the csctoss database to standard postgres dumpfile.
source /home/postgres/.bash_profile
ORG=CSCT

BASEDIR=/home/postgres/dba
BACKDIR=/pgdata/backups
BAKFILE=$BACKDIR/"$PGDATABASE"_backup.H`date '+%H'`
BACKLOG=$BASEDIR/logs/"$PGDATABASE"_backup.H`date '+%H'`.log
CRONLOG=$BASEDIR/logs/"$PGDATABASE"_backup.log

echo "$ORG `hostname` $PGDATABASE Database Backup Report"   >  $BACKLOG
echo "----------------------------------------------------" >> $BACKLOG
echo "Start Date: `date`"                                   >> $BACKLOG
echo ""                                                     >> $BACKLOG

# make sure database is up, if not send down message
if [ `pg_ctl status | grep "postmaster is running" | wc -l` -lt 1 ]; then
  echo "$ORG `hostname` $PGDATABASE Database is not running ... backup aborted" >> $BACKLOG
  cat $BACKLOG $CRONLOG | mail -s "$ORG `hostname` DB Backup FAILED!" dba@cctus.com
  exit
fi

# run the pg_dumpall command with appropriate parameters
pg_dumpall -U postgres --disable-dollar-quoting > $BAKFILE
gzip -f $BAKFILE
BAKFILE=$BAKFILE.gz

# check to see file exists and has size (success), otherwise send failure report
if [ -s "$BAKFILE" ]; then
#  cat $BACKLOG $CRONLOG | mail -s "$ORG `hostname` DB Backup Report" dba@cctus.com
echo "Do not mail success"
else
  cat $BACKLOG $CRONLOG | mail -s "$ORG `hostname` DB Backup FAILED!!!" dba@cctus.com
fi

# cleanup and exit
cat $BACKLOG $CRONLOG > $BACKLOG.new
mv $BACKLOG.new $BACKLOG
rm -f $CRONLOG
exit 0
