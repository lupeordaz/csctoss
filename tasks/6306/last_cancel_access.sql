-- List all lines that have been terminated within the last
-- six months and the last connection time for that line.
select be.name AS billing_entity_name
      ,line.line_id AS line_id
      ,line.start_date
      ,line.end_date
      ,(select * from get_last_connection_by_line_id(line.line_id)) as last_connection
  from line
  join billing_entity be on (be.billing_entity_id = line.billing_entity_id)
 where 1 = 1
   and line.end_date >= (now() - '6 months'::INTERVAL)
 order by line.line_id;
