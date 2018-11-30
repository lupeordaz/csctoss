#!/bin/bash
#
#set -x
#source /home/gordaz/.bash_profile

BASEDIR=/home/gordaz/tasks/9215_update_locations_labels
DATE=`date --date='yesterday' +%Y%m%d`

if [[ -n "$1" ]]; then
    INFILE=$BASEDIR/$1
else
	echo "Supply an input file..."
	exit 1
fi

if [[ -n "$2" ]]; then
    CONNSTRG=$2
    echo $CONNSTRG
else
	echo "Enter connection string..."
	exit 1
fi

LOGFILE=$BASEDIR/logs/9215.`date '+%Y%m%d'`

echo "START TIMESTAMP: `date '+%Y%m%d%H%M%S'`" >> $LOGFILE
echo "" >> $LOGFILE
#echo "Line Id|OWNER|ID|NAME|Address|Processor|Firmw Ver" >> $LOGFILE

conma=","

IFS="|"
while read BEID BENAME LINEID OWNER ID NAME ADDRESS PROCSSOR FWVER
do
	x=0
	varcnt=0
	SETLINE=""
	SETLINE="UPDATE location_labels SET "

	if [ "$OWNER" != "" ]; then
		SETLINE+="owner =  '$OWNER'"
		varcnt=$[varcnt + 1]
	fi
	
	if [ "$ID" != "" ]; then
		if [ $varcnt = 0 ]; then
			SETLINE+=" id = '$ID'"
			varcnt=$[varcnt + 1]
		else
			SETLINE+="$conma"
			SETLINE+=" id = '$ID'"
			varcnt=$[varcnt + 1]
		fi
	fi

	if [ "$NAME" != " " ]; then
		if [ $varcnt = 0 ]; then
			SETLINE+=" name = '$NAME'"
			varcnt=$[varcnt + 1]
		else
			SETLINE+="$conma"
			SETLINE+=" name = '$NAME'"
			varcnt=$[varcnt + 1]
		fi
	fi
	
	if [ "$ADDRESS" != "" ]; then
		if [ $varcnt = 0 ]; then
			SETLINE+=" address = '$ADDRESS'"
			varcnt=$[varcnt + 1]
		else
			SETLINE+="$conma"
			SETLINE+=" address = '$ADDRESS'"
			varcnt=$[varcnt + 1]
		fi
	fi
	
	if [ "$PROCESSOR" != "" ]; then
		if [ $varcnt = 0 ]; then
			SETLINE+=" processor = '$PROCESSOR'"
			varcnt=$[varcnt + 1]
		else
			SETLINE+="$conma"
			SETLINE+=" processor = '$PROCESSOR'"
			varcnt=$[varcnt + 1]
		fi
	fi
	
	if [ "$FWVER" != "" ]; then
		if [ $varcnt = 0 ]; then
			SETLINE+=" fwver = '$FWVER'"
		else
			SETLINE+="$conma"
			SETLINE+=" fwver = '$FWVER'"
		fi
	fi

	SETLINE+=" where line_id = $LINEID;"

#    UPDCNT=`PGPASSWORD=owner psql -h testoss01.cctus.com -p 5450 -d csctoss -U csctoss_owner -c $SETLINE`
    UPDCNT=`PGPASSWORD=owner psql -h $CONNSTRG -p 5450 -d csctoss -U csctoss_owner -c $SETLINE`

	echo $UPDCNT
    
done < $INFILE
