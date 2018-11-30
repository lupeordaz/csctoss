-- Function: static_ip_desc(text)

-- DROP FUNCTION static_ip_desc(text);

CREATE OR REPLACE FUNCTION static_ip_desc(text)
  RETURNS SETOF static_ip_desc_type AS
$BODY$
DECLARE
  var_ip_row                  RECORD;
  var_return_row              static_ip_desc_type%ROWTYPE;
  var_ip_desc                 text;

BEGIN

var_ip_desc = $1;
RAISE NOTICE 'var_ip_desc=%', var_ip_desc;

FOR var_ip_row IN
  select username, max(acctstarttime) 
    from master_radacct
   group by username
   order by username;
  LOOP
    select master_radacctid
          ,username
      var_return_row.id = var_ip_row.id;
      var_return_row.static_ip = var_ip_row.static_ip;
      var_return_row.carrier_id = var_ip_row.carrier_id;
      var_return_row.carrier_name = var_ip_row.carrier_name;
      var_return_row.groupname = var_ip_row.groupname;
      var_return_row.billing_entity_id = var_ip_row.billing_entity_id;
      var_return_row.billing_name = var_ip_row.billing_name;
      RETURN NEXT var_return_row;
   END LOOP;
              
RAISE NOTICE 'Finished Function';
RETURN;

END ;
$BODY$
  LANGUAGE plpgsql STABLE SECURITY DEFINER;
ALTER FUNCTION static_ip_desc(text)
  OWNER TO csctoss_owner;
