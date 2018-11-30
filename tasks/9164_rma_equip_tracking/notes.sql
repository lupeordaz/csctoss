-- #9164 request to add RMA tracking integer variable to OSS tables

select equipment_id
      ,count(line_id)
  from line_equipment
 group by equipment_id
having count(line_id) > 5
 order by equipment_id;

 equipment_id | count 
--------------+-------
        20380 |     6
        23466 |     6
        37272 |     6
        40716 |     6
(4 rows)

select equipment_id
      ,line_id
      ,start_date
      ,end_date
  from line_equipment 
 where equipment_id in (select le.equipment_id
                          from line_equipment le 
                         group by le.equipment_id 
                        having count(le.line_id) > 3)
 order by equipment_id, end_date, start_date desc limit 21;
 equipment_id | line_id | start_date |  end_date  
--------------+---------+------------+------------
           12 |      82 | 2007-12-27 | 2008-02-23
           12 |      58 | 2008-02-24 | 2008-06-19
           12 |     774 | 2008-06-20 | 2008-10-21
           12 |    2429 | 2009-07-14 | 2015-04-24
           21 |      91 | 2007-12-26 | 2008-02-23
           21 |      61 | 2008-02-24 | 2008-02-29
           21 |     779 | 2008-06-20 | 2009-03-06
           21 |    2431 | 2009-07-14 | 2012-08-31
           22 |     344 | 2007-12-26 | 2008-02-23
           22 |      60 | 2008-02-24 | 2008-02-29
           22 |     780 | 2008-06-20 | 2009-03-06
           22 |     106 | 2010-01-25 | 2010-08-16
           24 |      93 | 2007-12-26 | 2008-02-23
           24 |      63 | 2008-02-24 | 2008-06-19
           24 |     777 | 2008-06-20 | 2008-10-21
           24 |    2565 | 2008-10-22 | 
           27 |      79 | 2007-12-27 | 2008-02-23
           27 |      59 | 2008-02-24 | 2008-02-29
           27 |    3818 | 2009-08-17 | 2009-11-04
           27 |    5524 | 2009-11-05 | 2009-11-05
           27 |    5528 | 2009-11-06 | 2011-09-13
(21 rows)

--

psql -q \
     -h denoss01.contournetworks.net  \
     -d csctoss \
     -p 5450  \
     -U csctoss_owner \
     -t \
     -P tuples_only \
     -P format=unaligned \
     -P fieldsep=\, \
     -f 9164_query.sql > 9164_report.csv



     -c="select equipment_id	\
      ,line_id	\
      ,start_date	\
      ,end_date	\
  from line_equipment 	\
 where equipment_id in (select le.equipment_id	\
                          from line_equipment le 	\
                         group by le.equipment_id 	\
                        having count(le.line_id) > 3)	\
 order by equipment_id, end_date, start_date;" > 9164.csv



