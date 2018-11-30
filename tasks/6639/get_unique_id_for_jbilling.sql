 DECLARE
 
 v_max_id        integer;
 v_hold_id       integer;
 v_match         boolean;
 v_count         integer:=0;
 v_thisid        integer;
 
 BEGIN
   SELECT max(id) INTO v_max_id
   FROM purchase_order;
   FOR thisid in 1000..v_max_id 
         LOOP
             v_match=NULL;
             SELECT true INTO v_match
             FROM purchase_order  po
             where 1=1
               and po.id=thisid;
             IF v_match is NULL
             then
                purchase_order_id:=thisid;
                EXIT;
             END IF;
        END LOOP;
 --
  v_max_id:=0;
  v_count:=0;
  SELECT max(id) INTO v_max_id
   FROM contact;
   FOR thisid in 1000..v_max_id
         LOOP
             v_hold_id=0;
             SELECT true INTO v_match
             FROM contact c
             where 1=1
               and c.id=thisid;
             IF v_match is NULL
             then
                contact_id:=thisid;
                EXIT;
             END IF;
          END LOOP;
  v_max_id:=0;
  v_count:=0;
  SELECT max(id) INTO v_max_id
   FROM order_line;
   FOR thisid in 1000..v_max_id
         LOOP
             v_hold_id=0;
             SELECT true INTO v_match
             FROM order_line ol
             where 1=1
               and ol.id=thisid;
             IF v_match is NULL
             then
                order_line_id:=thisid;
                EXIT;
             END IF;
          END LOOP;
  v_max_id:=0;
  v_count:=0;
  SELECT max(id) INTO v_max_id
   FROM contact_map;
   FOR thisid in 1000..v_max_id
         LOOP
             v_hold_id=0;
             SELECT true INTO v_match
             FROM contact_map cm
             where 1=1
               and cm.id=thisid;
             IF v_match is NULL
             then
                contact_map_id:=thisid;
                EXIT;
             END IF;
          END LOOP;
 v_max_id:=0;
  v_count:=0;
  SELECT max(id) INTO v_max_id
   FROM prov_line;
   FOR thisid in 1000..v_max_id
         LOOP
             v_hold_id=0;
             SELECT true INTO v_match
             FROM prov_line pl
             where 1=1
               and pl.id=thisid;
             IF v_match is NULL
             then
                prov_line_id:=thisid;
                EXIT;
             END IF;
          END LOOP;
 END;
