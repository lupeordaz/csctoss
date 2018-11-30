# !/bin/bash
#
# Executes the dupe_session_check(hours) and packet_of_disconnect() functions for duplicate session detection and manangement.
#
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/dupe_session_check.`date +%Y%m%d`
CRONFILE=$BASEDIR/logs/dupe_session_check.log
TEMPFILE=$BASEDIR/logs/dupe_session_check.out
ERRORFILE=$BASEDIR/logs/dupe_session_check.err
LOCK=$BASEDIR/jobs/`basename $0`.lock

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRORFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRORFILE
    cat $ERRORFILE | mail -s "Dupe Session Check for `hostname` Failed" dba@cctus.com
#    for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
#      cat $ERRORFILE | mail -s "Dupe Session Check for `hostname` Failed" $NAME
#    done
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

# this is the actual sql job
echo "BEG: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
psql -U csctmon_owner -d csctmon -q -t -c "select * from csctmon.dupe_session_check(24,3)"  >  $TEMPFILE
psql -U csctmon_owner -d csctmon -q -t -c "select * from csctmon.packet_of_disconnect(128)" >> $TEMPFILE

# these are the old function calls without parameterized settings - kept for history purposes
### psql -U csctmon_owner -d csctmon -q -t -c "select * from csctmon.dupe_session_check(24)" >  $TEMPFILE
### psql -U csctmon_owner -d csctmon -q -t -c "select * from csctmon.packet_of_disconnect()" >> $TEMPFILE

# check the cron file for errors
if [ `grep -i "error" $CRONFILE | wc -l` -ne 0 ]; then
  cp $CRONFILE "$CRONFILE".save
  cat $CRONFILE | mail -s "Dupe Session Check for `hostname` resulted in ERROR" dba@cctus.com
fi

# check output for SUCCESS, if not job failed and send email
if [ `grep -i "error" $TEMPFILE | wc -l` -ne 0 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Dupe Session Check for `hostname` resulted in ERROR" $NAME
  done
elif [ `grep "SUCCESS" $TEMPFILE | wc -l` -eq 0 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Dupe Session Check for `hostname` did not result in SUCCESS" $NAME
  done
fi

sed '/^$/d' $TEMPFILE >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of dupe session check report------------------------------" >> $LOGFILE

# get the acctstartdelay for latest record and make sure less than 3 minutes
DELAY=`psql -U csctmon_owner -d csctmon -q -t -c \
  "select acctstartdelay 
     from csctmon.master_radacct
    where acctstartdelay is not null
 order by master_radacctid desc limit 1"`

if [ $DELAY -gt 180 ]; then
  echo "CSCTMON (`hostname`) AcctStartDelay is $DELAY seconds." | mail -s "CSCTMON (`hostname`) Delay Exceeds Threshold." ops@contournetworks.net
#  echo "CSCTMON (`hostname`) AcctStartDelay is $DELAY seconds." | mail -s "CSCTMON (`hostname`) Delay Exceeds Threshold." drensby@cctus.com
fi

rm -f "${LOCK}"
exit 0
