#!/bin/bash
#
# Report number of access rejects.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/report_access_reject.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/report_access_reject.tmp
ERRFILE=/home/postgres/dba/logs/report_access_reject.err
LOCK=/home/postgres/dba/jobs/`basename $0`.lock

ERREMAIL=dba@cctus.com
EMAILTO=gdeickman@cctus.com,jprouty@cctus.com,jobrey@cctus.com,csharkey@j-com.co.jp,yshibuya@j-com.co.jp

# make sure process not already running
if [ -f "${LOCK}" ]; then
  MYPID=`head -n 1 "${LOCK}"`
  TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`

  if [ -z "${TEST_RUNNING}" ]; then
    echo $$ > "${LOCK}"
  else
    echo `date`                                                          > $ERRFILE
    echo "`basename $0` is already running [${MYPID}] - Exiting"        >> $ERRFILE
    cat $ERRFILE | mail -s "Report number of access rejects for `hostname` Failed" ${ERREMAIL}
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ######################################### #
# SECTION TO GENERATE NUM OF ACCESS REJECTS #
# ######################################### #

REPORT_FROM=`TZ=MST date -d '24 hours ago' +'%Y/%m/%d %H:%M'`
REPORT_TO=`TZ=MST date +'%Y/%m/%d %H:%M'`
echo "[Report number of access rejects  <${REPORT_FROM} -> ${REPORT_TO}>(MST)]" > $TMPFILE
echo "                                               " >> $TMPFILE

# execute query
TABLESUFFIX=`TZ=MST date -d '1 day ago' +'%Y%m'`
psql -U csctoss_owner -q --pset=border=2 -c \
"
SELECT
  be.name AS billing_entity,
  log.username AS username,
  CASE
    WHEN un.username IS NULL THEN 'Not in username table'
    ELSE 'In username table'
  END AS is_username_exist,
  log.num_of_rejects AS num_of_rejects
FROM dblink(fetch_csctlog_conn(),
            'SET TimeZone TO ''MST'';
            SELECT username, COUNT(*) AS num_of_rejects
            FROM csctlog.master_radpostauth_${TABLESUFFIX}
            WHERE 1 = 1
            AND reply = ''Access-Reject''
            AND authdate >= (now() - ''24 hours''::INTERVAL)
            GROUP BY username
            ') AS log (username text, num_of_rejects bigint)
LEFT OUTER JOIN username un ON (log.username = un.username)
LEFT OUTER JOIN line ON (line.radius_username = un.username)
LEFT OUTER JOIN billing_entity be ON (be.billing_entity_id = line.billing_entity_id)
ORDER BY be.name
" >> $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "num_of_rejects" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
  cat $TMPFILE | mail -s "`hostname` report number of access rejects FAILED!" ${ERREMAIL}
fi

if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE | mail -s "Report number of access rejects." ${EMAILTO}
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end report number of access rejects------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0

