#!/bin/bash
# 
# Packet of Disconnect job for Sprint pre-paid users.
#
source /home/postgres/.bash_profile
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/pod.`date +%Y%m%d`
OUTFILE=$BASEDIR/logs/pod.out
ATLFILE=$BASEDIR/logs/pod.atl
DENFILE=$BASEDIR/logs/pod.den
ERRFILE=$BASEDIR/logs/pod.err
LOCK=$BASEDIR/jobs/`basename $0`.lock

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRFILE
    for NAME in {"dba@cctus.com","gdeickman@contournetworks.com"}; do
      cat $ERRFILE | mail -s "Sprint POD for `hostname` Failed" $NAME
    done
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

# start timestamp
echo "BEG: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# call the sprint_pod() function and capture results
psql -A -t -q -U postgres -c "select * from csctoss.sprint_pod()" > $OUTFILE

# split the results file into appropriate file based on nasidentifier (LENS=)
grep "LENS=ATL" $OUTFILE | cut -d "#" -f1 > $ATLFILE
grep "LENS=DEN" $OUTFILE | cut -d "#" -f1 > $DENFILE

# atlanta lns
if [ -s $ATLFILE ]; then
  radclient -x -r 1 -p `wc -l < $ATLFILE` 10.17.0.1:1739 -f $ATLFILE disconnect CSCT80pod >> $LOGFILE
fi

# denver lns
if [ -s $DENFILE ]; then
  radclient -x -r 1 -p `wc -l < $DENFILE` 10.17.0.1:1739 -f $DENFILE disconnect CSCT80pod >> $LOGFILE
fi

# end timestamp
echo "END: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------------end of pod report------------------------------" >> $LOGFILE

rm -f "${LOCK}"
