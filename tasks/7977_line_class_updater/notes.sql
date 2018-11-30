"-----------------------------------------------------" 
"THE FOLLOWING LINES HAVE NO CLASS DEFINED IN RADREPLY" 
"-----------------------------------------------------" 

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
-[ RECORD 1 ]-----+-----------------------
billing_entity_id | 583
name              | JLM Entertainment LLC
line_id           | 46248
class             | Class Missing
active_flag       | t
line_start        | 2017-12-20 00:00:00+00
line_end          | 2018-07-19 00:00:00+00
radius_username   | 
line_label        | 


csctoss=# select * from line where line_id = 46248;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 46248
calling_station_id        | 
line_assignment_type      | CUSTOMER ASSIGNED
billing_entity_id         | 583
logical_apn               | 
disabled_apn              | 
contact_id                | 
order_id                  | 
employee_id               | 
billing_entity_address_id | 625
active_flag               | t
line_label                | 
start_date                | 2017-12-20 00:00:00+00
end_date                  | 2018-07-19 00:00:00+00
date_created              | 2017-12-20 00:00:00+00
radius_username           | 
radius_password           | 
radius_auth_type          | 
static_ip_address         | 
ip_pool                   | 
proxy_access              | 
session_timeout_seconds   | 
idle_timeout_seconds      | 
primary_dns               | 
secondary_dns             | 
current_plan_id           | 
previous_line_id          | 
notes                     | SO-11958
additional_info           | 

csctoss=# select * from line_equipment where line_id = 46248;
-[ RECORD 1 ]-------------+-----------
line_id                   | 46248
equipment_id              | 42363
start_date                | 2018-06-25
end_date                  | 2018-06-25
billing_entity_address_id | 625
ship_date                 | 
install_date              | 
installed_by              | 
-[ RECORD 2 ]-------------+-----------
line_id                   | 46248
equipment_id              | 42601
start_date                | 2018-06-25
end_date                  | 2018-07-19
billing_entity_address_id | 625
ship_date                 | 
install_date              | 
installed_by              | 
-[ RECORD 3 ]-------------+-----------
line_id                   | 46248
equipment_id              | 43225 
start_date                | 2018-06-25
end_date                  | 
billing_entity_address_id | 625
ship_date                 | 
install_date              | 
installed_by              | 
-[ RECORD 4 ]-------------+-----------
line_id                   | 46248
equipment_id              | 43343
start_date                | 2017-12-20
end_date                  | 2018-06-25
billing_entity_address_id | 625
ship_date                 | 
install_date              | 
installed_by              | 

--------

csctoss=# select * from line_equipment where equipment_id = 43225;
-[ RECORD 1 ]-------------+-----------
line_id                   | 46133
equipment_id              | 43225
start_date                | 2017-11-10
end_date                  | 2018-03-06
billing_entity_address_id | 250
ship_date                 | 
install_date              | 
installed_by              | 
-[ RECORD 2 ]-------------+-----------
line_id                   | 46248
equipment_id              | 43225
start_date                | 2018-06-25
end_date                  | 
billing_entity_address_id | 625
ship_date                 | 
install_date              | 
installed_by              | 

csctoss=# select * from line where line_id = 46133;
-[ RECORD 1 ]-------------+-----------------------
line_id                   | 46133
calling_station_id        | 
line_assignment_type      | CUSTOMER ASSIGNED
billing_entity_id         | 168
logical_apn               | 
disabled_apn              | 
contact_id                | 
order_id                  | 
employee_id               | 
billing_entity_address_id | 250
active_flag               | t
line_label                | 352613070331560
start_date                | 2017-11-10 00:00:00+00
end_date                  | 
date_created              | 2017-11-10 00:00:00+00
radius_username           | 4706266496@vzw3g.com
radius_password           | 
radius_auth_type          | 
static_ip_address         | 
ip_pool                   | 
proxy_access              | 
session_timeout_seconds   | 
idle_timeout_seconds      | 
primary_dns               | 
secondary_dns             | 
current_plan_id           | 
previous_line_id          | 
notes                     | SO-11885
additional_info           | 

--
                                              Table "csctoss.change_log"
      Column      |           Type           |                               Modifiers                                
