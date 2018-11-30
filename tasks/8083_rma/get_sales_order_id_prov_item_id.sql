-- Function: oss.get_sales_order_id_prov_item_id(text)

-- DROP FUNCTION oss.get_sales_order_id_prov_item_id(text);

CREATE OR REPLACE FUNCTION oss.get_sales_order_id_prov_item_id(text)
  RETURNS oss.get_sales_order_id_prov_item_id_type AS
$BODY$
DECLARE

  par_so_number              text := $1;
  var_results                oss.check_if_last_device_to_prov_on_so_type%rowtype;
  
BEGIN
   SELECT po.id as so_order, ol.item_id as so_item_id
INTO var_results
FROM 
 order_line ol
JOIN purchase_order po ON ol.order_id = po.id 
JOIN item i ON ol.item_id = i.id
JOIN item_type_map im ON im.item_id = i.id
WHERE public_number = par_so_number
AND im.type_id = 301
AND i.internal_number LIKE 'MRC-%'
LIMIT 1;
  IF FOUND THEN 
    RETURN var_results;
  ELSE 
RAISE EXCEPTION 'JBILLING: Error Finding sales order. The MRC item might not have been added to the SO. Please check.';
  END IF;

END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION oss.get_sales_order_id_prov_item_id(text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.get_sales_order_id_prov_item_id(text) TO postgres;
GRANT EXECUTE ON FUNCTION oss.get_sales_order_id_prov_item_id(text) TO public;
GRANT EXECUTE ON FUNCTION oss.get_sales_order_id_prov_item_id(text) TO jbilling;