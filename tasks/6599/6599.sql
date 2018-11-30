select rr.value as line_id
      ,sip.static_ip
  from username u
  join radcheck rc on u.username = rc.username
  join radreply rr on rr.username = u.username and rr.attribute = 'Class'
  join line l on l.line_id = rr.value
  join static_ip_pool sip on sip.line_id = rr.value
 where u.username like '%vzw%' 
   and u.billing_entity_id = 537
   and rc.attribute = 'Auth-Type'
   and rc.value = 'Accept'
 order by 1;
