#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

ERRFILE=$BASEDIR/lupe/tasks/6827/logs/oss_info_not_found.`date '+%Y%m%d'`
#LOGFILE=$BASEDIR/lupe/tasks/6827/logs/line_esn_log.`date '+%Y%m%d'`

echo "OSS Line Id" > $ERRFILE

psql -q \
     -t \
     -c "select l.line_id
		   from line l
		  where l.end_date IS null
		  order by 1" \
| while read OSSLINE ; do
	JBLINE=`psql -q \
		      -t \
		      -c \
			   "SELECT lineid
	  		      FROM dblink(fetch_jbilling_conn(),
					  'SELECT line_id
					     FROM prov_line
					    WHERE line_id = $OSSLINE
					      and end_date is null') as rec_type (lineid int)"`
    
    if [[ $JBLINE = "" ]]; then 
		echo "$OSSLINE" >> $ERRFILE
	fi

done
