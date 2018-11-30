select equipment_id
      ,line_id
      ,start_date
      ,end_date
  from line_equipment 
 where equipment_id in (select le.equipment_id
                          from line_equipment le 
                         group by le.equipment_id 
                        having count(le.line_id) > 3)
 order by equipment_id, end_date, start_date;