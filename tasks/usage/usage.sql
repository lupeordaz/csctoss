

select username
      ,acctsessionid
      ,acctstarttime
      ,acctstoptime
      ,acctinputoctets
      ,acctoutputoctets
  from master_radacct
 where ((acctstarttime >= '2018-03-01') AND (acctstarttime <= '2018-05-31'))
   AND username in ('9172721464@tsp18.sprintpcs.com','9172430949@tsp17.sprintpcs.com')
 order by username, acctstarttime desc;





select username, SUM(acctinputoctets + acctoutputoctets)
  from master_radacct
 where username in ('9172721464@tsp18.sprintpcs.com','9172430949@tsp17.sprintpcs.com')
   and ((acctstarttime >= '2018-03-01') AND (acctstarttime <= '2018-05-31'))
 group by username;
            username            |   sum    
--------------------------------+----------
 9172430949@tsp17.sprintpcs.com | 17265755
(1 row)



select username, (SUM(acctinputoctets + acctoutputoctets)/1024) as total_kb
  from master_radacct
 where username in ('9172721464@tsp18.sprintpcs.com','9172430949@tsp17.sprintpcs.com')
   and ((acctstarttime >= '2018-03-01') AND (acctstarttime <= '2018-05-31'))
 group by username;

            username            |      total_kb      
--------------------------------+--------------------
 9172430949@tsp17.sprintpcs.com | 16861.088867187500
(1 row)





