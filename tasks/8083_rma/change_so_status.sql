-- Function: oss.change_so_status(text)

-- DROP FUNCTION oss.change_so_status(text);

CREATE OR REPLACE FUNCTION oss.change_so_status(text)
  RETURNS boolean AS
$BODY$
DECLARE
  par_so_number              text := $1;
  var_order_id                bigint;

BEGIN
  SELECT ol.order_id::bigint qnt INTO var_order_id
  FROM order_line ol
  JOIN purchase_order po ON ol.order_id = po.id
  JOIN item i ON ol.item_id = i.id
  JOIN item_type_map im ON im.item_id = i.id
  WHERE po.public_number = par_so_number
  AND im.type_id = 300;

  IF FOUND THEN
    UPDATE order_line ol
      SET provisioning_status = 20
    WHERE ol.order_id = var_order_id
  --  AND ol.item_id > 10    --   removed this line to correct error in OSSSynceventtask due to inactive telcom tax item.
  ;
    UPDATE purchase_order po
      SET status_id = 16,
          active_since = current_date
    WHERE po.public_number = par_so_number;
  ELSE
    RAISE EXCEPTION 'JBILLING: Error Updataing SO and LINE ID Status';
  END IF;

  RETURN TRUE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION oss.change_so_status(text)
  OWNER TO postgres;
GRANT EXECUTE ON FUNCTION oss.change_so_status(text) TO postgres;
GRANT EXECUTE ON FUNCTION oss.change_so_status(text) TO public;
GRANT EXECUTE ON FUNCTION oss.change_so_status(text) TO jbilling;
