#!/bin/bash
#
# Report number of "Port-Preempted" report.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/report_port_preempted.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/report_port_preempted.tmp
ERRFILE=/home/postgres/dba/logs/report_port_preempted.err
LOCK=/home/postgres/dba/jobs/`basename $0`.lock

ERREMAIL=dba@cctus.com
EMAILTO=gdeickman@cctus.com,jprouty@cctus.com,jobrey@cctus.com,csharkey@j-com.co.jp,yshibuya@j-com.co.jp,tstovicek@cctus.com,gordaz@cctus.com

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRFILE
    cat $ERRFILE | mail -s "Report Port-Preempted for `hostname` Failed" ${ERREMAIL}
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ################################## #
# SECTION TO GENERATE Port-Preempted #
# ################################## #

REPORT_FROM=`TZ=MST date -d '24 hours ago' +'%Y/%m/%d %H:%M'`
REPORT_TO=`TZ=MST date +'%Y/%m/%d %H:%M'`
echo "[Report Acct Port-Preempted  <${REPORT_FROM} -> ${REPORT_TO}>(MST)]" > $TMPFILE
echo "                                               " >> $TMPFILE

# execute query
TABLESUFFIX=`TZ=MST date -d '1 day ago' +'%Y%m'`
psql -U csctoss_owner -q --pset=border=2 -c \
"
SELECT
  be.name AS billing_entity,
  log.username AS username,
  log.num_of_port_preempted AS num_of_port_preempted
FROM dblink(fetch_csctlog_conn(),
            'SET TimeZone TO ''MST'';
            SELECT username, COUNT(*) AS num_of_port_preempted
            FROM csctlog.master_radacct_${TABLESUFFIX}
            WHERE 1 = 1
            AND acctterminatecause = ''Port-Preempted''
            AND acctstoptime >= (now() - ''24 hours''::INTERVAL)
            GROUP BY username
            ') AS log (username text, num_of_port_preempted bigint)
LEFT OUTER JOIN username un ON (log.username = un.username)
LEFT OUTER JOIN line ON (line.radius_username = un.username)
LEFT OUTER JOIN billing_entity be ON (be.billing_entity_id = line.billing_entity_id)
ORDER BY be.name
" >> $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "num_of_port_preempted" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
  cat $TMPFILE | mail -s "`hostname` report Port-Preempted FAILED!" ${ERREMAIL}
fi

if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE | mail -s "Report Port-Preempted." ${EMAILTO}
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end report Port-Preempted------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0

