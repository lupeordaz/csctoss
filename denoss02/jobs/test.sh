
#!/bin/bash

# simple example script that takes timestamp and count functions from seperate file and then determine wether to send email


CURR_DATE=`date +%Y%m%d`
LOGFILE=/root/logs/benstest.$CURR_DATE.log
BASEDIR=/home/postgres/dba/jobs



. /$BASEDIR/timestamp_count_func_test.sh
#. /$BASEDIR/timestamp_count_func.20130605.sh


#call timestamp function
timestamp
echo "inside timestamp"
if [ $T_RETURN == "true" ];
then
        echo "Timestamp function has returned true value. Send email"
else
        echo "Timestamp function DID NOT return true value. Dont send email."
fi



#call count function
count
echo "inside count"
if [ $C_RETURN == "true" ];
then
        echo "Count function has returned true value. Send email"
else
        echo "Count function DID NOT return true value. Dont send email"
fi

