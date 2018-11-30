
#!/bin/bash

########################################################################
#                                                                      #
# Script to update the groupname values on                             #
# usergroup table for Verzion Lines to Service_vzw_pool1/2             #
#                                                                      #
########################################################################


echo "Script to update the groupname for Verizon Lines."
echo ""
echo ""

# Verify if user wants to continue

#MOVEON=N

echo "The records will be updated."

# Call the function for the necessary changes to be done.

PGPASSWORD=owner psql -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner \
   -c "SELECT * FROM update_groupname_verizon_lines()"

echo ""
echo "The changes are done the usergroup table."
echo ""

exit 0;


