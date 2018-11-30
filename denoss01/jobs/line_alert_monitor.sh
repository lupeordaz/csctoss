#!/bin/bash
#
# Executes function line_alert_monitor every hour at 59 minutes.
#
# $Id: $
#
source /home/postgres/.bash_profile

DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGTEMP=$BASEDIR/logs/line_alert_monitor.log
LOGFILE=$BASEDIR/logs/line_alert_monitor."$DATE"

# call the function and capture results
psql -q -t -c "SELECT * FROM csctoss.line_alert_monitor()" > $LOGTEMP

# check output for SUCCESS, if not job failed and send email
if [ `grep "SUCCESS" $LOGTEMP | wc -l` -ne 1 ]; then
  cat $LOGTEMP | mail -s "Line Alert Monitor job for `hostname` FAILED!!!" dba@cctus.com
else
  # dont mail success
  #cat $LOGFILE | mail -s "CSCTOSS SET PLAN ACCT START DATE REPORT FOR: $DATE" dba@cctus.com
  echo "-----------------------------------------------------------------" >> $LOGFILE
  echo "START: `date`" >> $LOGFILE
  cat $LOGTEMP >> $LOGFILE
  echo "" >> $LOGFILE
fi

# remove log files older than 7 days
find $BASEDIR/logs/line_alert_monitor.* -mtime +7 -exec rm -f {} \;
exit 0
