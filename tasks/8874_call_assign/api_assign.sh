#***************************************************************************
WORK_DATE=`date +%Y-%m-%d`
BASEDIR=/home/gordaz
DATADIR=$BASEDIR/data
LOGFILE=$BASEDIR/log/apiassign.`date '+%Y%m%d'`

echo '***************************************************************************' > $LOGFILE
echo `date +%H:%M:%S`  >> $LOGFILE
echo ''  >> $LOGFILE

ESNHEX=$1
SLSORD=$2
BEID=$3
GRPNAME=$4
STATBOOL=$5
PRODID=$6
BYPASSJB=$7

# Retrieve values from function
read RETVAL <<< $(psql -q \
	 -h testoss01.cctus.com \
	 -d csctoss \
	 -p 5450 \
	 -U csctoss_owner \
	 -t \
	 --no-align \
	 --field-separator '|' \
     -c \
     "SELECT * FROM csctoss.ops_api_assign('$ESNHEX','$SLSORD',$BEID,'$GRPNAME',$STATBOOL,'$PRODID',TRUE)") >> $LOGFILE

echo ''  >> $LOGFILE

RSLTCD=`echo $RETVAL | cut -d '|' -f1`
MSG=`echo $RETVAL | cut -d '|' -f2`

echo 'Status      :  ' $MSG >> $LOGFILE
echo '***************************************************************************' >> $LOGFILE

echo 'Status      :  ' $MSG
