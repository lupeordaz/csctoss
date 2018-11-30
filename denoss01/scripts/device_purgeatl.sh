#!/bin/bash
#################################################################################
#
# Program : device_purge.sh
#
# This program will purge a given device info and associated username info.
#
#
#                            Copyright (C) All Rights Reserved,  2012  CCT Inc.
#################################################################################

# Debug Flag
DEBUG=0
#DEBUG=1

# Readonly Flag
READONLY=0
#READONLY=1


# Parameter validation
if [ $# != 2 ]; then
    echo "Usage: ./device_purge.sh [ESN HEX] [Carrier <SPRINT/USCC/VERIZON>]"
    echo ""
    echo "E.x) ./device_purge.sh A000001F54D5CD SPRINT"
    echo ""

    exit 1;
fi


ESNHEX=$1
CARRIER=$2


#
# Retrieve EquipmentID
#
EQID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
         -c "SELECT equipment_id FROM unique_identifier
             WHERE value = '${ESNHEX}'
             AND unique_identifier_type = 'ESN HEX'"`

if [ -z "${EQID}" ]; then
    echo "No matching ESN.  [ESN HEX = ${ESNHEX}]"
    exit 1;
fi


#
# Checks Carrier Name
#
if [ "${CARRIER}" = "SPRINT" ]; then
    USERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
                 -c "SELECT value FROM unique_identifier WHERE equipment_id = (
                         SELECT equipment_id FROM unique_identifier
                         WHERE value = '${ESNHEX}')
                     AND unique_identifier_type = 'MDN'"`

elif [ "${CARRIER}" = "USCC" ]; then
    USERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
                 -c "SELECT value FROM unique_identifier WHERE equipment_id = (
                         SELECT equipment_id FROM unique_identifier
                         WHERE value = '${ESNHEX}')
                     AND unique_identifier_type = 'MIN'"`

elif [ "${CARRIER}" = "VERIZON" ]; then
    USERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
                 -c "SELECT value FROM unique_identifier WHERE equipment_id = (
                         SELECT equipment_id FROM unique_identifier
                         WHERE value = '${ESNHEX}')
                     AND unique_identifier_type = 'MIN'"`

else
    echo "Unknown carrier. Exiting....."
    exit 1;
fi

echo "USERNAME : $USERNAME"


#
# Display device information. (ESN / SERIAL / MDN / MIN / MAC)
#
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT equipment_id, unique_identifier_type, value, notes, date_created, date_modified
        FROM unique_identifier WHERE equipment_id = (
            SELECT equipment_id FROM unique_identifier
            WHERE value = '${ESNHEX}'
        ORDER BY unique_identifier_type)"

# username table
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT * FROM username WHERE username LIKE '${USERNAME}@%'"

# usergroup table
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT * FROM usergroup WHERE username LIKE '${USERNAME}@%'"

# radcheck table
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT * FROM radcheck WHERE username LIKE '${USERNAME}@%'"

# radreply table
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT * FROM radreply WHERE username LIKE '${USERNAME}@%'"

# line table
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT be.billing_entity_id, be.name, line.line_id, line.line_assignment_type,
               line.start_date, line.end_date, line.date_created, line.radius_username, line.notes
        FROM line LEFT OUTER JOIN billing_entity be ON (line.billing_entity_id = be.billing_entity_id)
        WHERE radius_username LIKE '${USERNAME}@%'"


#
# Verify user wants to continue
#
MOVEON=N
echo "The records will be deleted."
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
# Delete records.
#
PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); DELETE FROM radreply WHERE username LIKE '${USERNAME}@%'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); DELETE FROM radcheck WHERE username LIKE '${USERNAME}@%'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); DELETE FROM usergroup WHERE username LIKE '${USERNAME}@%'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); UPDATE line SET radius_username = NULL WHERE radius_username LIKE '${USERNAME}@%'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); DELETE FROM username WHERE username LIKE '${USERNAME}@%'"

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
    -c "SELECT public.set_change_log_staff_id(251); DELETE FROM unique_identifier WHERE equipment_id = ${EQID}"


echo ""
echo "The operation has completed."
echo ""

exit 0
