#***************************************************************************
BASEDIR=/home/gordaz
DATADIR=$BASEDIR/data
LOGFILE=$BASEDIR/log/testlog.log

echo '***************************************************************************'
echo `date +%H:%M:%S` 
echo '' 

UTYPE=$1
UVALUE=$2

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
     "SELECT * FROM unique_id($UTYPE,'$UVALUE')")

echo ''
LINEID=`echo $RETVAL | cut -d '|' -f1`
EQUIPID=`echo $RETVAL | cut -d '|' -f2`
USERNAME=`echo $RETVAL | cut -d '|' -f3`
MAC=`echo $RETVAL | cut -d '|' -f4`
SERIALNO=`echo $RETVAL | cut -d '|' -f5`
ESNHEX=`echo $RETVAL | cut -d '|' -f6`
STATUS=`echo $RETVAL | cut -d '|' -f7`

echo 'Line Id     :  ' $LINEID
echo 'Equipment Id:  ' $EQUIPID
echo 'Username    :  ' $USERNAME
echo 'MAC         :  ' $MAC
echo 'Serial No.  :  ' $SERIALNO
echo 'ESN Hex     :  ' $ESNHEX
echo ''
echo 'STATUS      :  ' $STATUS

