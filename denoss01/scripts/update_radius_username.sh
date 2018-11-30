#!/bin/bash

########################################################################
#                                                                      #
# Script to update radius_username in line table                       #
# with username of username table                                      #
#                                                                      #
########################################################################

# Debug Flag
DEBUG=0

# Parameter Validation

if [ $# != 1 ]; then

     echo "Usage : ./update_radius_username.sh [line_id]"
     echo ""
     echo "Ex: ./update_radius_username.sh 1089"
     echo ""

     exit 1;
fi


LINEID=$1


#
# Retrieve the line_label and ESN HEX Value
#

RADUSERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
            -c "SELECT radius_username FROM line
                WHERE line_id = ${LINEID}
                AND end_date IS NULL"`

if [ -z "${RADUSERNAME}" ]; then

    echo "No Matching Line ID. [Line_ID = ${LINEID}]"
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

USERNAME=`PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner -A -t \
         -c "SELECT usr.username FROM username usr
             JOIN unique_identifier uniq ON ((SUBSTR(usr.username,1,10)) LIKE (uniq.value))
             WHERE uniq.equipment_id = ${EQID}
             AND uniq.unique_identifier_type IN ('MDN', 'MIN')
             AND usr.end_date = '2999-12-31'::date LIMIT 1"`

if [ -z "${USERNAME}" ]; then

  echo "No Matching Username."
  exit 1;

fi

# Display all the information for the update to be done

if [ ${RADUSERNAME} == ${USERNAME} ]; then

   echo ""
   echo " The Radius Username value matches Username value. Hence No update needed."
   echo ""
   exit 1;

else

 # Radius Username and Username doesnt match and hence needed to update.

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
      -c "SELECT l.line_id, l.radius_username AS current_username, lieq.equipment_id, usr.username AS correct_username
          FROM line l
          JOIN line_equipment lieq ON (l.line_id = lieq.line_id)
          JOIN unique_identifier uniq ON (lieq.equipment_id = uniq.equipment_id)
          JOIN username usr ON ((SUBSTR(usr.username,1,10)) LIKE (uniq.value))
          WHERE l.line_id = ${LINEID}
          AND uniq.unique_identifier_type IN ('MDN', 'MIN')
          AND lieq.end_date IS NULL
          AND lieq.equipment_id = ${EQID}
          AND usr.end_date = '2999-12-31'::date LIMIT 1"

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
   -c "SELECT public.set_change_log_staff_id (3); UPDATE line SET radius_username = '${USERNAME}' WHERE line_id = ${LINEID} AND radius_username = '${RADUSERNAME}'"

echo ""
echo "The radius username is successfully updated."
echo ""

PGPASSWORD=owner psql -h atloss01 -p 5450 -d csctoss -U csctoss_owner \
  -c "SELECT l.line_id, l.radius_username AS updated_radius_username
      FROM line l
      WHERE l.line_id = ${LINEID}
      AND l.end_date IS NULL"

 echo ""
 echo "Exiting.............."
 echo ""

exit 0;


