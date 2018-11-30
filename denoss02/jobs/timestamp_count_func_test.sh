#!/bin/bash

#timestamp_func.lib

BASEDIR=/home/postgres/dba/jobs
CURR_DATE=`date +%Y%m%d`
TIMESTAMPFILE=$BASEDIR/`basename $0 .sh`.timestamp
COUNTFILE=$BASEDIR/`basename $0 .sh`.count
LOGFILE2=$BASEDIR/`basename $0 .sh`.log
#MAXSECONDSSINCELASTSUCCESS=300
MAXSECONDSSINCELASTSUCCESS=5
MAXRETRIES=5
T_RETURN=false
C_RETURN=false
#sendEmail=false

function timestamp()
{

  CURRENTDATE=`date`
  CURRENT_TIMESTAMP="`date +%Y-%m-%d` `date +%H:%M:%S`"
  
  if [ -s ${TIMESTAMPFILE} ];then
    OLD_TIMESTAMP=$(<$TIMESTAMPFILE)
    SECDIFF=$(( $(date -d "$CURRENT_TIMESTAMP" +%s) - $(date -d "$OLD_TIMESTAMP" +%s) ))
    PRINTDIFFTS=$(date -u -d @$SECDIFF +%T)

    if [ $SECDIFF -ge $MAXSECONDSSINCELASTSUCCESS ];then
      #echo "WARNING : $PRINTDIFFTS since last successful run"         >>$LOGFILE2
      T_RETURN="true"
    fi
  fi
  echo "$CURRENT_TIMESTAMP"                      > $TIMESTAMPFILE
}

function count()
{
  if [ -f ${COUNTFILE} ];then
    CURRENT_COUNT=$(<$COUNTFILE)
    if [ $CURRENT_COUNT -ge $MAXRETRIES ];then
      C_RETURN="true"
      echo 1 > $COUNTFILE
    else
      NEWCOUNT=`expr $CURRENT_COUNT + 1`
      echo "$NEWCOUNT"                              >$COUNTFILE
    fi
  else
      NEWCOUNT=1
      echo "$NEWCOUNT"                              >$COUNTFILE
  fi
}
