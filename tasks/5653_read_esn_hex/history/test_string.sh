#!/bin/bash
#
#set -x
#source /home/postgres/.bash_profile
BASEDIR=/home/gordaz
DATE=`date --date='yesterday' +%Y%m%d`
DATAFILE=$BASEDIR/tasks/5653/data/mac_esn_test.csv

#IFS="|"
#while read EQUIPID MAC ESN MODEL SN
#do
count=0
var='80A45998, A10000157EC0D3'
if [[ $var = *","* ]]; then
  IFS=','
  for esn in $(echo "$var"); do
  	count=`expr $count + 1`
  	if [ $count = 1 ]; then
  		ESN1=`echo "$esn" | xargs`
  	else
  		ESN2=`echo "$esn" | xargs`
  	fi
  done
  echo "ESN1: $ESN1"
  echo "ESN2: $ESN2"
fi
#done < $DATAFILE
