#!/bin/bash
#Simple script to run postgres alert_usage_daily() function.
#Function checks lines that are using a quarter of their total allocated usage and moves
#the lines to alert_usage_daily table for alerting purposes from new contour customer portal
#

source /home/postgres/.bash_profile

CURR_TIMESTAMP=`date`
DATE=`date --date='today' +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/alert_usage_daily_$DATE.log

echo $CURR_TIMESTAMP > $LOGFILE
psql -q -t -c "select * from csctoss.alert_usage_daily()" >> $LOGFILE

# remove log files older than 7 days
find $BASEDIR/logs/alert_usage_daily_* -mtime +7 -exec rm -f {} \;
