#!/bin/bash
#
#set -x
source /home/gordaz/.bash_profile


BASEDIR=/home/gordaz/tasks/9215_update_locations_labels
DATE=`date --date='yesterday' +%Y%m%d`

if [[ -n "$1" ]]; then
    INFILE=$BASEDIR/$1
else
	echo "Supply an input file..."
	exit 1
fi
LOGFILE=$BASEDIR/logs/9215.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" > $LOGFILE
echo "" >>$LOGFILE
#echo "Line Id|OWNER|ID|NAME|Address|Processor|Firmw Ver" >> $LOGFILE

linehead="UPDATE location_labels SET "
wherelin=" where line_id = $LINEID;"
conma=","

IFS="|"
while read BEID BENAME LINEID OWNER ID NAME ADDRESS PROCSSOR FWVER
do
	SETLINE=""
	SETLINE="UPDATE location_labels SET "

	if [ "$OWNER" != "" ]; then
		SETLINE+="owner =  '$OWNER'"
		varcnt+=1
	fi

	if [ "$ID" != "" ]; then
		if [ "$varcnt" > 0 ]; then
			SETLINE+="$conma"
		fi
		SETLINE+=" id = '$ID'"
		varcnt+=1
	fi

	if [ "$NAME" != " " ]; then
		if [ "$varcnt" > 0 ]; then
			SETLINE+="$conma"
		fi
		SETLINE+=" name = '$NAME'"
		varcnt+=1
	fi

	if [ "$ADDRESS" != "" ]; then
		if [ "$varcnt" > 0 ]; then
			SETLINE+="$conma"
		fi
		SETLINE+=" address = '$ADDRESS'"
		varcnt+=1
	fi

	if [ "$PROCESSOR" != "" ]; then
		if [ "$varcnt" > 0 ]; then
			SETLINE+="$conma"
		fi
		SETLINE+=" processor = '$PROCESSOR'"
		varcnt+=1
	fi

	if [ "$FWVER" != "" ]; then
		if [ "$varcnt" > 0 ]; then
			SETLINE+="$conma"
		fi
		SETLINE+=" fwver = '$FWVER'"
	fi

	SETLINE+=" where line_id = $LINEID;"

	echo $SETLINE >> $LOGFILE

#    ESNCNT=`psql -q -t -c $SETLINE`

done < $INFILE
