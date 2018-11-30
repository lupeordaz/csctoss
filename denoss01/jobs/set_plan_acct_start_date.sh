#!/bin/bash
#
# Populates the plan.accouting_start_date column (where null) based on several business rules - see function code.
#
# $Id: $
#
source /home/postgres/.bash_profile

DATE=`date +%Y%m%d`
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/set_plan_acct_start_date.$DATE

# call the set_plan_acct_start_date() function and capture results
psql -q -t -c "SELECT * FROM csctoss.set_plan_acct_start_date()" > $LOGFILE

# check output for SUCCESS, if not job failed and send email
if [ `grep "SUCCESS" $LOGFILE | wc -l` -ne 1 ]; then
  cat $LOGFILE | mail -s "Set Plan Acct Start Date Job for `hostname` FAILED!!!" dba@cctus.com
else
  # dont mail success
  #cat $LOGFILE | mail -s "CSCTOSS SET PLAN ACCT START DATE REPORT FOR: $DATE" dba@cctus.com
  echo "success"
fi

# remove log files older than 7 days
find $BASEDIR/logs/set_plan_acct_start_date.* -mtime +7 -exec rm -f {} \;
exit 0
