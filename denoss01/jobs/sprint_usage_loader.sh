# !/bin/bash
#
# Executes the smrac_loader() function to pull Sprint acct data from radius databases.
#
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/smrac_loader.`date +%Y%m%d`
TEMPFILE=$BASEDIR/logs/smrac_loader.out
ERRORFILE=$BASEDIR/logs/smrac_loader.err
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
      cat $ERRORFILE | mail -s "Sprint MRAC Loader for `hostname` Failed" $NAME
    done
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

# this is the actual sql job
echo "BEG: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
psql -U slony -d csctoss -q -t -c "select * from smrac_loader()" >  $TEMPFILE

# check output for SUCCESS, if not job failed and send email
if [ `grep "ERROR" $TEMPFILE | wc -l` -ne 0 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Sprint MRAC Loader for `hostname` resulted in ERROR" $NAME
  done
elif [ `grep "SUCCESS" $TEMPFILE | wc -l` -ne 1 ]; then
  for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
    cat $TEMPFILE | mail -s "Sprint MRAC Loader for `hostname` did not result in SUCCESS" $NAME
  done
fi

sed '/^$/d' $TEMPFILE >> $LOGFILE
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "-------------------------end of sprint mrac loader report-------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0
