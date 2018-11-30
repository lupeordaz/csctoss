#!/bin/bash
#
# Executes every 5 minutes to check for duplicate IP address value in radreply.
# Same groupname shouldn't have same IP address.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/detect_missing_ips.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/detect_missing_ips.tmp
ERRFILE=/home/postgres/dba/logs/detect_missing_ips.err
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
    cat $ERRFILE | mail -s "Detect missing IPs for `hostname` Failed" dba@cctus.com
#    cat $ERRFILE | mail -s "Detect missing IPs for `hostname` Failed" yshibuya@cctus.com
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ##################################### #
# SECTION TO DETECT MISSING IPS         #
# ##################################### #

# execute check query
psql -U csctoss_owner -q -c \
"SELECT rr.id,rr2.value,rr.username,sp.static_ip,sp.is_Assigned 
FROM radreply rr
LEFT OUTER JOIN  radreply rr2 on (rr.username = rr2.username and rr2.attribute = 'Class')
JOIN static_ip_pool sp on sp.static_ip = rr.value
WHERE 1=1
AND rr.attribute = 'Framed-IP-Address'
AND sp.is_assigned = false" > $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "is_assigned" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
#  cat $TMPFILE | mail -s "`hostname` detect missing IPs FAILED!" dba@cctus.com
  cat $TMPFILE | mail -s "`hostname` detect missing IPs FAILED!" yshibuya@cctus.com
fi

if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then
#if [ `grep "(0 rows)" $TMPFILE | wc -l` -eq 1 ]; then
#  cat $TMPFILE | mail -s "`hostname` detected missing IPs!" dba@cctus.com -c jcrawley@cctus.com,jprouty@cctus.com
  cat $TMPFILE | mail -s "`hostname` detected missing IPs!" yshibuya@cctus.com
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end detect missing IPs------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0

