#!/bin/bash
###########################################################################
#This program will create and insert static ip ranges in to the static ip #
# pool table along with groupname and carrier id                          #
#                                                                         #
###########################################################################

IPFILE="/home/postgres/dba/scripts/ip_ranges.csv"

# Debug Flag
DEBUG=0

# Readonly Flag
READONLY=0

# Delete the ip_ranges.csv file at the start of the script
if [ -e $IPFILE ]; then

   rm $IPFILE

fi

# Parameter Validation
if [ $# != 4 ]; then
   echo "Usage: ./insert_static_ip_ranges.sh [GROUPNAME] [Carrier <SPRINT/USCC/VZW>] [IP RANGE] [BILLING ENTITY FOR VERIZON]"
   echo ""
   echo "E.x) ./insert_static_ip_ranges.sh SERVICE-vzw_pool1 VZW 10.81.20.0/22 ACFN "
   echo ""

   exit 1;
fi

read -p "Please enter the ip range to be excluded from static ip pool : " EXCLUDEIPS

VRF=$1
CARRIER=$2
IPRANGE=$3
BENAME=$4

VALUE=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
        -c "SELECT groupname FROM groupname
            WHERE groupname = '$VRF'"`

if [ -z "${VALUE}" ]; then

   echo ""
   echo "No matching Groupname. [VRF = ${VRF}]"
   echo ""

   exit 1;

fi

CARRIER_ID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -U csctoss_owner -A -t \
             -c "SELECT carrier_def_id FROM static_ip_carrier_def
                 WHERE carrier = '$CARRIER'"`

if [ -z "${CARRIER_ID}" ]; then
   echo ""
   echo "Unknown carrier. [CARRIER = ${CARRIER}]"
   echo ""

   exit 1;
fi

CARRIER_ID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -U csctoss_owner -A -t \
             -c "SELECT carrier_def_id FROM static_ip_carrier_def
                 WHERE carrier = '$CARRIER'"`

if [ -z "${CARRIER_ID}" ]; then
   echo ""
   echo "Unknown carrier. [CARRIER = ${CARRIER}]"
   echo ""

   exit 1;

fi

#
#Retrieve Billing Entity ID
#

BEID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
          -c "SELECT billing_entity_id FROM billing_entity
              WHERE name = '${BENAME}'"`

if [ -z "${BEID}" ]; then

   echo ""
   echo "No Matching Billing Entity ID. [BENAME = ${BENAME}]"
   echo ""

   exit 1;

fi

#
# Verify whether user wants to continue
#

MOVEON=N
echo "The ip ranges will be inserted."
while [ $MOVEON = N ]; do
    read -p "1 : Continue    2 : Cancel -> " CHOICE
    if [ -z "$CHOICE" ]; then
        echo
        echo "Please enter 1 to Continue or 2 to Cancel."
        echo
    elif [ "$CHOICE" = "1" ]; then
        MOVEON=Y; echo
 elif [ "$CHOICE" = "2" ]; then
        echo "The operation has cancelled. Exiting....."
        exit 0;
    fi
done


#
# If this is readonly more, return back to shell.
#
if [ ${READONLY} -eq 1 ]; then
    echo "This is readonly mode. Exiting....."
    exit 0;
fi

#
# Generate the ip ranges provided
#

/usr/local/src/prips-0.9.7/prips $IPRANGE >> ip_ranges.csv

#Copying the ip_ranges generated to ip_ranges table
psql csctoss -c "\copy ip_ranges from '/home/postgres/dba/scripts/ip_ranges.csv' csv"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
            -c "SELECT public.set_change_log_staff_id(251); DELETE FROM ip_ranges WHERE ip LIKE '%.0'; DELETE FROM ip_ranges WHERE ip LIKE '%.255'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
            -c "DELETE FROM ip_ranges WHERE ip LIKE '${EXCLUDEIPS}'"			

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
            -c "SELECT public.set_change_log_staff_id(251); SELECT * FROM test_insert_static_ip_ranges('$VRF', '$CARRIER', $BEID)"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
            -c "SELECT public.set_change_log_staff_id(251); DELETE FROM ip_ranges"

echo ""
echo "The ip ranges have been inserted successfully.";
echo ""



