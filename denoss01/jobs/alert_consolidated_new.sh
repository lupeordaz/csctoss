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
SUBJECT="Sprint & USCC & Verizon Top 20 Consolidated Report for $DATE"
BASEDIR=/home/postgres/dba
LOGFILE=$BASEDIR/logs/alert_consolidated_new_$DATE.txt

# prettyize message, exec function, capture results
echo "$SUBJECT" > $LOGFILE
echo "-----------------------------------------------------" >> $LOGFILE
echo "" >> $LOGFILE

psql -q -t -c "select * from csctoss.alert_nas_error_new(20)" >> $LOGFILE
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" >> $LOGFILE
echo "" >> $LOGFILE
psql -q -t -c "select * from csctoss.alert_admin_reset_new(20)" >> $LOGFILE
echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=" >> $LOGFILE
echo "" >> $LOGFILE
psql -q -t -c "select * from csctoss.alert_short_session_new(20)" >> $LOGFILE

# email the report



RECIP1="yshibuya@cctus.com"
#ECIP2="gdeickman@cctus.com,bkrewson@cctus.com,nyoda@cctus.com,yshibuya@j-com.co.jp,jprouty@cctus.com,ktaylor@cctus.com,dolson@cctus.com,btekeste@cctus.com"
RECIP3="yshibuya@cctus.com"
#RECIP2="dba@cctus.com,jprouty@cctus.com,jobrey@cctus.com,gdeickman@cctus.com,mwinn@contournetworks.com,nyoda@cctus.com,csharkey@j-com.co.jp,tstovicek@cctus.com"
RECIP2="dba@cctus.com,jprouty@cctus.com,jobrey@cctus.com,gdeickman@cctus.com,csharkey@j-com.co.jp,tstovicek@cctus.com"


#mutt -s "SPRINT & USCC TOP 20 Consolidated Report for $DATE (with signal strength)" -a $LOGFILE  btekeste@cctus.com < ${LOGFILE}

for NAME in $RECIP2; do
  #mutt -s "SPRINT & USCC & VZW TOP 20 Consolidated Report for $DATE" -a $LOGFILE $NAME < ${LOGFILE}
  mutt -s "SPRINT & USCC & VZW TOP 20 Consolidated Report for $DATE" $NAME -a $LOGFILE < ${LOGFILE}
done


# remove log files older than 7 days
find $BASEDIR/logs/alert_consolidated_new_* -mtime +7 -exec rm -f {} \;
#exit 0
