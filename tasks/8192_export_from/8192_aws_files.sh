#!/bin/bash

source /home/gordaz/.bash_profile

BASEDIR=/home/gordaz
DATE=`date +%Y%m%d`

#DATADIR=$BASEDIR/data/
#SNFIXFILE=$BASEDIR/tasks/5653/logs/oss_fix_data.`date '+%Y%m%d'`
#NASDIR=$BASEDIR/mnt/public/linelog_201808/
#LOGFILE=$BASEDIR/log/aws_log.`date '+%Y%m%d'`

#cat <<- EOS
#/***************************************************************************/
#[`date +%H:%M:%S`]
#Start processing linelog_20180808.....
#
#EOS
#
#echo 
#echo "processing linelog_20180808"
#
#PGPASSWORD=qzvuuuv7 /usr/bin/psql -q \
#                                  -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
#                                  -p 5432 \
#                                  -d bi \
#                                  -U bi_reader \
#-c "\\COPY (SELECT * 
#             FROM linelog_201808 
#            WHERE time_received::date = '2018-08-08') TO 'linelog_20180808.csv' CSV HEADER" 
#
#tar -cvzf /home/gordaz/mnt/public/linelog_201808/linelog_20180808.csv.gz linelog_20180808.csv
##rm linelog_20180808.csv
#
cat <<- EOS
/***************************************************************************/
#[`date +%H:%M:%S`]
Start processing linelog_20180813.....

EOS

PGPASSWORD=qzvuuuv7 /usr/bin/psql -q \
                                  -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
                                  -p 5432 \
                                  -d bi \
                                  -U bi_reader \
-c "\\COPY (SELECT * 
             FROM linelog_201808 
            WHERE time_received::date = '2018-08-13') TO 'linelog_20180813.csv' CSV HEADER" 

tar -cvzf /home/gordaz/mnt/public/linelog_201808/linelog_20180813.csv.gz linelog_20180813.csv
rm linelog_20180813.csv

cat <<- EOS

linelog_20180813.csv.gz Complete
[`date +%H:%M:%S`]
/***************************************************************************/

Start processing linelog_20180814.....

EOS

PGPASSWORD=qzvuuuv7 /usr/bin/psql -q \
                                  -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
                                  -p 5432 \
                                  -d bi \
                                  -U bi_reader \
-c "\\COPY (SELECT * 
             FROM linelog_201808 
            WHERE time_received::date = '2018-08-14') TO 'linelog_20180814.csv' CSV HEADER" 

tar -cvzf /home/gordaz/mnt/public/linelog_201808/linelog_20180814.csv.gz linelog_20180814.csv
rm linelog_20180814.csv

cat <<- EOS

linelog_20180814.csv.gz Complete
[`date +%H:%M:%S`]
/***************************************************************************/

Start processing linelog_20180815.....

EOS

PGPASSWORD=qzvuuuv7 /usr/bin/psql -q \
                                  -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
                                  -p 5432 \
                                  -d bi \
                                  -U bi_reader \
-c "\\COPY (SELECT * 
             FROM linelog_201808
            WHERE time_received::date = '2018-08-15') TO 'linelog_20180815.csv' CSV HEADER" 

tar -cvzf /home/gordaz/mnt/public/linelog_201808/linelog_20180815.csv.gz linelog_20180815.csv
rm linelog_20180815.csv

cat <<- EOS

linelog_20180815.csv.gz Complete
[`date +%H:%M:%S`]
/***************************************************************************/

EOS
#
#PGPASSWORD=qzvuuuv7 /usr/bin/psql -q \
#                                  -h bi.cu22my1pyak6.ap-northeast-1.rds.amazonaws.com \
#                                  -p 5432 \
#                                  -d bi \
#                                  -U bi_reader \
#-c "\\COPY (SELECT * 
#             FROM linelog_201808
#            WHERE time_received::date = '2018-08-12') TO 'linelog_20180812.csv' CSV HEADER" 
#
#tar -cvzf /home/gordaz/mnt/public/linelog_201808/linelog_20180812.csv.gz linelog_20180812.csv
#rm linelog_20180812.csv
#
#cat <<- EOS
#
#linelog_20180812.csv.gz Complete
#[`date +%H:%M:%S`]
#/***************************************************************************/
#
#EOS
#
