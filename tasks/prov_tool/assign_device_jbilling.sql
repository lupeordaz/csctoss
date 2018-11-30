-- Function: oss.assign_device_jbilling(text, text, text, text, integer)

-- DROP FUNCTION oss.assign_device_jbilling(text, text, text, text, integer);

CREATE OR REPLACE FUNCTION oss.assign_device_jbilling(text, text, text, text, integer)
  RETURNS boolean AS
$BODY$
DECLARE

  par_so_number              text := $1;
  par_esn_hex                text := $2;
  par_sn                     text := $3;
  par_username               text := $4;
  par_line_id                integer := $5;
  var_sales_order_qnt_check  bigint;  
  var_order_row              oss.check_if_last_device_to_prov_on_so_type%rowtype;
  var_is_last_device         boolean;  
  
BEGIN
--get number of remaning items to be provitioned
PERFORM oss.check_sales_order_prov_remaining_items_perform(par_so_number);


--check if the esn/sn/line id/username is curenttly assigned to another so throws exception if they exist
PERFORM oss.check_if_unique_ids_are_already_provisioned_to_an_so(par_esn_hex,par_sn,par_username,par_line_id);


--get sales order item id and order it
SELECT 
 * 
INTO 
 var_order_row 
FROM 
 oss.get_sales_order_id_prov_item_id(par_so_number); 


   
         --Insert Prov Line
INSERT 
INTO 
public.prov_line
( order_id,item_id,line_id,esn_hex,username,start_date,sn,optlock )
VALUES 
( var_order_row.so_order,var_order_row.so_item_id,par_line_id,par_esn_hex,par_username,current_date,par_sn,0);


--Update prov. count
PERFORM oss.update_prov_count_line(par_so_number);

--Check Device Count
SELECT * INTO var_is_last_device FROM oss.check_if_last_device_to_prov_on_so(par_so_number); 


--if last device update status
IF (var_is_last_device) THEN
PERFORM oss.change_so_status(par_so_number);
END IF;
  
 
   RETURN true;
END ;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION oss.assign_device_jbilling(text, text, text, text, integer)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.assign_device_jbilling(text, text, text, text, integer) TO postgres;
GRANT EXECUTE ON FUNCTION oss.assign_device_jbilling(text, text, text, text, integer) TO public;
GRANT EXECUTE ON FUNCTION oss.assign_device_jbilling(text, text, text, text, integer) TO jbilling;
