#!/bin/bash
###########################################################################
#                                                                         #
# This program will create manually a new line for the provided details.  #
#                                                                         #
###########################################################################

# Debug Flag
DEBUG=0

# Readonly Flag
READONLY=0

# Parameter Validation
if [ $# != 5 ]; then
   echo "Usage: ./manual_line_creation.sh [ESN HEX] [SALES ORDER] [BILLING ENTITY] [GROUPNAME/VRF] [STATIC IP <FALSE>]"
   echo ""
   echo "Ex: ./manual_line_creation.sh A000001F54D5CD SO-8867 ACFN SERVICE-acfn FALSE"
   echo ""

   exit 1;
fi

ESNHEX=$1
SALESORDER=$2
BENAME=$3
VRF=$4
SIP=$5

#
# Validate Input parameters if they exists
#
EQID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
        -c "SELECT equipment_id FROM unique_identifier
            WHERE value = '${ESNHEX}'
            AND unique_identifier_type = 'ESN HEX'"`

if [ -z "${EQID}" ]; then

   echo ""
   echo "No Matching ESN. [ESN HEX = ${ESNHEX}]"
   echo ""

   exit 1;

fi

#
#Check if the carrier is USCC
#

MIN=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
        -c "SELECT value FROM unique_identifier
            WHERE equipment_id = '${EQID}'
            AND unique_identifier_type = 'MIN'"`


USERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
        -c "SELECT username FROM username
            WHERE SUBSTR(username,1,10) = '${MIN}'"`

CARRIER=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
           -c "SELECT upper(substring(username from 12 for 4))
              FROM username
              WHERE username = '${USERNAME}'"`

# if carrier is not USCC then exit

if [ "${CARRIER}" != "USCC" ]; then

    echo ""
    echo "Not a USCC carrier so exiting the script......"
    echo ""
    exit 1;
fi

#
#Retrieve Billing Entity ID
#

BEID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
          -c "SELECT billing_entity_id FROM billing_entity
              WHERE name  = '${BENAME}'"`

if [ -z "${BEID}" ]; then

   echo ""
   echo "No Matching Billing Entity ID. [BENAME = ${BENAME}]"
   echo ""

   exit 1;

fi

VALUE=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
         -c "SELECT groupname FROM groupname
             WHERE groupname = '${VRF}'"`

if [ -z "${VALUE}" ]; then

   echo ""
   echo "No matching Groupname. [VRF = ${VRF}]"
   echo ""

   exit 1;

fi

#
# Verify whether user wants to continue
#

MOVEON=N
echo "The line will be created."
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
# Manaully create the line using ops_assign_function for uscc
#

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
            -c "SELECT public.set_change_log_staff_id(251); SELECT * FROM ops_api_assign_uscc('$ESNHEX', '$SALESORDER', $BEID, '$VRF', '$SIP')"

echo ""
echo "The line has been created manually for USCC device.";
echo ""


