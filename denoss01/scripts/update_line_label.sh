
#!/bin/bash

########################################################################
#                                                                      #
# Script to update line_label in line table                            #
# with ESN HEX value of unique_identifier table                        #
#                                                                      #
########################################################################

# Debug Flag
DEBUG=0

# Readonly Flag
#READONLY=1

# Parameter Validation

if [ $# != 1 ]; then

     echo "Usage : ./update_line_label.sh [line_id]"
     echo ""
     echo "Ex: ./update_line_label 1089"
     echo ""

     exit 1;
fi


LINEID=$1


#
# Retrieve the line_label and ESN HEX Value
#

LINELABEL=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
            -c "SELECT line_label FROM line
                WHERE line_id = ${LINEID}
                AND end_date IS NULL"`

if [ -z "${LINELABEL}" ]; then

    echo "No Matching Line_ID. [Line_ID = ${LINEID}]"
    exit 1;
fi


EQID=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
          -c "SELECT equipment_id FROM line_equipment
              WHERE line_id = ${LINEID}
              AND end_date IS NULL"`

if [ -z "${EQID}" ]; then

   echo "No Matching Equipment_ID."
   exit 1;

fi
ESNHEX=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
         -c "SELECT value FROM unique_identifier
             WHERE equipment_id = ${EQID}
             AND unique_identifier_type = 'ESN HEX'"`

if [ -z "${ESNHEX}" ]; then

  echo "No Matching ESN HEX."
  exit 1;

fi

# Display all the information for the update to be done

if [ ${LINELABEL} == ${ESNHEX} ]; then

   echo ""
   echo " The Line label value matches ESN HEX value. Hence No update needed."
   echo ""
   exit 1;

else

 # Line Label and ESN HEX doesnt match and hence needed to update.

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
      -c "SELECT l.line_id, l.line_label AS current_line_label, lieq.equipment_id, uniq.value AS correct_line_label
          FROM line l
          JOIN line_equipment lieq ON (l.line_id = lieq.line_id)
          JOIN unique_identifier uniq ON (lieq.equipment_id = uniq.equipment_id)
          WHERE l.line_id = ${LINEID}
          AND uniq.unique_identifier_type = 'ESN HEX'"
fi

# Verify if user wants to continue

MOVEON=N

echo "The records will be updated."

while [ $MOVEON = N ]; do

  read -p "1 :  Continue    2 : Cancel -> " CHOICE
  if [ -z "$CHOICE" ]; then

      echo
      echo "Please enter 1 to Continue or 2 to Cancel."
      echo

  elif [ "$CHOICE" = "1" ]; then

        MOVEON=Y; echo

  elif [ "$CHOICE" = "2" ]; then

      echo "The operation has cancelled. Exiting......"
      exit 0;

  fi
done

## Update the line_label in line table

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
   -c "SELECT public.set_change_log_staff_id (3); UPDATE line SET line_label = '${ESNHEX}' WHERE line_id = ${LINEID} AND line_label = '${LINELABEL}'"

echo ""
echo "The line_label is successfully updated."
echo ""

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
  -c "SELECT l.line_id, l.line_label as updated_line_label
      FROM line l
      WHERE l.line_id = ${LINEID}
      AND l.end_date IS NULL"

exit 0;


