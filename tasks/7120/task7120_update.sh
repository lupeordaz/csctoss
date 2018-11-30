#!/bin/bash
#
#set -x

BASEDIR=/home/postgres
DATE=`date --date='yesterday' +%Y%m%d`

SQLFILE=$BASEDIR/lupe/tasks/7120/task7120.sql

#echo "BEGIN" > $SQLFILE
#echo "select public.set_change_log_staff_id(3);" >> $SQLFILE

UPDCMD="UPDATE username"
SETCMD="   SET billing_entity_id = "
WHRCMD=" WHERE username = "
COMM="COMMIT;"

LINECNT=0

psql -q \
     -t \
     -A \
     -F ' ' \
     -c "select l.line_id
		       ,l.billing_entity_id as line_billilng_entity
		       ,u.username
		       ,u.billing_entity_id as user_billing_entity_id
		   from line l
		   join username u on u.username = l.radius_username
		  where l.end_date is null
		    and l.billing_entity_id <> u.billing_entity_id
		  order by 1" \
| while read LINEID LINEBILLID USERNAME USERBILLID ; do
    if [[ $LINEID -ne "" ]]; then

	echo $UPDCMD $SETCMD $LINEBILLID $WHRCMD "'"$USERNAME"'" ";" >> $SQLFILE

    fi
done

#echo $COMM >> $SQLFILE
echo "Finished!"
