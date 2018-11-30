#!/bin/bash
####################################################################
#
# Copy Master Rad Account Data from DENLOG02 to CSCTOSS.
#
#
#               Copyright (C) All Rights Reserved,  2014  CCT Inc,
####################################################################

#
# Define variables.
#
PSQL=/home/postgres/PGSQL/bin/psql
TMPFILE=/tmp/masterrad.csv
OUTFILE=/tmp/out_masterrad.csv

#
# Delete old TMPFILE and OUTFILE.
#
rm -f ${TMPFILE}
rm -f ${OUTFILE}

#
# Retrieve RADIUS account data for past 24 hours from ATLLOG01 database.
#
echo "Starting export....."
PGPASSWORD=owner ${PSQL} -h denlog02 -p 5450 -U csctlog_owner csctlog -A -F, -t -P null='<NULL>' -c "SELECT master_radacctid, source_hostname, radacctid,  acctsessionid,  acctuniqueid,  username,  realm,  nasipaddress,  nasportid,  nasporttype, acctstarttime, acctstoptime, acctsessiontime, acctauthentic, connectinfo_start,  connectinfo_stop,  acctinputoctets,  acctoutputoctets,  calledstationid,  callingstationid, acctterminatecause,  servicetype,framedprotocol,  framedipaddress, acctstartdelay, acctstopdelay, xascendsessionsvrkey, tunnelclientendpoint,  nasidentifier, CLASS,  processed_flag FROM master_radacct master_radacct WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record  FROM master_radacct mrac WHERE acctstarttime > (CURRENT_DATE - '3 months'::INTERVAL)  GROUP BY username )" > ${TMPFILE}
echo "Finished export....."

#
# Import RADIUS data into CSCTOSS database.
#
echo "Starting import....."
echo "BEGIN;" > ${OUTFILE}
echo "DELETE FROM csctoss.master_radacct;" >> ${OUTFILE}
echo "COPY csctoss.master_radacct (master_radacctid, source_hostname, radacctid,  acctsessionid,  acctuniqueid,  username,  realm,  nasipaddress,  nasportid,  nasporttype, acctstarttime, acctstoptime, acctsessiontime, acctauthentic, connectinfo_start,  connectinfo_stop,  acctinputoctets,  acctoutputoctets,  calledstationid,  callingstationid, acctterminatecause,  servicetype,framedprotocol,  framedipaddress, acctstartdelay, acctstopdelay, xascendsessionsvrkey, tunnelclientendpoint,  nasidentifier, CLASS,  processed_flag) FROM stdin WITH DELIMITER ',' NULL '<NULL>';" >> ${OUTFILE}
cat ${TMPFILE} >> ${OUTFILE}
echo "\." >> ${OUTFILE}
echo "COMMIT;" >> ${OUTFILE}

PGPASSWORD=owner ${PSQL} -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner -f ${OUTFILE}
echo "Finished import....."

# Optimize table.
PGPASSWORD=owner ${PSQL} -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner -c "VACUUM ANALYSE csctoss.master_radacct"

echo "Done."

