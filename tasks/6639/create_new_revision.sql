create_new_revision

--- 
 DECLARE
 
   par_esn_hex                text := $1;
   par_public_number          text := $2;
   var_old_po_id              integer;
   var_new_po_id              integer;
   var_old_contact_id         integer;
   var_new_contact_id         integer;
   var_new_contact_map_id     integer;
   var_new_ol_id             integer;
   var_order_line_rec         record;
   var_num_affected           integer;
   
 
 BEGIN
   -- Get purchase_order.id based on current active purchase order.
   SELECT id INTO var_old_po_id FROM purchase_order
   WHERE public_number = par_public_number 
   AND status_id = 16
   and deleted = 0;
 
   IF var_old_po_id IS NULL THEN
     RAISE EXCEPTION '[oss.create_new_revision(text, text)] Cannot find purchase order. [PO=%]', par_public_number;
   END IF;
 
   RAISE NOTICE 'Old Purchase Order ID: %', var_old_po_id;
   -- Generate a new purchase_order.id
 
   SELECT purchase_order_id, 
          contact_id,
          order_line_id,
          contact_map_id
     INTO 
          var_new_po_id,
          var_new_contact_id,
          var_new_ol_id,
          var_new_contact_map_id
   FROM  oss.get_unique_id_for_jbilling() ;
   RAISE NOTICE 'New Purchase Order ID: %', var_new_po_id;
 
   --
   -- Create a new revision.
   --
   INSERT INTO purchase_order
     (oss_synced, active_since, active_until, anticipate_periods, created_by, user_id,
     create_datetime, currency_id, cycle_start, deleted, df_fm, due_date_unit_id,
     due_date_value, include_comm_tax, include_sales_tax, is_current, last_notified,
     next_billable_day, notes, notes_in_invoice, notification_step, notify,
     billing_type_id, period_id, status_id, own_invoice, processor, public_number,
     renewal, shipping_cost, shipping_method, tracking_num, use_privatenetwork,
     use_static, OPTLOCK, id)
   SELECT
     oss_synced, active_since, active_until, anticipate_periods, created_by, user_id,
     current_timestamp, currency_id, cycle_start, deleted, df_fm, due_date_unit_id,
     due_date_value, include_comm_tax, include_sales_tax, is_current, last_notified,
     next_billable_day, '', notes_in_invoice, notification_step,
     notify, billing_type_id, period_id, status_id, own_invoice, processor,
     CASE
       WHEN substr(public_number, length(public_number), 1) ~ '[A-Y]'
         THEN substr(public_number, 1, length(public_number) - 1) || chr(ascii(substr(public_number, length(public_number), 1)) + 1)
       WHEN substr(public_number, length(public_number), 1) ~ 'Z'
         THEN substr(public_number, 1, length(public_number) - 1) || 'AA'
       ELSE public_number || 'A'
     END AS public_number,
     renewal, shipping_cost, shipping_method, tracking_num, use_privatenetwork,
     use_static, OPTLOCK, var_new_po_id
   FROM purchase_order WHERE id = var_old_po_id;
 
   GET DIAGNOSTICS var_num_affected = ROW_COUNT;
   IF var_num_affected = 0 THEN
     RAISE EXCEPTION '[oss.create_new_revision(text, text)] Creating a new revision failed.';
   END IF;
 
   --
   -- Create the same order_line records.
   --
   FOR var_order_line_rec IN
     SELECT
       amount, create_datetime, deleted, description, item_id, type_id, price,
       provisioning_count, provisioning_request_id, provisioning_status,
       var_new_po_id, quantity, OPTLOCK, id
     FROM order_line WHERE order_id = (SELECT id FROM purchase_order WHERE id = var_old_po_id)
   LOOP
     RAISE NOTICE 'New Order Line ID: %', var_new_ol_id;
     INSERT INTO order_line
       (amount, create_datetime, deleted, description, item_id, type_id, price,
       provisioning_count, provisioning_request_id, provisioning_status, order_id,
       quantity, OPTLOCK, id)
     SELECT
       var_order_line_rec.amount, current_timestamp, var_order_line_rec.deleted,
       var_order_line_rec.description, var_order_line_rec.item_id, var_order_line_rec.type_id,
       var_order_line_rec.price, var_order_line_rec.provisioning_count, var_order_line_rec.provisioning_request_id,
       var_order_line_rec.provisioning_status,
       var_new_po_id, var_order_line_rec.quantity, var_order_line_rec.optlock,var_new_ol_id 
     FROM order_line WHERE id = var_order_line_rec.id;
     GET DIAGNOSTICS var_num_affected = ROW_COUNT;
     IF var_num_affected = 0 THEN
        RAISE NOTICE 'order line failed to insert: %',var_new_ol_id;
     ELSE
        RAISE NOTICE 'order line inserted count: % id: % ',var_num_affected, var_new_ol_id;
     END IF;
     SELECT  order_line_id into var_new_ol_id FROM  oss.get_unique_id_for_jbilling() ;
   END LOOP;
 
   --
   -- Cancel previous revision.
   --
   UPDATE purchase_order
     SET notes = notes, status_id = 1028
   WHERE id = var_old_po_id;
 
   GET DIAGNOSTICS var_num_affected = ROW_COUNT;
   IF var_num_affected = 0 THEN
     RAISE EXCEPTION '[oss.create_new_revision(text, text)] Cancelling old revision failed.';
   END IF;
 
 
   --
   -- Update order_id on prov_line table.
   --
   UPDATE prov_line
     SET order_id = var_new_po_id
   WHERE end_date IS NULL
   AND archived IS NULL
   AND start_date IS NOT NULL
   --AND acct_start_date IS NOT NULL
   --AND esn_hex = par_esn_hex
   AND order_id = var_old_po_id;
 
 
   --
   -- Create a new contact and contact_map records.
   --
   SELECT contact_id INTO var_old_contact_id
   FROM contact_map
   WHERE table_id = 21  -- purchase_order table
   AND foreign_id = var_old_po_id;
 
   -- Create a new contact whcih relates to the new revision.
   INSERT INTO contact
     (street_addres1, street_addres2, city, country_code, create_datetime, deleted,
     email, fax_area_code, fax_country_code, fax_phone_number, first_name,
     notification_include, person_initial, last_name, organization_name,
     phone2_area_code, phone2_phone_number, phone_area_code, phone_country_code,
     phone_phone_number, postal_code, state_province, person_title, user_id, OPTLOCK, id)
   SELECT
     street_addres1, street_addres2, city, country_code, create_datetime, deleted,
     email, fax_area_code, fax_country_code, fax_phone_number, first_name,
     notification_include, person_initial, last_name, organization_name,
     phone2_area_code, phone2_phone_number, phone_area_code, phone_country_code,
     phone_phone_number, postal_code, state_province, person_title, user_id, OPTLOCK,
     var_new_contact_id
   FROM contact
   WHERE id = var_old_contact_id;
 
   GET DIAGNOSTICS var_num_affected = ROW_COUNT;
   IF var_num_affected = 0 THEN
     RAISE EXCEPTION '[oss.create_new_revision(text, text)] Inserting a new contact failed.';
   END IF;
 
   -- Create a new contact_map.
   INSERT INTO contact_map
     (contact_id, type_id, foreign_id, table_id, OPTLOCK, id)
   SELECT
     var_new_contact_id, type_id, var_new_po_id, '21', 1, var_new_contact_map_id 
   FROM contact_map
   WHERE table_id = 21  -- purchase_order table
   AND foreign_id = var_old_po_id;
 
   GET DIAGNOSTICS var_num_affected = ROW_COUNT;
   IF var_num_affected = 0 THEN
     RAISE EXCEPTION '[oss.create_new_revision(text, text)] Inserting a new contact_map failed.';
   END IF;
 
   RETURN TRUE;
 
 END;
 
