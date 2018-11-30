#!/bin/bash

########################################################################
#                                                                      #
# Script to update the attribute values on                             #
# radcheck table from ClearText-Password to Auth-Type                  #
#                                                                      #
########################################################################


echo "Script to insert/delete data in radcheck table for Verizon Lines."
echo ""

# Verify if user wants to continue

#MOVEON=N

# Call the function for the necessary changes to be done.

PGPASSWORD=owner psql -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner \
   -c "SELECT * FROM update_radcheck_verizon_lines()"

echo ""
echo "The changes are done on radcheck table for verizon lines."
echo ""

exit 0;

