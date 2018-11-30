#!/bin/bash
################################################################################
#
# Program Name : generate_trans_data_for_GreatPlains.sh
#
# Summary      : Generate a transaction data.
#                Great Plains imports this output data file into Great Plain.
#
#
#                             Copyright (C) All Rights Reserved, CCT Inc, 2015
################################################################################

#
# Define variables.
#
BASE_DIR=/opt/scripts
OUTFILE=trans_data_for_greatplains.csv

#OPENTAPS_SERVER=192.168.144.78
OPENTAPS_SERVER=10.17.70.22
OPENTAPS_DB_PORT=3306
OPENTAPS_DB_NAME=cct_0007
OPENTAPS_DB_PASS=cctus@admin123


#
# Parameter validation
#

echo "Validating the given OpenTaps transaction file....."

# Check the number of parameters.
if [ $# -ne 1 ]; then
  cat <<EOD

Usage : ./generate_tax_source_data.sh [OpenTaps Invoice Data File Name]

        E.g.) ./generate_tax_source_data.sh GPReport10633.csv

EOD
  exit
fi

# See if given file is exists and file size is not zero.
if [ ! -s "$1" ]; then
  echo "Given file doesn't exist or file size is zero. Please double-check the file."
        exit
fi

# See if given file contains comma.
grep , "$1" > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo "Given file is NOT OpenTaps invoice data file or not CSV file. Please double-check."
        exit
fi

# See if the number of commas is 36.
NF=$(head -1 "$1" | awk -F',' '{print NF}')
if [ "${NF}" -ne 36 ]; then
  echo "Given file is NOT OpenTaps invoice data file. Please double-check."
        exit
fi

OPENTAPS_TRANS_DATA=$1



#
# Get customer information from Great Plains
#
./get_customer_data_from_great_plains


#
# Load Great Plains customer data
#
cat << EOF | mysql -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} ${OPENTAPS_DB_NAME}
DROP TABLE IF EXISTS temp_great_plains_customers;

CREATE TABLE temp_great_plains_customers (
  customer_number TEXT,
  customer_name   TEXT,
  address1        TEXT,
  address2        TEXT,
  city            TEXT,
  state           TEXT,
  zip             TEXT,
  country         TEXT,
  currency_id     TEXT,
  customer_class  TEXT,
  contact_person  TEXT,
        user_defined1   TEXT
);

TRUNCATE TABLE temp_great_plains_customers;

LOAD DATA LOCAL INFILE '${BASE_DIR}/GreatPlains_Customers.csv' INTO TABLE temp_great_plains_customers FIELDS TERMINATED BY ',' ENCLOSED BY '"';
EOF



echo "Importing OpenTaps transaction data file into a temporary table."

#
# Create a new temporary table to import OpenTaps transaction data file.
#
cat << EOF | mysql -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} ${OPENTAPS_DB_NAME}
DROP TABLE IF EXISTS temp_opentaps_trans_records;

CREATE TABLE temp_opentaps_trans_records (
  trans_number                bigint,
        trans_entry_seq_id          bigint,
        trans_type                  text,
        trans_date                  datetime,
        sales_order_number          text,
        product_id                  text,
        trans_entry_amount          decimal(10,2),
        posted_date                 date,
        invoice_id                  text,
        role_type_id                text,
        org_party_id                text,
        party_id                    text,
        is_debit_credit             text,
        gl_account                  text,
        is_posted                   char(1),
        gl_fiscal_type_id           text,
        trans_description           text,
        trans_type_description      text,
        inventory_item_id           text,
        product_name                text,
        currency_uom_id             text,
        gl_account_type_id          text,
        account_code                text,
        account_name                text,
        reconcile_status_id         text,
        gl_account_class_id         text,
        group_name                  text,
        document_type               text,
        batch_id                    text,
        rate_type_id                text,
        exchange_rate               text,
        u_of_m                      text,
        site_id                     text,
        quantity                    text,
        unit_price                  decimal(10,2)
);
EOF


#
# Load OpenTaps transaction records into the temporary table.
#
cat << EOF | mysql -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} ${OPENTAPS_DB_NAME}
LOAD DATA
  LOCAL INFILE '${OPENTAPS_TRANS_DATA}'
        INTO TABLE temp_opentaps_trans_records
        FIELDS TERMINATED BY ',' ENCLOSED BY '"'
        IGNORE 1 LINES
        (trans_number, trans_entry_seq_id, trans_type, trans_date, sales_order_number, product_id, trans_entry_amount, @posted_date, invoice_id, role_type_id, org_party_id, party_id, is_debit_credit, gl_account, is_posted, gl_fiscal_type_id, trans_description, trans_type_description, inventory_item_id, product_name, currency_uom_id, gl_account_type_id, account_code, account_name, reconcile_status_id, gl_account_class_id, group_name, document_type, batch_id, rate_type_id, exchange_rate, u_of_m, site_id, quantity, unit_price)

SET
  posted_date = str_to_date(@posted_date, '%m/%d/%y')
;
EOF



#
# Load internal company IDs
# Internal company's transaction data needs to be excluded.
#
echo "Retrieving internal company IDs from OSS."

