# !/bin/bash
#
# Executes the radius_updater() function to push appropriate radius data to appropriate radius databases.
#
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/radius_updater.`date +%Y%m%d`
TEMPFILE=$BASEDIR/logs/radius_updater.out
ERRORFILE=$BASEDIR/logs/radius_updater.err
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
      cat $ERRORFILE | mail -s "Radius Updater for `hostname` Failed" $NAME
    done
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

# this is the actual sql job
echo "BEG: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
psql -U slony -d csctoss -q -t -c "select * from radius_updater()" > $TEMPFILE

# check output for SUCCESS, if not job failed and send email
if [ `grep "ERROR" $TEMPFILE | wc -l` -ne 0 ]; then
  cat $TEMPFILE | mail -s "Radius Updater for `hostname` Failed" dba@cctus.com
fi

# log results and cleanup
cat $TEMPFILE >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of replication report------------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0
