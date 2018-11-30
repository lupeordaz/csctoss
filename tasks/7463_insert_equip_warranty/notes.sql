

select le.line_id
      ,le.equipment_id
      ,l.start_date
  from line l
  join line_equipment le on le.line_id = l.line_id
 where le.equipment_id in (
csctoss(# select e.equipment_id
csctoss(#   from equipment e
csctoss(#   join equipment_model em on em.equipment_model_id = e.equipment_model_id
csctoss(#  where model_number2 = 'SL-08-P-CV1');
 line_id | equipment_id |       start_date       
---------+--------------+------------------------
   46650 |        43583 | 2018-04-08 18:00:00-06
   46651 |        43584 | 2018-04-08 18:00:00-06
   46652 |        43585 | 2018-04-08 18:00:00-06
   46653 |        43587 | 2018-04-08 18:00:00-06
   46654 |        43588 | 2018-04-08 18:00:00-06
   46655 |        43592 | 2018-04-08 18:00:00-06
   46656 |        43593 | 2018-04-08 18:00:00-06
   46778 |        43624 | 2018-06-05 18:00:00-06
   46783 |        43617 | 2018-06-07 18:00:00-06
   46784 |        43625 | 2018-06-07 18:00:00-06
   46785 |        43622 | 2018-06-07 18:00:00-06
   46793 |        43618 | 2018-06-10 18:00:00-06
   46794 |        43623 | 2018-06-10 18:00:00-06
   46795 |        43620 | 2018-06-10 18:00:00-06
   46772 |        43621 | 2018-05-28 18:00:00-06
   46664 |        43589 | 2018-04-12 18:00:00-06
   46665 |        43586 | 2018-04-12 18:00:00-06
   46666 |        43590 | 2018-04-12 18:00:00-06
(18 rows)

begin;
BEGIN
select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                      -1
(1 row)

INSERT INTO equipment_warranty
select le.equipment_id
      ,l.start_date
      ,l.start_date + (60::text || ' month')::interval
  from line l
  join line_equipment le on le.line_id = l.line_id
 where le.equipment_id in (
select e.equipment_id
  from equipment e
  join equipment_model em on em.equipment_model_id = e.equipment_model_id
 where model_number2 = 'SL-08-P-CV1');
INSERT 0 18
csctoss=# COMMIT;
COMMIT

select * from equipment_warranty
 where equipment_id in (
			select e.equipment_id
			  from equipment e
			  join equipment_model em on em.equipment_model_id = e.equipment_model_id
			 where model_number2 = 'SL-08-P-CV1'); 
 equipment_id |  warranty_start_date   |   warranty_end_date    
--------------+------------------------+------------------------
        43583 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43584 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43585 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43587 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43588 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43592 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43593 | 2018-04-08 18:00:00-06 | 2023-04-08 18:00:00-06
        43624 | 2018-06-05 18:00:00-06 | 2023-06-05 18:00:00-06
        43617 | 2018-06-07 18:00:00-06 | 2023-06-07 18:00:00-06
        43625 | 2018-06-07 18:00:00-06 | 2023-06-07 18:00:00-06
        43622 | 2018-06-07 18:00:00-06 | 2023-06-07 18:00:00-06
        43618 | 2018-06-10 18:00:00-06 | 2023-06-10 18:00:00-06
        43623 | 2018-06-10 18:00:00-06 | 2023-06-10 18:00:00-06
        43620 | 2018-06-10 18:00:00-06 | 2023-06-10 18:00:00-06
        43621 | 2018-05-28 18:00:00-06 | 2023-05-28 18:00:00-06
        43589 | 2018-04-12 18:00:00-06 | 2023-04-12 18:00:00-06
        43586 | 2018-04-12 18:00:00-06 | 2023-04-12 18:00:00-06
        43590 | 2018-04-12 18:00:00-06 | 2023-04-12 18:00:00-06
(18 rows)
