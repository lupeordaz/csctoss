#!/bin/bash -x

#######
# Variables
#######

COMPAREDIR=/opt/sdm/comparefiles
LIST=`ls $COMPAREDIR`

INFILE=$1

#Read file from command line
[ ! -f $INFILE ] && { echo "$INFILE file not found" ; exit 99; }

DATE=`date`

MAC=${INFILE:6:6}

 #tr -cd '\11\12\15\40-\176' < $INFILE | grep -v admin | grep -v REACTIVATE | sed '1d' | tr -d '[:space:]'  > $INFILE.compare
 tr -cd '\11\12\15\40-\176' < $INFILE | grep -v admin | grep -v REACTIVATE | sed '1d'  > $INFILE.compare


 # Get the infile from iNotify
 # Do a for loop against the comparefiles directory
 # Compare each file by diff and look at the output of diff.

 for f in $LIST ; do
  CMDRETURN=`diff -B $COMPAREDIR/$f $INFILE.compare`
  RESULT=$?
  if [ $RESULT -eq 0 ]
  then
    FILEMATCH=$f
    echo "MATCH,$MAC,$f"
    curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"message":"MATCH","mac":"'"$MAC"'","configName":"'"$f"'"}' http://10.17.72.21:12000/configInfo
    break
  fi
 done

 if [ ! -n "$FILEMATCH" ]
 then
   BASED=`grep -i CONTOUR_VERSION $INFILE.compare | grep -v "CONTOUR_VERSION{TLS1.2}"`

   OUTPUT=`echo $BASED | tr -dc '[:alnum:]\n\r'`
   if [ ! -n "$OUTPUT" ]
   then
    OUTPUT=UNKNOWN
   fi
   echo "WARN,$MAC,$OUTPUT"
   curl -i -H "Accept: application/json" -H "Content-Type: application/json" -X POST -d '{"message":"WARN","mac":"'"$MAC"'","configName":"'"$OUTPUT"'"}' http://10.17.72.21:12000/configInfo
 fi
