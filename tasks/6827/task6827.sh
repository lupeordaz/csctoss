#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

#ERRFILE=$BASEDIR/lupe/tasks/6827/logs/oss_info_not_found.`date '+%Y%m%d'`
LOGFILE=$BASEDIR/lupe/tasks/6827/logs/line_esn_log.`date '+%Y%m%d'`

echo "OSS Line Id|ESN Hex" > $LOGFILE

psql -q \
     -t \
     -c "select l.line_id
		   from line l
		  where l.end_date IS null
		  order by 1" \
| while read LINEID ; do
	ESN=`psql -q \
		      -t \
		      -c \
			   "SELECT esn_hex
	  		      FROM dblink(fetch_jbilling_conn(),
					  'SELECT esn_hex
					     FROM prov_line
					    WHERE line_id = $LINEID
					      and end_date is null') as rec_type (esn_hex text)"`
    
	ESN=`echo $ESN | xargs`
	echo "$LINEID|$ESN" >> $LOGFILE
done

