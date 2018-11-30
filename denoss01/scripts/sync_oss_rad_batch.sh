#!/bin/bash
################################################################################
#
# Program : sync_oss_rad.sh
#
# Summary : Synchronize important data between OSS and RadiusDB.
#           This is one way copy script from OSS to RadiusDB. The script
#           copies the following table data in a single transaction.
#           - groupname
#           - radgroupcheck
#           - radgroupreply
#           - username
#           - usergroup
#           - radcheck
#           - radreply
#
# Revision : Created at 2013/10/29
#
#                           Copyright (C) All Rights Reserved,  CCT Inc,  2013
################################################################################

# Debug Flag
DEBUG=0
#DEBUG=1

# Define variables
DUMPDIR=/home/postgres/dba/scripts/radiusdb_refresh_data_`date '+%Y%m%d'`


# Parameter validation
if [ $# != 1 ]; then
    echo "Usage: ./sync_oss_rad.sh [RadiusDB Name]"
    echo ""
    echo "E.x) ./sync_oss_rad.sh denrad12"
    echo ""

    exit 1;
fi

RADIUSDB=$1


#-------------------------------------------------
# Starting synchronization process.
#-------------------------------------------------
cat <<EOD
******************************************************
*                                                    *
*     Starting replication from OSS to RadiusDB.     *
*                                                    *
******************************************************

Please make sure you have turned off the radius_updater cron job.
If not, please turn it off.

Target RadiusDB = ${RADIUSDB}

EOD


#
# Verify user wants to continue
#
#MOVEON=N
#echo "This script will synchronize data from OSS to RadiusDB [${RADIUSDB}]."
#while [ $MOVEON = N ]; do
#    read -p "1 : Continue    2 : Cancel -> " CHOICE
#    if [ -z "$CHOICE" ]; then
#        echo
#        echo "Please enter 1 to Continue or 2 to Cancel."
#        echo
#    elif [ "$CHOICE" = "1" ]; then
#        MOVEON=Y; echo
#    elif [ "$CHOICE" = "2" ]; then
#        echo "The operation has cancelled. Exiting....."
#        exit 0;
#    fi
#done


# Gathering necessary table data from OSS.
echo "Gathering the latest data from OSS....."
mkdir -p ${DUMPDIR}

LANG=C pg_dump -a -t groupname     > ${DUMPDIR}/radiusdb_refresh_data_groupname.dmp     &&
LANG=C pg_dump -a -t username      > ${DUMPDIR}/radiusdb_refresh_data_username.dmp      &&
LANG=C pg_dump -a -t usergroup     > ${DUMPDIR}/radiusdb_refresh_data_usergroup.dmp     &&
LANG=C pg_dump -a -t radcheck      > ${DUMPDIR}/radiusdb_refresh_data_radcheck.dmp      &&
LANG=C pg_dump -a -t radreply      > ${DUMPDIR}/radiusdb_refresh_data_radreply.dmp      &&
LANG=C pg_dump -a -t radgroupcheck > ${DUMPDIR}/radiusdb_refresh_data_radgroupcheck.dmp &&
LANG=C pg_dump -a -t radgroupreply > ${DUMPDIR}/radiusdb_refresh_data_radgroupreply.dmp


echo "Converting data for RadiusDB....."
/usr/bin/perl -pi -e 's/SET search_path = csctoss, pg_catalog;/SET search_path = radiusdb, pg_catalog;/' ${DUMPDIR}/radiusdb_refresh_data_*.dmp


echo "Preparing synchronization....."
cat <<EOD > ${DUMPDIR}/sync.sql
SELECT (SELECT count(*) FROM groupname) AS groupname, (SELECT count(*) FROM username) AS username, (SELECT count(*) FROM usergroup) AS usergroup, (SELECT count(*) FROM radcheck) AS radcheck, (SELECT count(*) FROM radreply) AS radreply, (SELECT count(*) FROM radgroupcheck) AS radgroupcheck, (SELECT count(*) FROM radgroupreply) AS radgroupreply;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

DELETE FROM radiusdb.radcheck;
DELETE FROM radiusdb.radreply;
DELETE FROM radiusdb.usergroup;
DELETE FROM radiusdb.username;
DELETE FROM radiusdb.radgroupcheck;
DELETE FROM radiusdb.radgroupreply;
DELETE FROM radiusdb.groupname;

\i ${DUMPDIR}/radiusdb_refresh_data_groupname.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_radgroupcheck.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_radgroupreply.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_username.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_usergroup.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_radcheck.dmp
\i ${DUMPDIR}/radiusdb_refresh_data_radreply.dmp

SELECT (SELECT count(*) FROM groupname) AS groupname, (SELECT count(*) FROM username) AS username, (SELECT count(*) FROM usergroup) AS usergroup, (SELECT count(*) FROM radcheck) AS radcheck, (SELECT count(*) FROM radreply) AS radreply, (SELECT count(*) FROM radgroupcheck) AS radgroupcheck, (SELECT count(*) FROM radgroupreply) AS radgroupreply;

COMMIT;

VACUUM ANALYZE radiusdb.radcheck;
VACUUM ANALYZE radiusdb.radreply;
VACUUM ANALYZE radiusdb.usergroup;
VACUUM ANALYZE radiusdb.username;
VACUUM ANALYZE radiusdb.groupname;
VACUUM ANALYZE radiusdb.radgroupcheck;
VACUUM ANALYZE radiusdb.radgroupreply;
EOD

echo "Running synchronization process against ${RADIUSDB}....."
PGPASSWORD=owner psql -h ${RADIUSDB} -p 5450 -d radiusdb -U radiusdb_owner -f ${DUMPDIR}/sync.sql

# Cleanup temporary directory.
rm -rf ${DUMPDIR}

echo ""
echo "Synchronization has completed."
echo ""