------------------+--------------------------+------------------------------------------------------------------------
 change_log_id    | integer                  | not null default nextval('csctoss.change_log_change_log_id_seq'::text)
 change_timestamp | timestamp with time zone | not null default ('now'::text)::timestamp(6) with time zone
 db_user          | text                     | not null default "session_user"()
 staff_id         | integer                  | not null
 change_type      | character(1)             | not null
 table_name       | text                     | not null
 primary_key      | text                     | not null
 column_name      | text                     | 
 previous_value   | text                     | 
Indexes:
    "change_log_pkey" PRIMARY KEY, btree (change_log_id)
Check constraints:
    "change_log_change_type_check" CHECK (change_type = 'I'::bpchar OR change_type = 'U'::bpchar OR change_type = 'D'::bpchar)
Foreign-key constraints:
    "change_log_staff_id_fk" FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
Triggers:
    _csctoss_repl_logtrigger_1030 AFTER INSERT OR DELETE OR UPDATE ON change_log FOR EACH ROW EXECUTE 
  PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1030', 'kvvvvvvvv')

select change_timestamp
      ,db_user
      ,staff_id
      ,table_name
      ,primary_key
      ,previous_value
  from change_log
 where table_name = '"csctoss"."line"'
   and change_type = 'U'
   and column_name = 'end_date'
   and change_timestamp >= '2018-07-19'
   and change_timestamp < '2018-07-20';
 order by change_timestamp;

       change_timestamp        |    db_user    | staff_id |    table_name    | primary_key | previous_value 
