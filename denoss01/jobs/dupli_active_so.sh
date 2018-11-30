#!/bin/bash
#
##Simple script to report any SOs that occur more than once in jbilling with
##active status.
##
#

source /home/postgres/.bash_profile

DATE=`date +"%Y%m%d"`
DATE2=`date +"%Y-%m-%d"`
DATE3=`date +"%Y-%m-%d %T"`
#RECIP=btekeste@cctus.com
RECIP=dba@cctus.com
BASEDIR=/home/postgres/dba/
LOGFILE=$BASEDIR/logs/dupli_active_so.$DATE.log

echo "The following SOs are in Jbilling more than once with "Active" status" > $LOGFILE 
echo "" >> $LOGFILE
echo "" >> $LOGFILE

PGPASSWORD=wr1t3r psql -h denjbi01 -p 5440 -U oss_writer  -d jbilling -c "
   SELECT * 
   FROM (
   	   SELECT count(*), public_number,status_id 
	   FROM purchase_order po
	   WHERE po.status_id = 16
	   GROUP BY public_number,status_id
	   )ss
   WHERE ss.count > 1;" >> $LOGFILE

NUM_ROWS=`cat $LOGFILE|sed 's/[()]//g'|grep "rows"| awk '{ print $1}'`

if [[ "$NUM_ROWS" -gt 0 ]];then
   #cat $LOGFILE | mail -s "Duplicate active SOs found in Jbilling" $RECIP
   #echo $NUM_ROWS
   cat $LOGFILE
else
   :
fi

#remove log files older than 7 days
find $BASEDIR/logs/dupli_active_so.* -mtime +7 -exec rm -f {} \;
exit 0
