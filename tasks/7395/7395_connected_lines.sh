select p.radius_username
      ,p.line_id
      ,p.static_ip_address
  from portal_active_lines_vw p
 where p.is_connected = 'YES'
 order by 2,1;
