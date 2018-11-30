#!/bin/bash
#
# Executes every 5 minutes to check for duplicate IP address value in radreply.
# Same groupname shouldn't have same IP address.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/detect_duplicate_ip.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/detect_duplicate_ip.tmp
ERRFILE=/home/postgres/dba/logs/detect_duplicate_ip.err
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
    cat $ERRFILE | mail -s "Detect duplicate IPs for `hostname` Failed" dba@cctus.com
#    cat $ERRFILE | mail -s "Detect duplicate IPs for `hostname` Failed" yshibuya@cctus.com
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ##################################### #
# SECTION TO FIX CLASS VALUE            #
# ##################################### #

# execute check query
psql -U csctoss_owner -q -c \
"SELECT ug.groupname AS groupname, rr.value AS static_ip_address, COUNT(*) as num_of_ip
FROM radreply rr
JOIN usergroup ug ON (ug.username = rr.username)
WHERE 1 = 1
AND rr.attribute = 'Framed-IP-Address'
AND ug.priority = 50000
GROUP BY ug.groupname, rr.value
HAVING count(*) > 1" > $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "num_of_ip" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
  #cat $TMPFILE | mail -s "`hostname` detect duplicate IPs FAILED!" dba@cctus.com
  cat $TMPFILE | mail -s "`hostname` detect duplicate IPs FAILED!" jobrey@cctus.com,yshibuya@cctus.com
#  cat $TMPFILE | mail -s "`hostname` detect duplicate IPs FAILED!" yshibuya@cctus.com
fi

if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then
  #cat $TMPFILE | mail -s "`hostname` detected duplicate IPs!" dba@cctus.com -c jobrey@cctus.com,jprouty@cctus.com
  cat $TMPFILE | mail -s "`hostname` detected duplicate IPs!" yshibuya@cctus.com -c jobrey@cctus.com,jprouty@cctus.com,tstovicek@cctus.com
#  cat $TMPFILE | mail -s "`hostname` detected duplicate IPs!" yshibuya@cctus.com
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end detect duplicate IPs------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0

