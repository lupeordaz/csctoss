#!/bin/bash
#
# Report number of active lines per carrier for Kudo-san.
#
# $Id: $
#

source /home/postgres/.bash_profile
LOGFILE=/home/postgres/dba/logs/report_num_of_active_lines.`date '+%Y%m%d'`
TMPFILE=/home/postgres/dba/logs/report_num_of_active_lines.tmp
ERRFILE=/home/postgres/dba/logs/report_num_of_active_lines.err
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
    cat $ERRFILE | mail -s "Report number of active lines for `hostname` Failed" dba@cctus.com
    exit 1
  fi
else
  echo $$ > "${LOCK}"
fi

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE

# ################################################### #
# SECTION TO GENERATE NUM OF ACTIVE LINES PER CARRIER #
# ################################################### #

echo "[Report number of OSS active lines per carrier]" > $TMPFILE
echo "                                               " >> $TMPFILE

# execute query
psql -U csctoss_owner -q -c \
"SELECT
  CASE
    WHEN substr(un.username, 10) ~ '@vzw' THEN 'Verizon'
    WHEN substr(un.username, 10) ~ '@tsp' THEN 'Sprint'
    WHEN substr(un.username, 10) ~ '@uscc.net' THEN 'USCC'
    ELSE 'OTHERS'
  END AS Carrier,
  COUNT(*) AS num_of_active

FROM line
JOIN line_equipment le ON (line.line_id = le.line_id)
JOIN username un ON (line.radius_username = un.username)
WHERE 1 = 1
AND le.end_date IS NULL
GROUP BY
  CASE
    WHEN substr(un.username, 10) ~ '@vzw' THEN 'Verizon'
    WHEN substr(un.username, 10) ~ '@tsp' THEN 'Sprint'
    WHEN substr(un.username, 10) ~ '@uscc.net' THEN 'USCC'
    ELSE 'OTHERS'
  END" >> $TMPFILE

# remove blank lines
sed '/^$/d' $TMPFILE > $TMPFILE.tmp
mv $TMPFILE.tmp $TMPFILE

# check results and email any failures
if [ `grep "num_of_active" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE >> $LOGFILE
  cat $TMPFILE | mail -s "`hostname` report number of active lines FAILED!" dba@cctus.com
fi

if [ `grep "(0 rows)" $TMPFILE | wc -l` -ne 1 ]; then
  cat $TMPFILE | mail -s "Report number of OSS active lines per carrier." ykudo@j-com.co.jp,yshibuya@j-com.co.jp
fi

echo "END   TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "------------------------end report number of OSS active lines------------------------" >> $LOGFILE

rm -f "${LOCK}"
exit 0

