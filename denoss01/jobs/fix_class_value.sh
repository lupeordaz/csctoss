#!/bin/bash
#
# Executes daily to check for incorrect Class attribute value.
# Some of carriers don't send us correct Class attribute value
# in RADIUS accounting packet, so we need to fix it.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/fix_class_value.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/fix_class_value.tmp
ERRFILE=/home/postgres/dba/logs/fix_class_value.err
LOCK=/home/postgres/dba/jobs/`basename $0`.lock

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRFILE
#    cat $ERRFILE | mail -s "Fix Class value for `hostname` Failed" dba@cctus.com
    cat $ERRFILE | mail -s "Fix Class value for `hostname` Failed" yshibuya@cctus.com
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ##################################### #
# SECTION TO FIX CLASS VALUE            #
# ##################################### #

# execute each replchk~ function and capture results in aggregated file
psql -U csctoss_owner -q -t -c "select * from csctoss.fix_class_value_vzw()" > $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "SUCCESS" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
#  cat $TMPFILE | mail -s "`hostname` fix_class_value FAILED!" dba@cctus.com
  cat $TMPFILE | mail -s "`hostname` fix_class_value FAILED!" yshibuya@cctus.com
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end fix class value------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0
