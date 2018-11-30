#!/bin/bash
####################################################################
#
# Copy Master Rad Account Data from ATLLOG01 to CSCTOSS.
#
#
#               Copyright (C) All Rights Reserved,  2014  CCT Inc,
####################################################################

#
# Define variables.
#
TMPFILE=/tmp/masterrad.csv
OUTFILE=/tmp/out_masterrad.csv


#
# Delete old TMPFILE and OUTFILE.
#
rm -f ${TMPFILE}
rm -f ${OUTFILE}

PGPASSWORD=owner psql -h denlog02 -p 5450 -U csctlog_owner csctlog <<SQL 
\copy (SELECT master_radacctid, source_hostname, radacctid,  acctsessionid,  acctuniqueid,  username,  realm,  nasipaddress,  nasportid,  nasporttype, acctstarttime, 
acctstoptime, acctsessiontime, acctauthentic, connectinfo_start,  connectinfo_stop,  acctinputoctets,  acctoutputoctets,  calledstationid,  callingstationid, 
acctterminatecause,servicetype,framedprotocol,  framedipaddress, acctstartdelay, acctstopdelay, xascendsessionsvrkey, tunnelclientendpoint,  nasidentifier, CLASS,  
processed_flag FROM master_radacct master_radacct WHERE master_radacctid IN (  SELECT max(master_radacctid) AS record  FROM master_radacct mrac WHERE acctstarttime > 
(CURRENT_DATE - 1)  GROUP BY username )) TO '${TMPFILE}' WITH CSV NULL '\N' 
SQL

#
# Import RADIUS data into CSCTOSS database.
#
echo "TRUNCATE TABLE csctoss.master_radacct;" > ${OUTFILE}
echo "COPY csctoss.master_radacct (master_radacctid, source_hostname, radacctid,  acctsessionid,  acctuniqueid,  username,  realm,  nasipaddress,  nasportid,  nasporttype, acctstarttime, acctstoptime, acctsessiontime, acctauthentic, connectinfo_start,  connectinfo_stop,  acctinputoctets,  acctoutputoctets,  calledstationid,  callingstationid, acctterminatecause,  servicetype,framedprotocol,  framedipaddress, acctstartdelay, acctstopdelay, xascendsessionsvrkey, tunnelclientendpoint,  nasidentifier, CLASS,  processed_flag) FROM stdin WITH DELIMITER ',' NULL '\N';" >> ${OUTFILE}
cat ${TMPFILE} >> ${OUTFILE}
echo "\." >> ${OUTFILE}

PGPASSWORD=owner psql -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner -f ${OUTFILE}


PGPASSWORD=owner psql -h 127.0.0.1 -p 5450 -d csctoss -U csctoss_owner -c "VACUUM ANALYSE csctoss.master_radacct"


echo "Done."


