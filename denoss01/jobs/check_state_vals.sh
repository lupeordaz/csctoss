#!/bin/bash
#
##Simple script that logs into jbilling db and checks contact, sales_tax, and
##telcom_tax tables for state_province values that dont meet required format
##and emails a notification if any are found
#

source /home/postgres/.bash_profile

DATE=`date +"%Y%m%d"`
DATE2=`date +"%Y-%m-%d"`
REGEXVAL='[A-Z]{2}'
RECIP1=yshibuya@cctus.com
RECIP=dba@cctus.com,nyoda@cctus.com
BASEDIR=/home/postgres/dba/
LOGFILE=$BASEDIR/logs/check_state_vals.$DATE.log

echo $DATE2 >$LOGFILE
echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

PGPASSWORD=wr1t3r psql -h denjbi02 -p 5440 -U oss_writer  -d jbilling -c "SELECT * FROM oss.check_state_vals();" >> $LOGFILE

NUM_ROWS=`cat $LOGFILE|sed 's/[()]//g'|grep "rows"| awk '{ print $1}'`

if [[ "$NUM_ROWS" -gt 0 ]];then
   cat $LOGFILE | mail -s "Jbilling: Incorrect state values found and corrected" $RECIP 
else
   :
fi

#remove log files older than 7 days
find $BASEDIR/logs/check_state_vals.* -mtime +7 -exec rm -f {} \;
exit 0

