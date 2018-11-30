#!/bin/bash

# Processing of command line arguments in bash
# "shift" shifts all arguments to the left ($2=$1, $3=$2 etc.)
# "shift" returns non-zero exit-code (indicating "false")
# when no more arguments available.
# (note that $0 will not get "shifted").
#  carrier_def_id |    carrier    
#----------------+---------------
#              1 | USCC
#              2 | SPRINT
#              3 | VZW
#              4 | USCC_SPRINT
#              5 | VZW_WHOLESALE
#              6 | MULTIPLE
#              7 | ROGERS
#              8 | VODAFONE
#
source /home/postgres/.bash_profile
args=$#

if ! [ $args = 3 ]; then

    echo "usage:  $0 [ip range] [carrier] [billing entity id]"
    exit 1

fi

irange=$1
carrier=$2
billing=$3

echo $carrier

if ! [ $carrier -ge 1 ] && [ $carrier -le 8 ]; then
    echo "usage:  $0 [ip range] [carrier] [billing entity id]"
    exit 1
fi

carrier_name=''
case $carrier in
    1) carrier_name='USCC'
       ;;
    2) carrier_name='SPRINT'
       ;;
    3) carrier_name='VZW'
       ;;
    4) carrier_name='USCC_SPRINT'
       ;;
    5) carrier_name='VZW_WHOLESALE'
       ;;
    6) carrier_name='MULTIPLE'
       ;;
    7) carrier_name='ROGERS'
       ;;
    8) carrier_name='VODAFONE'
       ;;
esac

echo "range = $irange"
echo "carrier = $carrier_name"
echo "billing entity id = $billing"

outfile="${carrier_name}_isp.csv"

/home/postgres/dba/scripts/prips_range.sh $irange | egrep -v "*\.0$|*\.255$" > $outfile

cat $outfile | awk '{print "INSERT INTO static_ip_pool (static_ip, groupname, is_assigned, carrier_id, billing_entity_id) VALUES (\x27"$1"\x27, ""\x27""SERVICE-vzwwholesale""\x27"", false, 5, $billing);"}' > 

echo "Processing Done"

