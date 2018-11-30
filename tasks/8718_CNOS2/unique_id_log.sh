#***************************************************************************
BASEDIR=/home/gordaz
DATADIR=$BASEDIR/data
LOGFILE=$BASEDIR/log/testlog.log

echo '***************************************************************************' > $LOGFILE
echo `date +%H:%M:%S` >> $LOGFILE
echo '' >>$LOGFILE

echo 'Start'
UTYPE=$1
echo $UTYPE
UVALUE=$2
echo $UVALUE

# Retrieve values from function
psql -q \
	 -h testoss01.cctus.com \
	 -d csctoss \
	 -p 5450 \
	 -U csctoss_owner \
     -c \
     "SELECT * FROM unique_id($UTYPE,'$UVALUE');" >> $LOGFILE

echo 'End Process.' >> $LOGFILE
