#!/bin/bash
#
#set -x

LINEID="47175"
OWNER=""
ID=""
NAME="TBD"
ADDRESS=""
PROCESSOR=""
FWVER="Managed"

conma=","
linehead="UPDATE location_labels SET "

chgowner="owner =  $OWNER"
chgid="id = $ID"
chgname=" name = $NAME"
chgaddr="address = $ADDRESS"
chgproc="processor = $PROCESSOR"
chgfwver="fwver = $FWVER "
wherelin=" where line_id = $LINEID;"
varcnt=0

SETLINE=$linehead

if [ "$OWNER" != "" ]; then
	SETLINE+="owner =  '$OWNER'"
	varcnt+=1
fi

if [ "$ID" != "" ]; then
	if [ "$varcnt" > 0 ]; then
		SETLINE+="$conma"
	fi
	SETLINE+="id = '$ID'"
	varcnt+=1
fi

echo $SETLINE
echo $varcnt

if [ "$NAME" != " " ]; then
	if [ "$varcnt" -gt 0 ]; then
		echo "Why am I here?  varcht: " $varcnt
		SETLINE+="$conma"
	fi
	SETLINE+="name = '$NAME'"
	varcnt+=1
fi

if [ "$ADDRESS" != "" ]; then
	if [ "$varcnt" > 0 ]; then
		SETLINE+="$conma"
	fi
	SETLINE+="address = '$ADDRESS'"
	varcnt+=1
fi

if [ "$PROCESSOR" != "" ]; then
	if [ "$varcnt" > 0 ]; then
		SETLINE+="$conma"
	fi
	SETLINE+="processor = '$PROCESSOR'"
	varcnt+=1
fi

if [ "$FWVER" != "" ]; then
	if [ "$varcnt" > 0 ]; then
		SETLINE+="$conma"
	fi
	SETLINE+="fwver = '$FWVER' "
fi

SETLINE="$SETLINE $wherelin"

echo $SETLINE