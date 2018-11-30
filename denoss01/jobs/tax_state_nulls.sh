#!/bin/bash
#
##Simple script that logs into jbilling db and checks contact, sales_tax, and
##telcom_tax tables for state_province values that dont meet required format
##and emails a notification if any are found
#

source /home/postgres/.bash_profile


DATE=`date +"%Y%m%d"`
DATE2=`date +"%Y-%m-%d"`
REGEXVAL='[A-Z]{2}'
#RECIP=btekeste@cctus.com
RECIP=dba@cctus.com
BASEDIR=/home/postgres/dba/
LOGFILE=$BASEDIR/logs/tax_state_nulls.$DATE.log

echo $DATE2 >$LOGFILE
echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

#check sales_tax for null states
VAR=`psql -q -t -c "select *
                        from public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
                           'select id
                                ,postal_code
                                ,state_province
                                ,percentage
                            from sales_tax where state_province IS NULL')
    as rec_type(id                integer
               ,postal_code       integer
               ,state_province    text
               ,percentage        decimal)"`

if [ -z "$VAR" ];then
   :
else
   echo "The following records have null values for "state_province" in the sales_tax table(public.sales_tax)" >> $LOGFILE
   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE
   printf "$VAR\n" >> $LOGFILE

   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE

   echo "--------------------------------------------------"                >> $LOGFILE
fi

echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

#check telcom_tax for null states
VAR2=`psql -q -t -c "select *
                        from public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
                           'select id
                                ,postal_code
                                ,state_province
                                ,percentage
                            from telcom_tax where state_province IS NULL')
    as rec_type(id                      integer
               ,postal_code             integer
               ,state_province          text
               ,percentage              decimal)"`

if [ -z "$VAR2" ];then
   :
else
   echo "The following records have null values for "state_province" in the telcom_tax table (public.telcom_tax)" >> $LOGFILE
   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE
   printf "$VAR2\n" >> $LOGFILE

   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE

   echo "--------------------------------------------------"                >> $LOGFILE
fi

echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

#check sales_tax for blank states
VAR3=`psql -q -t -c "select *
                        from public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
                           'select id
                                ,postal_code
                                ,state_province
                                ,percentage
                            from sales_tax where state_province = \'\'')
    as rec_type(id                integer
               ,postal_code       integer
               ,state_province    text
               ,percentage        decimal)"`

if [ -z "$VAR3" ];then
   :
else
   echo "The following records have blank values for "state_province" in the sales_tax table(public.sales_tax)" >> $LOGFILE
   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE
   printf "$VAR3\n" >> $LOGFILE

   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE

   echo "--------------------------------------------------"                >> $LOGFILE
fi

echo " "     >> $LOGFILE
echo " "     >> $LOGFILE

#check telcom_tax for blank states
VAR4=`psql -q -t -c "select *
                        from public.dblink('host=denjbi02.contournetworks.net port=5440 dbname=jbilling user=oss_writer password=wr1t3r',
                           'select id
                                ,postal_code
                                ,state_province
                                ,percentage
                            from telcom_tax where state_province =\'\'')
    as rec_type(id                integer
               ,postal_code       integer
               ,state_province    text
               ,percentage        decimal)"`

if [ -z "$VAR4" ];then
   :
else
   echo "The following records have blank values for "state_province" in the telcom_tax table(public.telcom_tax)" >> $LOGFILE
   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE
   printf "$VAR4\n" >> $LOGFILE

   echo " "     >> $LOGFILE
   echo " "     >> $LOGFILE

   echo "--------------------------------------------------"                >> $LOGFILE

fi

#Check logfile FOR SPECIFIC STRING to determine if there is anything to email
if  grep -Fq "The following records" $LOGFILE ;then
        cat $LOGFILE | mail -s "Jbilling:Incorrect state values found in tax tables" $RECIP

fi
