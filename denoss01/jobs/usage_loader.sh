# !/bin/bash
#
# Executes the mrac_loader() and mrpa_loader() functions to pull acct and auth data from radius databases.
#
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/usage_loader.`date +%Y%m%d`
TEMPFILE=$BASEDIR/logs/usage_loader.out
ERRORFILE=$BASEDIR/logs/usage_loader.err
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
    for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
      cat $ERRORFILE | mail -s "Usage Loader for `hostname` Failed" $NAME
    done
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

# this is the actual sql job
echo "BEG: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
psql -U slony -d csctoss -q -t -c "select * from mrac_loader()" >  $TEMPFILE
psql -U slony -d csctoss -q -t -c "select * from mrpa_loader()" >> $TEMPFILE

# check output for SUCCESS, if not job failed and send email
if [ `grep "ERROR" $TEMPFILE | wc -l` -ne 0 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Usage Loader for `hostname` resulted in ERROR" $NAME
  done
elif [ `grep "WARNING" $TEMPFILE | wc -l` -ne 0 ]; then
#  cat $TEMPFILE | mail -s "Usage Loader for `hostname` resulted in WARNING" dba@cctus.com
  cat $TEMPFILE | mail -s "Usage Loader for `hostname` resulted in WARNING" dba@cctus.com
elif [ `grep "SUCCESS" $TEMPFILE | wc -l` -ne 2 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Usage Loader for `hostname` did not result in SUCCESS" $NAME
  done
fi

sed '/^$/d' $TEMPFILE >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of usage loader report------------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0
