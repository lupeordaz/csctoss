#!/bin/bash
#
# Executes daily to check for replication errors by performing except queries between csctoss master and all radiusdb databases in system_parameter.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/replication_check.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/replication_check.tmp
ERRFILE=/home/postgres/dba/logs/replication_check.err
LOCK=/home/postgres/dba/jobs/`basename $0`.lock
HOSTLIKE=`expr substr \`hostname\` 1 3`

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRFILE
    cat $ERRFILE | mail -s "Replication Check for `hostname` Failed" dba@cctus.com
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ##################################### #
# SECTION TO CHECK OSS VS RADIUSDB DATA #
# ##################################### #

# execute each replchk~ function and capture results in aggregated file
psql -U slony -q -t -c "select * from public.replchk_attribute_type('$HOSTLIKE')"  > $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_attribute('$HOSTLIKE')"      >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_groupname('$HOSTLIKE')"      >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_nas('$HOSTLIKE')"            >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_radcheck('$HOSTLIKE')"       >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_radgroupcheck('$HOSTLIKE')"  >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_radgroupreply('$HOSTLIKE')"  >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_radreply('$HOSTLIKE')"       >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_usergroup('$HOSTLIKE')"      >> $TMPFILE
psql -U slony -q -t -c "select * from public.replchk_username('$HOSTLIKE')"       >> $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "BOUND" $TMPFILE | wc -l` -gt 0 ]; then
  cat $TMPFILE >> $LOGFILE
  cat $TMPFILE | mail -s "`hostname` Replication Check FAILED!" dba@cctus.com
fi

# ###################################### #
# SECTION TO CHECK SLONY LOGS FOR ERRORS #
# ###################################### #

currfile=`ls -tr $SLONYLOGS/*log | tail -1`
grep -ir "error" $currfile > $SLONYLOGS/error.report
if [ -s $SLONYLOGS/error.report ]; then
  cat $SLONYLOGS/error.report | mail -s "Slony failure : `hostname`" $LOGRECIPIENT
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end replication check------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0
