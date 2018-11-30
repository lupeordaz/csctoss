
--RMA problem: rma'd to the wrong customer ip
--
--original:794869 new:765555, Original IP:10.60.9.200
--
--  The IP range 10.60.8.0/22 is reserved for ATM Concepts; this includes the range '10.60.9.%'.
-- 

select count(*)
  from static_ip_pool 
 where static_ip like '10.60.9.%'
   and groupname = 'SERVICE-atmaficionado';

 count 
-------
    79
(1 row)


SERVICE-atmconcepts

select * from static_ip_pool where line_id = 42863;
  id   |  static_ip   |       groupname       | is_assigned | line_id | carrier_id | billing_entity_id 
-------+--------------+-----------------------+-------------+---------+------------+-------------------
 25671 | 10.60.92.109 | SERVICE-atmaficionado | t           |   42863 |          2 |               116
 56693 | 10.60.9.200  | SERVICE-atmaficionado | t           |   42863 |          2 |               116
(2 rows)



BEGIN;

select public.set_change_log_staff_id(3);

UPDATE static_ip_pool
   SET line_id = null
      ,is_assigned = FALSE
 WHERE id = 56693
   AND static_ip = '10.60.9.200';

UPDATE static_ip_pool
   SET groupname = 'SERVICE-atmconcepts'
      ,billing_entity_id = 221
      ,is_assigned = FALSE
 where static_ip like '10.60.9.%'
   and groupname = 'SERVICE-atmaficionado';

SELECT * FROM static_ip_pool where static_ip like '10.60.9.%';

COMMIT;

csctoss=# BEGIN;
BEGIN
csctoss=# select public.set_change_log_staff_id(3);
 set_change_log_staff_id 
-------------------------
                       3
(1 row)

csctoss=# UPDATE static_ip_pool
csctoss-#    SET line_id = null
csctoss-#       ,is_assigned = FALSE
csctoss-#  WHERE id = 56693
csctoss-#    AND static_ip = '10.60.9.200';
UPDATE 1
csctoss=# UPDATE static_ip_pool
csctoss-#    SET groupname = 'SERVICE-atmconcepts'
csctoss-#       ,billing_entity_id = 221
csctoss-#       ,is_assigned = FALSE
csctoss-#  where static_ip like '10.60.9.%'
csctoss-#    and groupname = 'SERVICE-atmaficionado';
UPDATE 79
csctoss=# SELECT * FROM static_ip_pool where static_ip like '10.60.9.%';
  id   |  static_ip  |      groupname      | is_assigned | line_id | carrier_id | billing_entity_id 
-------+-------------+---------------------+-------------+---------+------------+-------------------
 56697 | 10.60.9.204 | SERVICE-atmconcepts | f           |         |          2 |               221
 56698 | 10.60.9.205 | SERVICE-atmconcepts | f           |         |          2 |               221
 56699 | 10.60.9.206 | SERVICE-atmconcepts | f           |         |          2 |               221
 56700 | 10.60.9.207 | SERVICE-atmconcepts | f           |         |          2 |               221
.
.
.
 56559 | 10.60.9.66  | SERVICE-atmconcepts | f           |         |          2 |               221
 56693 | 10.60.9.200 | SERVICE-atmconcepts | f           |         |          2 |               221
 56694 | 10.60.9.201 | SERVICE-atmconcepts | f           |         |          2 |               221
 56695 | 10.60.9.202 | SERVICE-atmconcepts | f           |         |          2 |               221
 56696 | 10.60.9.203 | SERVICE-atmconcepts | f           |         |          2 |               221
(254 rows)


csctoss=# COMMIT;
COMMIT
csctoss=# 