INTERNAL_BEIDS=$(PGPASSWORD=owner psql -q -h denoss01.contournetworks.net -p 5450 -d csctoss -U csctoss_owner -A -t -c "
SELECT
  array_to_string(array(
  SELECT jbill.user_id
    FROM csctoss.billing_entity be
    JOIN dblink((SELECT * FROM fetch_jbilling_conn()),
    'SELECT user_id, external_id FROM public.customer'
    ) jbill (user_id int, external_id int)
    ON (be.billing_entity_id = jbill.external_id)
    WHERE be.billing_entity_type = 'INTERNAL'
    ORDER BY jbill.user_id),
    ',');")

echo "Internal companies user_ids = ${INTERNAL_BEIDS}"


echo "Creating a transaction data for Great Plains."

#
# Add header line.
#
echo "TRANS_NUMBER,TRANS_ENTRY_SEQ_ID,TRANS_TYPE,TRANS_DATE,SALES_ORDER_NUMBER,PRODUCT_ID,TRANS_ENTRY_AMOUNT,POSTED_DATE,INVOICE_ID,ROLE_TYPE_ID,ORG_PARTY_ID,PARTY_ID,IS_DEBIT_CREDIT,GL_ACCOUNT,IS_POSTED,GL_FISCAL_TYPE_ID,TRANS_DESCRIPTION,TRANS_TYPE_DESCRIPTION,INVENTORY_ITEM_ID,PRODUCT_NAME,CURRENCY_UOM_ID,GL_ACCOUNT_TYPE_ID,ACCOUNT_CODE,ACCOUNT_NAME,RECONCILE_STATUS_ID,GL_ACCOUNT_CLASS_ID,GROUP_NAME,DOCUMENT_TYPE,BATCH_ID,RATE_TYPE_ID,EXCHANGE_RATE,U_OF_M,SITE_ID,QUANTITY,UNIT_PRICE" > ${OUTFILE}


#cat << EOF | mysql -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} --skip-column-names ${OPENTAPS_DB_NAME}
cat << EOF | mysql -h ${OPENTAPS_SERVER} -P ${OPENTAPS_DB_PORT} -u root --password=${OPENTAPS_DB_PASS} --skip-column-names ${OPENTAPS_DB_NAME} | sed 's/\t/,/g;s/\n//g' | nkf -Lw >> ${BASE_DIR}/${OUTFILE}
SELECT
  opt.trans_number,
  opt.trans_entry_seq_id,
  opt.trans_type,
	date_format(opt.trans_date, '%Y-%m-%d %H:%i:%s.0'),
  opt.sales_order_number,
	CASE
		WHEN opt.account_name = 'Postage and Delivery' THEN 'POSTAGE-DELIV'
    ELSE opt.product_id
	END AS product_id,
  opt.trans_entry_amount,
	date_format(opt.posted_date, '%m/%d/%y'),
  opt.invoice_id,
  opt.role_type_id,
  opt.org_party_id,
  CASE
		WHEN pty.parent_party_id IS NOT NULL THEN pty.parent_party_id
		ELSE opt.party_id
	END AS party_id,
  opt.is_debit_credit,
  opt.gl_account,
  opt.is_posted,
  opt.gl_fiscal_type_id,
  opt.trans_description,
  opt.trans_type_description,
  opt.inventory_item_id,
	CASE
		WHEN opt.account_name = 'Postage and Delivery' THEN 'Postage and Handling'
	  ELSE concat('"', opt.product_name, '"')
	END AS product_name,
  opt.currency_uom_id,
  opt.gl_account_type_id,
  opt.account_code,
	TRIM(opt.account_name),
  opt.reconcile_status_id,
  opt.gl_account_class_id,
  opt.group_name,
  opt.document_type,
  opt.batch_id,
  opt.rate_type_id,
	TRUNCATE(opt.exchange_rate, 0),
  opt.u_of_m,
  opt.site_id,
  CASE
		WHEN opt.account_code = '408000' AND opt.quantity = '' THEN '1'
    ELSE CEIL(opt.quantity)
	END AS quantity,
	CASE
    WHEN opt.account_name = 'Postage and Delivery' THEN opt.trans_entry_amount
    ELSE opt.unit_price
	END AS unit_price

FROM temp_opentaps_trans_records opt
LEFT OUTER JOIN ${OPENTAPS_DB_NAME}.party_supplemental_data pty ON (opt.party_id = pty.party_id)
WHERE 1 = 1
AND opt.party_id NOT IN (${INTERNAL_BEIDS})
AND trans_type <> 'SHIPMENT_RCPT_ATX'
AND gl_account_type_id <> 'ACCOUNTS_RECEIVABLE'
;
EOF


#
# Replace double-quote sign
#
perl -pi -e 's/12"/12inch/g' ${BASE_DIR}/${OUTFILE}


echo "Created a transaction data file for Great Plains. [FileName=${BASE_DIR}/${OUTFILE}]"
echo "Great Plains needs to load this output data file into Great Plains by using Integration Manager."
echo ""
echo "Done."

exit 0
#__END-OF-SCRIPT__