-------------------------------+---------------+----------+------------------+-------------+----------------
 2018-07-19 14:39:12.156043+00 | postgres      |        3 | "csctoss"."line" | 13669       | 
 2018-07-19 15:56:41.081347+00 | postgres      |        3 | "csctoss"."line" | 12318       | 
 2018-07-19 17:02:24.743747+00 | postgres      |        3 | "csctoss"."line" | 17677       | 
 2018-07-19 17:42:13.510231+00 | csctoss_owner |        3 | "csctoss"."line" | 7314        | 
 2018-07-19 17:48:32.187736+00 | csctoss_owner |        3 | "csctoss"."line" | 7536        | 
 2018-07-19 17:49:23.852462+00 | postgres      |        3 | "csctoss"."line" | 5288        | 
 2018-07-19 17:49:59.944881+00 | postgres      |        3 | "csctoss"."line" | 27643       | 
 2018-07-19 17:50:33.40338+00  | postgres      |        3 | "csctoss"."line" | 35230       | 
 2018-07-19 17:51:02.347493+00 | postgres      |        3 | "csctoss"."line" | 35401       | 
 2018-07-19 17:59:03.514117+00 | csctoss_owner |        3 | "csctoss"."line" | 7539        | 
 2018-07-19 17:59:16.968265+00 | csctoss_owner |        3 | "csctoss"."line" | 7553        | 
 2018-07-19 17:59:32.348316+00 | csctoss_owner |        3 | "csctoss"."line" | 9167        | 
 2018-07-19 17:59:45.7531+00   | csctoss_owner |        3 | "csctoss"."line" | 9201        | 
 2018-07-19 18:00:05.765287+00 | csctoss_owner |        3 | "csctoss"."line" | 13339       | 
 2018-07-19 18:00:42.046808+00 | csctoss_owner |        3 | "csctoss"."line" | 13341       | 
 2018-07-19 18:00:59.286888+00 | csctoss_owner |        3 | "csctoss"."line" | 14758       | 
 2018-07-19 18:01:19.144297+00 | csctoss_owner |        3 | "csctoss"."line" | 14850       | 
 2018-07-19 18:01:43.650534+00 | csctoss_owner |        3 | "csctoss"."line" | 14854       | 
 2018-07-19 18:02:12.209727+00 | csctoss_owner |        3 | "csctoss"."line" | 16558       | 
 2018-07-19 18:02:26.992969+00 | csctoss_owner |        3 | "csctoss"."line" | 16563       | 
 2018-07-19 18:02:37.767301+00 | csctoss_owner |        3 | "csctoss"."line" | 17356       | 
 2018-07-19 18:02:50.738028+00 | csctoss_owner |        3 | "csctoss"."line" | 17358       | 
 2018-07-19 18:03:04.943283+00 | csctoss_owner |        3 | "csctoss"."line" | 17362       | 
 2018-07-19 18:03:16.158773+00 | csctoss_owner |        3 | "csctoss"."line" | 17363       | 
 2018-07-19 18:03:28.107189+00 | csctoss_owner |        3 | "csctoss"."line" | 17373       | 
 2018-07-19 18:03:38.725532+00 | csctoss_owner |        3 | "csctoss"."line" | 17374       | 
 2018-07-19 18:03:49.097307+00 | csctoss_owner |        3 | "csctoss"."line" | 17375       | 
 2018-07-19 18:03:58.067258+00 | csctoss_owner |        3 | "csctoss"."line" | 17383       | 
 2018-07-19 18:04:07.517744+00 | csctoss_owner |        3 | "csctoss"."line" | 17440       | 
 2018-07-19 18:04:18.654191+00 | csctoss_owner |        3 | "csctoss"."line" | 17447       | 
 2018-07-19 18:04:31.321963+00 | csctoss_owner |        3 | "csctoss"."line" | 17450       | 
 2018-07-19 18:04:42.864518+00 | csctoss_owner |        3 | "csctoss"."line" | 17451       | 
 2018-07-19 18:04:52.402207+00 | csctoss_owner |        3 | "csctoss"."line" | 18322       | 
 2018-07-19 18:05:05.234108+00 | csctoss_owner |        3 | "csctoss"."line" | 18329       | 
 2018-07-19 18:05:15.502892+00 | csctoss_owner |        3 | "csctoss"."line" | 18647       | 
 2018-07-19 18:05:26.413061+00 | csctoss_owner |        3 | "csctoss"."line" | 19542       | 
 2018-07-19 18:05:39.499801+00 | csctoss_owner |        3 | "csctoss"."line" | 20129       | 
 2018-07-19 18:05:50.917642+00 | csctoss_owner |        3 | "csctoss"."line" | 20131       | 
 2018-07-19 18:06:00.118295+00 | csctoss_owner |        3 | "csctoss"."line" | 20132       | 
 2018-07-19 18:06:09.618362+00 | csctoss_owner |        3 | "csctoss"."line" | 20677       | 
 2018-07-19 18:06:35.417636+00 | csctoss_owner |        3 | "csctoss"."line" | 20680       | 
 2018-07-19 18:06:46.276981+00 | csctoss_owner |        3 | "csctoss"."line" | 20909       | 
 2018-07-19 18:06:57.459458+00 | csctoss_owner |        3 | "csctoss"."line" | 20916       | 
 2018-07-19 18:07:07.929024+00 | csctoss_owner |        3 | "csctoss"."line" | 21344       | 
 2018-07-19 18:07:24.65457+00  | csctoss_owner |        3 | "csctoss"."line" | 21585       | 
 2018-07-19 18:07:44.073783+00 | csctoss_owner |        3 | "csctoss"."line" | 21588       | 
 2018-07-19 18:07:55.537604+00 | csctoss_owner |        3 | "csctoss"."line" | 21592       | 
 2018-07-19 18:08:06.566384+00 | csctoss_owner |        3 | "csctoss"."line" | 21594       | 
 2018-07-19 18:08:16.990369+00 | csctoss_owner |        3 | "csctoss"."line" | 21991       | 
 2018-07-19 18:08:27.668906+00 | csctoss_owner |        3 | "csctoss"."line" | 21992       | 
 2018-07-19 18:08:38.272648+00 | csctoss_owner |        3 | "csctoss"."line" | 22249       | 
 2018-07-19 18:21:04.687426+00 | csctoss_owner |        3 | "csctoss"."line" | 23523       | 
 2018-07-19 18:21:16.403752+00 | csctoss_owner |        3 | "csctoss"."line" | 24314       | 
 2018-07-19 18:21:29.847923+00 | csctoss_owner |        3 | "csctoss"."line" | 24315       | 
 2018-07-19 18:21:41.069352+00 | csctoss_owner |        3 | "csctoss"."line" | 24316       | 
 2018-07-19 18:21:57.560814+00 | csctoss_owner |        3 | "csctoss"."line" | 24317       | 
 2018-07-19 18:22:06.986536+00 | csctoss_owner |        3 | "csctoss"."line" | 24320       | 
 2018-07-19 18:22:18.06354+00  | csctoss_owner |        3 | "csctoss"."line" | 24321       | 
 2018-07-19 18:22:28.560159+00 | csctoss_owner |        3 | "csctoss"."line" | 24322       | 
 2018-07-19 18:22:40.064121+00 | csctoss_owner |        3 | "csctoss"."line" | 26458       | 
 2018-07-19 18:22:55.576001+00 | csctoss_owner |        3 | "csctoss"."line" | 26697       | 
 2018-07-19 18:23:12.604953+00 | csctoss_owner |        3 | "csctoss"."line" | 26700       | 
 2018-07-19 18:23:35.639453+00 | csctoss_owner |        3 | "csctoss"."line" | 26709       | 
 2018-07-19 18:23:50.895787+00 | csctoss_owner |        3 | "csctoss"."line" | 26732       | 
 2018-07-19 18:25:27.094435+00 | csctoss_owner |        3 | "csctoss"."line" | 26740       | 
 2018-07-19 18:25:37.6015+00   | csctoss_owner |        3 | "csctoss"."line" | 26743       | 
 2018-07-19 18:25:49.696309+00 | csctoss_owner |        3 | "csctoss"."line" | 27111       | 
 2018-07-19 18:26:01.841019+00 | csctoss_owner |        3 | "csctoss"."line" | 38463       | 
 2018-07-19 18:26:11.957689+00 | csctoss_owner |        3 | "csctoss"."line" | 38627       | 
 2018-07-19 18:26:24.498392+00 | csctoss_owner |        3 | "csctoss"."line" | 42679       | 
 2018-07-19 18:26:35.292276+00 | csctoss_owner |        3 | "csctoss"."line" | 42681       | 
 2018-07-19 18:26:43.788747+00 | csctoss_owner |        3 | "csctoss"."line" | 43932       | 
 2018-07-19 18:26:59.319748+00 | csctoss_owner |        3 | "csctoss"."line" | 44274       | 
 2018-07-19 18:27:11.471983+00 | csctoss_owner |        3 | "csctoss"."line" | 44289       | 
 2018-07-19 18:27:23.900873+00 | csctoss_owner |        3 | "csctoss"."line" | 44290       | 
 2018-07-19 18:27:35.809294+00 | csctoss_owner |        3 | "csctoss"."line" | 44295       | 
 2018-07-19 18:27:44.968199+00 | csctoss_owner |        3 | "csctoss"."line" | 44316       | 
 2018-07-19 18:27:54.492827+00 | csctoss_owner |        3 | "csctoss"."line" | 44323       | 
 2018-07-19 19:09:34.668041+00 | csctoss_owner |        3 | "csctoss"."line" | 46529       | 
 2018-07-19 19:35:12.572185+00 | csctoss_owner |        3 | "csctoss"."line" | 46528       | 
 2018-07-19 19:46:13.307974+00 | csctoss_owner |        3 | "csctoss"."line" | 46737       | 
 2018-07-19 21:39:54.785842+00 | csctoss_owner |        3 | "csctoss"."line" | 46557       | 


 2018-07-19 22:33:57.051468+00 | csctoss_owner |        3 | "csctoss"."line" | 46248       | 


(83 rows)

select l.line_id                                                         
        ,le.equipment_id
        ,l.radius_username
        ,uim.value as mac
        ,uis.value as serialno
        ,uie.value as esn_hex
    from line_equipment le
    join line l on l.line_id = le.line_id
    join unique_identifier uim on le.equipment_id = uim.equipment_id and uim.unique_identifier_type = 'MAC ADDRESS'
    join unique_identifier uie on le.equipment_id = uie.equipment_id and uie.unique_identifier_type = 'ESN HEX'
    join unique_identifier uis on le.equipment_id = uis.equipment_id and uis.unique_identifier_type = 'SERIAL NUMBER'
   where uis.value = '

