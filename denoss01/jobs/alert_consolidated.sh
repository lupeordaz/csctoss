#!/bin/bash
#
# Simple job to call the following functions, catenate output, and email results.
#   1) NAS-Error top 20
#   2) Admin-Reset top 20
#   3) Short Session top 20 
#
# $Id: $
#
source /home/postgres/.bash_profile

DATE=`date --date='yesterday' +%Y%m%d`
SUBJECT="Sprint & USCC Top 20 Consolidated Report for $DATE"
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/alert_consolidated.$DATE

# prettyize message, exec function, capture results
echo "$SUBJECT" > $LOGFILE
echo "-----------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -t -c "select * from csctoss.alert_nas_error(20)" >> $LOGFILE
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" >> $LOGFILE
echo "" >> $LOGFILE
psql -q -t -c "select * from csctoss.alert_admin_reset(20)" >> $LOGFILE
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" >> $LOGFILE
echo "" >> $LOGFILE
psql -q -t -c "select * from csctoss.alert_short_session(20)" >> $LOGFILE

# email the report
###cat $LOGFILE | mail -s "$SUBJECT" dba@cctus.com

#for NAME in {"dba@cctus.com","jprouty@cctus.com","jobrey@cctus.com","gdeickman@cctus.com","mwinn@contournetworks.com","bkrewson@cctus.com","jreed@cctus.com"}; do
for NAME in {"dba@cctus.com","jprouty@cctus.com","jobrey@cctus.com","gdeickman@cctus.com"}; do
  cat $LOGFILE | mail -s "$SUBJECT" $NAME
done

# remove log files older than 7 days
find $BASEDIR/logs/alert_consolidated.* -mtime +7 -exec rm -f {} \;
exit 0
