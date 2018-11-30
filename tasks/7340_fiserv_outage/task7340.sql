select username
      ,acctstarttime
      ,acctstoptime
      ,nasipaddress
  from master_radacct
 where username IN
('4705327118@vzw3g.com',
'4705327129@vzw3g.com',
'4705327131@vzw3g.com',
'4705327141@vzw3g.com',
'4705327142@vzw3g.com',
'4705327145@vzw3g.com',
'4705327159@vzw3g.com',
'4705327169@vzw3g.com',
'4705327152@vzw3g.com',
'4705327120@vzw3g.com',
'4705327133@vzw3g.com',
'4705327140@vzw3g.com',
'4705327161@vzw3g.com',
'4705327157@vzw3g.com',
'4705327174@vzw3g.com',
'4705327123@vzw3g.com',
'4705327121@vzw3g.com',
'4705327124@vzw3g.com',
'4705327138@vzw3g.com',
'4705327132@vzw3g.com',
'4705327137@vzw3g.com',
'4705327143@vzw3g.com',
'4705327168@vzw3g.com',
'4705327177@vzw3g.com',
'4705327154@vzw3g.com',
'4705327160@vzw3g.com',
'4705327146@vzw3g.com',
'4705327164@vzw3g.com',
'4705327147@vzw3g.com',
'4705327155@vzw3g.com',
'4705327153@vzw3g.com',
'4705327175@vzw3g.com',
'4705225362@vzw3g.com',
'4705225492@vzw3g.com',
'4707171054@vzw3g.com')
order by username, acctstarttime;

