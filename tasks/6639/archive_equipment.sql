archive_equipment
--- 
 DECLARE
 
   par_esn_hex                text := $1;
   var_order_id               integer;
   var_item_id_r              integer;
   var_item_id_dp             integer;
   var_prev_prov_count        integer;
 
   var_public_number          text;
   var_rev_created            date;
   var_curr_date              date;
   var_retval                 boolean;
   var_length                 integer;
 
 BEGIN
   -- Validate parameter.
   IF (par_esn_hex IS NULL) THEN
     RAISE EXCEPTION 'JBILLING: ESN HEX can Not Be Null';
   END IF;
 
   -- Get the order_id
   SELECT order_id INTO var_order_id
   FROM prov_line
   WHERE end_date IS NULL
   AND archived IS NULL
   AND start_date IS NOT NULL
   --AND acct_start_date IS NOT NULL
   AND esn_hex = par_esn_hex
   LIMIT 1;
 
   IF var_order_id IS NULL THEN
     RAISE EXCEPTION 'JBILLING: Could Not Obtain Order Id.';
   END IF;
 
   RAISE INFO 'var_order_id=%', var_order_id;
 
   -- Create a new revision if this cancel happened in a different date.
   SELECT public_number, create_datetime::date INTO var_public_number, var_rev_created
   FROM purchase_order po
   WHERE status_id = 16
   AND id = var_order_id;
 
   IF (var_public_number is null) THEN
      RAISE EXCEPTION 'JBILLING: Could Not Obtain Active Order Number for order_id: %', var_order_id;
   END IF;
 
   IF (CURRENT_DATE <> var_rev_created) THEN
     RAISE INFO 'Creating a new sales order revision for %.', var_public_number;
 
     IF (oss.create_new_revision(par_esn_hex, var_public_number) = TRUE) THEN
       -- Get newly created order_id.
       SELECT order_id INTO var_order_id
       FROM prov_line
       WHERE end_date IS NULL
       AND archived IS NULL
       and archived_date is null
       AND start_date IS NOT NULL
      -- AND acct_start_date IS NOT NULL
       AND esn_hex = par_esn_hex
       LIMIT 1;
 
       IF var_order_id IS NULL THEN
         RAISE EXCEPTION 'JBILLING: Could Not Obtain Newly Created Order Id.';
       END IF;
 
       RAISE INFO 'var_order_id=%', var_order_id;
     ELSE
       RAISE EXCEPTION 'JBILLING: Could Not create a new sales order revision.';
     END IF;
 
   END IF;
 
   -- Add cancelled esn_hex value into purchase_order.notes field.
   select length(notes) into var_length
   from purchase_order
   WHERE status_id = 16
   AND id = var_order_id;
   if var_length > 0
   then
       UPDATE purchase_order SET notes = notes || ', ' || par_esn_hex
       WHERE status_id = 16
       AND id = var_order_id;
   else
       UPDATE purchase_order SET notes = par_esn_hex
       WHERE status_id = 16
       AND id = var_order_id;
   end if;
 
 --    get accurate provisioning count
   select count(*) into var_prev_prov_count
   from purchase_order o,
        order_line ol,
        item_type_map im,
        prov_line l
   where 1=1
     and o.id = var_order_id
     and o.id = ol.order_id
     and ol.item_id = im.item_id
     and o.id = l.order_id
     and l.item_id = ol.item_id
     and im.type_id = 301
     and o.active_since is not null
     and l.archived_date is  null;
 
   RAISE INFO 'var_prev_prov_count=%', var_prev_prov_count;
 
   IF var_prev_prov_count IS NULL THEN
     RAISE EXCEPTION 'JBILLING: Could Not Obtain Provisioning Count';
   END IF;
 
   -- Archive the equipment
   UPDATE prov_line
     SET archived = 1,
         end_date = current_date,
         archived_date = current_date,
         archived_reason='Cust. Cancelled'
   WHERE end_date IS NULL
   AND archived IS NULL
   AND start_date IS NOT NULL
   --AND acct_start_date IS NOT NULL
   AND esn_hex = par_esn_hex;
 
   -- Get the router item_id
   SELECT i.id INTO var_item_id_r
   FROM order_line ol
   JOIN purchase_order po ON ol.order_id = po.id
   JOIN item i ON ol.item_id = i.id
   JOIN item_type_map im ON im.item_id = i.id
   JOIN item_type it ON im.type_id = it.id
   WHERE im.type_id = 300
   AND ol.order_id = var_order_id
   LIMIT 1;
 
   RAISE INFO 'var_item_id_r=%', var_item_id_r;
 
   IF var_item_id_r IS NULL THEN
     var_item_id_r := 0;
   END IF;
 
   -- Get the data plan item id
   SELECT i.id INTO var_item_id_dp
   FROM order_line ol
   JOIN purchase_order po ON ol.order_id = po.id
   JOIN item i ON ol.item_id = i.id
   JOIN item_type_map im ON im.item_id = i.id
   JOIN item_type it ON im.type_id = it.id
   WHERE im.type_id = 301
   AND ol.order_id = var_order_id
   LIMIT 1;
 
   RAISE INFO 'var_item_id_dp=%', var_item_id_dp;
 
   IF var_item_id_dp IS NULL THEN
     RAISE EXCEPTION 'JBILLING: Could Not Obtain Dataplan Item Id';
   END IF;
 
 
   -- Decrement quantity and provisioning_count
 
   IF (var_prev_prov_count > 1) THEN
     RAISE INFO '(>1) var_prev_prov_count=%', var_prev_prov_count;
     UPDATE order_line
       SET quantity = (quantity - 1),
 --          provisioning_count = (provisioning_count - 1),
           provisioning_count = (var_prev_prov_count - 1),
           amount = amount - price
     WHERE item_id IN (var_item_id_r,var_item_id_dp)
     AND order_id = var_order_id;
   END IF;
 
     -- Delete order_items except plan such as "MRC-..."
     DELETE FROM order_line
     WHERE order_id = var_order_id
     AND id NOT IN (SELECT ol.id FROM order_line ol
                    JOIN purchase_order po ON ol.order_id = po.id
                    JOIN item i ON ol.item_id = i.id
                    JOIN item_type_map im ON im.item_id = i.id
                    JOIN item_type it ON im.type_id = it.id
 --                   WHERE im.type_id = 301
                    WHERE im.type_id in( 301,900,901)
                    AND ol.order_id = var_order_id);
 --
   IF (var_prev_prov_count = 1) THEN
     -- Change status_id from "active" to "cancel".
     UPDATE purchase_order
       SET status_id = 1028
     WHERE id = var_order_id;
   END IF;
 
   IF (var_prev_prov_count = 0) THEN
     UPDATE purchase_order
       SET status_id = 1028
     WHERE id = var_order_id;
   END IF;
 
   RETURN TRUE;
 
 END;
 
