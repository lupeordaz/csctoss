# !/bin/bash
#
# Script to exectue daily (and if end of month monthly) usage rollups.
# Because of time zone issues and the possibility of 24 hour sessions, there is a one day lag for usage data.
# In other words, if the job executes on the 15th - data is calculated for the 14th.
# 

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/usage_rollup.log.`date +%Y%m%d`
TMPFILE=/home/postgres/dba/logs/usage_rollup.tmp

# determine the run date as curent date - 1
DATE=`date -d "yesterday" +%Y-%m-%d`
DOM=`date +%d`

# header crap
echo "USAGE ROLLUP REPORT (`hostname`) FOR $DATE"                         > $LOGFILE
echo "-----------------------------------------------------------------" >> $LOGFILE
echo ""                                                                  >> $LOGFILE
echo "DATE = $DATE : DOM = $DOM"                                         >> $LOGFILE
echo ""                                                                  >> $LOGFILE

# first execute the scrub routine 2 days back and 2 days ahead
# this iteration for csctlog database
echo "MRAC_DUPLICATE_SCRUB EXEC: csctlog.mrac_duplicate_scrub(current_date-2,current_date+2)"       >> $LOGFILE

psql -h denlog02 -p 5450 -U csctlog_repl -c "SELECT * FROM csctlog.mrac_duplicate_scrub(current_date-2,current_date+2)" csctlog > $TMPFILE

### we no longer house auth or acct data in oss database
### psql -U csctoss_owner -c "SELECT * FROM csctoss.mrad_duplicate_scrub(current_date-2,current_date+2)" > /dev/null

if [ `grep "SUCCESS" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE | mail -s "Master Radacct Scrub (`hostname`) for $DATE FAILED!!!" dba@cctus.com
  ### exit 1
else
  cat $TMPFILE >> $LOGFILE
  echo ""      >> $LOGFILE
fi

# open psql session and execute line_usage_day(...) function for yesterday, evaluate results
echo "LINE_USAGE_DAY_CALC EXEC: csctoss.line_usage_day_calc('$DATE',NULL)"        >> $LOGFILE
psql -U csctoss_owner -c "SELECT * FROM csctoss.line_usage_day_calc('$DATE',NULL)" > $TMPFILE

if [ `grep "SUCCESS" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE | mail -s "Daily Usage Rollup (`hostname`) for $DATE FAILED!!!" dba@cctus.com
  ### exit 2
else
  cat $TMPFILE >> $LOGFILE
  echo ""      >> $LOGFILE
fi

# determine if end of month, if so execute monthly rollup
if [ "$DOM" == "01" ]; then

  YEAR=`date +%Y`
  MONTH=`date +%m`
  MONTH=`expr "$MONTH" + 0`

  # if january, roll back to december otherwise subtract 1
  if [ "$MONTH" == "1" ]; then
    MONTH=12
    #YEAR=`expr $YEAR -1`
    YEAR=`expr $YEAR - 1`
  else
    MONTH=`expr $MONTH - 1`
  fi

  # call the monthly rollup function
  echo "LINE_USAGE_MONTH_CALC EXEC: csctoss.line_usage_month_calc($YEAR,$MONTH)"      >> $LOGFILE
  psql -U csctoss_owner -c "SELECT * FROM csctoss.line_usage_month_calc($YEAR,$MONTH)" > $TMPFILE
  if [ `grep "SUCCESS" $TMPFILE | wc -l` -ne 1 ]; then
    cat $TMPFILE | mail -s "Monthly Usage Rollup (`hostname`) for $YEAR-$MONTH FAILED!!!" dba@cctus.com
    ### exit 3
  else
    cat $TMPFILE >> $LOGFILE
  fi

  # only send success report on the first of the month
  cat $LOGFILE | mail -s "USAGE ROLLUP REPORT (`hostname`) FOR $DATE" dba@cctus.com

else
  echo "Not the first of month. Skip monthly." >> $LOGFILE
fi

exit 0
