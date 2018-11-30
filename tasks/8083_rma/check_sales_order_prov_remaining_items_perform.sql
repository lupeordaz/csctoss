-- Function: oss.check_sales_order_prov_remaining_items_perform(text)

-- DROP FUNCTION oss.check_sales_order_prov_remaining_items_perform(text);

CREATE OR REPLACE FUNCTION oss.check_sales_order_prov_remaining_items_perform(text)
  RETURNS boolean AS
$BODY$
DECLARE

  par_sales_order_number        text := $1;
  var_results               bigint;
  

BEGIN
	SELECT 
		sl.qnt - ss.qnt as qnt
	INTO var_results
	FROM 
	(
		SELECT 
		 ol.quantity::bigint qnt
		FROM 
		 order_line ol
		JOIN purchase_order po ON ol.order_id = po.id 
		JOIN item i ON ol.item_id = i.id
		JOIN item_type_map im ON im.item_id = i.id
		--JOIN item_type it ON im.type_id = it.id
		WHERE public_number = par_sales_order_number
		AND im.type_id = 300
	) sl
	, 
	(
		SELECT 
		COUNT(*) as qnt 
		FROM 
		 prov_line pl 
		JOIN purchase_order po 
		ON pl.order_id = po.id 
		WHERE public_number = par_sales_order_number
	) ss;

	IF(var_results > 0) THEN
	    RETURN TRUE;
	ELSE
	    RAISE EXCEPTION 'JBILLING: SO has has all devices assigned';
	END IF;

END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION oss.check_sales_order_prov_remaining_items_perform(text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_sales_order_prov_remaining_items_perform(text) TO postgres;
GRANT EXECUTE ON FUNCTION oss.check_sales_order_prov_remaining_items_perform(text) TO public;
GRANT EXECUTE ON FUNCTION oss.check_sales_order_prov_remaining_items_perform(text) TO jbilling;
