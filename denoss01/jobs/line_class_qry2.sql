select line.billing_entity_id
                  ,bent.name
                  ,line.line_id
                  ,coalesce((select value 
                               from radreply 
                              where attribute = 'Class' 
                                and username = line.radius_username),'Class Missing') as class
                  ,line.active_flag
                  ,line.start_date as line_start
                  ,line.end_date as line_end
                  ,line.radius_username
                  ,line.line_label
              from line
              join billing_entity bent using (billing_entity_id)
             where line.active_flag
               and not exists (select true
                                 from csctoss.radreply
                                where attribute = 'Class'
                                  and username = line.radius_username)
               and exists (select true
                             from line_equipment
                            where line_id = line.line_id
                              and end_date is null)
                         order by line.line_id;
