-- notes.sql

     var_conn_string := 'hostaddr='||rec_sysparm.ip_address||                                                                                        +
                           ' port='||rec_sysparm.repl_port||                                                                                         +
                         ' dbname='||rec_sysparm.repl_target_db||                                                                                    +
                           ' user='||rec_sysparm.repl_target_username||                                                                              +
                       ' password='||rec_sysparm.repl_target_password ;                                                                              +
 

select ip_address
      ,repl_port
      ,repl_target_db
      ,repl_target_username
      ,repl_target_password  
  from csctlog.system_parameter
 where sprint_flag 
   and hostname = 'atlrad32';
 ip_address  | repl_port | repl_target_db | repl_target_username | repl_target_password 
-------------+-----------+----------------+----------------------+----------------------
 10.16.64.22 | 5450      | radiusdb       | slony                | NULL
(1 row)


'hostaddr=10.16.64.22 port=5450 dbname=radiusdb user=slony password=NULL'


SELECT *
  FROM public.dblink('hostaddr=10.16.64.22 port=5450 dbname=radiusdb user=slony password=NULL'
                       ,'select MAX(radacctid) FROM radiusdb.radacct_start')
    AS rec_type(max_start_radacctid bigint);
ERROR:  password is required
DETAIL:  Non-superuser cannot connect if the server does not request a password.
HINT:  Target server's authentication method must be changed.


