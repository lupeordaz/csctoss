

usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(142, '68.31.122.77', '68.31.122.77', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1
usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(143, '68.31.122.78', '68.31.122.77', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1
usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(144, '68.31.126.78', '68.31.126.78', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1
usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(145, '68.31.46.77', '68.31.46.77', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1
usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(146, '68.31.126.77', '68.31.126.77', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1
usccsprint=> INSERT into nas (id, nasname, shortname, type, ports, secret)  
usccsprint->  values(144, '68.31.46.78', '68.31.46.78', 'other', 1701, 'Spr1ntC0untour');
INSERT 0 1


usccsprint=> select * from nas order by 1;
 id  |     nasname     |        shortname         | type  | ports |     secret     | community | description 
-----+-----------------+--------------------------+-------+-------+----------------+-----------+-------------
   1 | 127.0.0.1       | localhost                | other |  1701 | testing123     |           | 
   2 | 10.17.0.1       | denlns01                 | cisco |  1701 | crazybob       |           | 
.
.
.

 142 | 68.31.122.77    | 68.31.122.77             | other |  1701 | Spr1ntC0untour |           | 
 143 | 68.31.122.78    | 68.31.122.78             | other |  1701 | Spr1ntC0untour |           | 
 144 | 68.31.126.78    | 68.31.126.78             | other |  1701 | Spr1ntC0untour |           | 
 145 | 68.31.46.77     | 68.31.46.77              | other |  1701 | Spr1ntC0untour |           | 
 146 | 68.31.126.77    | 68.31.126.77             | other |  1701 | Spr1ntC0untour |           | 
 147 | 68.31.46.78     | 68.31.46.78              | other |  1701 | Spr1ntC0untour |           | 
(106 rows)

