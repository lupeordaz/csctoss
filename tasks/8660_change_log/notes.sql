

select * from unique_identifier where unique_identifier_type = 'ESN HEX' and value in (
'353238060022455',
'353238060021630',
'353238060021952',
'353238060030227',
'353238060025789');
 equipment_id | unique_identifier_type |      value      | notes | date_created | date_modified 
--------------+------------------------+-----------------+-------+--------------+---------------
        41313 | ESN HEX                | 353238060022455 |       | 2016-02-13   | 
        41319 | ESN HEX                | 353238060021630 |       | 2016-02-13   | 
        41317 | ESN HEX                | 353238060021952 |       | 2016-02-13   | 
        41314 | ESN HEX                | 353238060030227 |       | 2016-02-13   | 
        41323 | ESN HEX                | 353238060025789 |       | 2016-02-13   | 
(5 rows)


select *                                                  
  from unique_identifier
 where equipment_id in (
41313,
41319,
41317,
41314,
41323)
order by equipment_id;
 equipment_id | unique_identifier_type |        value         | notes | date_created | date_modified 
--------------+------------------------+----------------------+-------+--------------+---------------
        41313 | ESN DEC                | 89148000004530258311 |       | 2016-02-13   | 
        41313 | ESN HEX                | 353238060022455      |       | 2016-02-13   | 
        41313 | MAC ADDRESS            | 00042D0668CB         |       | 2016-02-13   | 
        41313 | MDN                    | 4703467622           |       | 2016-02-13   | 
        41313 | MIN                    | 4703467622           |       | 2016-02-13   | 
        41313 | SERIAL NUMBER          | 420043               |       | 2016-02-13   | 
        41314 | ESN DEC                | 89148000004530258501 |       | 2016-02-13   | 
        41314 | ESN HEX                | 353238060030227      |       | 2016-02-13   | 
        41314 | MAC ADDRESS            | 00042D0571E9         |       | 2016-02-13   | 
        41314 | MDN                    | 4704093305           |       | 2016-02-13   | 
        41314 | MIN                    | 4704093305           |       | 2016-02-13   | 
        41314 | SERIAL NUMBER          | 356841               |       | 2016-02-13   | 
        41317 | ESN DEC                | 89148000004530258527 |       | 2016-02-13   | 
        41317 | ESN HEX                | 353238060021952      |       | 2016-02-13   | 
        41317 | MAC ADDRESS            | 00042D05E2A2         |       | 2016-02-13   | 
        41317 | MDN                    | 4704019838           |       | 2016-02-13   | 
        41317 | MIN                    | 4704019838           |       | 2016-02-13   | 
        41317 | SERIAL NUMBER          | 385698               |       | 2016-02-13   | 
        41319 | ESN DEC                | 89148000004530258329 |       | 2016-02-13   | 
        41319 | ESN HEX                | 353238060021630      |       | 2016-02-13   | 
        41319 | MAC ADDRESS            | 00042D05E2B8         |       | 2016-02-13   | 
        41319 | MDN                    | 4703229995           |       | 2016-02-13   | 
        41319 | MIN                    | 4703229995           |       | 2016-02-13   | 
        41319 | SERIAL NUMBER          | 385720               |       | 2016-02-13   | 
        41323 | ESN DEC                | 89148000004530252488 |       | 2016-02-13   | 
        41323 | ESN HEX                | 353238060025789      |       | 2016-02-13   | 
        41323 | MAC ADDRESS            | 00042D05977F         |       | 2016-02-13   | 
        41323 | MDN                    | 4703818060           |       | 2016-02-13   | 
        41323 | MIN                    | 4703818060           |       | 2016-02-13   | 
        41323 | SERIAL NUMBER          | 366463               |       | 2016-02-13   | 
(30 rows)

--

csctoss=# \d+ unique_identifier
                                        Table "csctoss.unique_identifier"
         Column         |  Type   |              Modifiers               | Storage  | Stats target | Description 
------------------------+---------+--------------------------------------+----------+--------------+-------------
 equipment_id           | integer | not null                             | plain    |              | 
 unique_identifier_type | text    | not null                             | extended |              | 
 value                  | text    | not null                             | extended |              | 
 notes                  | text    |                                      | extended |              | 
 date_created           | date    | not null default ('now'::text)::date | plain    |              | 
 date_modified          | date    |                                      | plain    |              | 
Indexes:
    "unique_identifier_pkey" PRIMARY KEY, btree (equipment_id, unique_identifier_type)
    "unique_identifier_type_value_uk" UNIQUE, btree (unique_identifier_type, value)
    "unique_identifier_value_idx" btree (value)
Foreign-key constraints:
    "unique_identifier_equipment_id_fk" FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id)
    "unique_identifier_unique_identifier_type_fk" FOREIGN KEY (unique_identifier_type) REFERENCES unique_identifier_type(unique_identifier_type)
Triggers:
    _csctoss_repl_logtrigger_1200 AFTER INSERT OR DELETE OR UPDATE ON unique_identifier FOR EACH ROW EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_repl', '1200', 'kkvvvv')
    unique_identifier_changelog BEFORE INSERT OR DELETE OR UPDATE ON unique_identifier FOR EACH ROW EXECUTE PROCEDURE change_log('change_log', ',')
Has OIDs: no

--

csctoss=# \d+ change_log
                                                                  Table "csctoss.change_log"
      Column      |           Type           |                               Modifiers                                | Storage  | Stats target | D
escription 
------------------+--------------------------+------------------------------------------------------------------------+----------+--------------+--
-----------
 change_log_id    | integer                  | not null default nextval('csctoss.change_log_change_log_id_seq'::text) | plain    |              | 
 change_timestamp | timestamp with time zone | not null default ('now'::text)::timestamp(6) with time zone            | plain    |              | 
 db_user          | text                     | not null default "session_user"()                                      | extended |              | 
 staff_id         | integer                  | not null                                                               | plain    |              | 
 change_type      | character(1)             | not null                                                               | extended |              | 
 table_name       | text                     | not null                                                               | extended |              | 
 primary_key      | text                     | not null                                                               | extended |              | 
 column_name      | text                     |                                                                        | extended |              | 
 previous_value   | text                     |                                                                        | extended |              | 
Indexes:
    "change_log_pkey" PRIMARY KEY, btree (change_log_id)
Check constraints:
    "change_log_change_type_check" CHECK (change_type = 'I'::bpchar OR change_type = 'U'::bpchar OR change_type = 'D'::bpchar)
Foreign-key constraints:
    "change_log_staff_id_fk" FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
Triggers:
    _csctoss_repl_logtrigger_1030 AFTER INSERT OR DELETE OR UPDATE ON change_log FOR EACH ROW EXECUTE PROCEDURE _csctoss_repl.logtrigger('_csctoss_
repl', '1030', 'kvvvvvvvv')
Has OIDs: no

--

SELECT * 
  FROM change_log 
 WHERE table_name = '"csctoss"."unique_identifier"' 
   AND primary_key LIKE '41313,M%' 
   AND column_name <> 'MAC ADDRESS' 
 ORDER BY change_timestamp;
 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |          table_name           | primary_key | column_name | previous_value 
---------------+-------------------------------+---------------+----------+-------------+-------------------------------+-------------+-------------+----------------
       3605024 | 2018-09-20 18:16:16.256018+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41313,MDN   | value       | 4702597317
       3605025 | 2018-09-20 18:16:34.018666+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41313,MIN   | value       | 4049892858

ESN Hex:    353238060022455
Prev. MDN:  4702597317
Prev. MIN:  4049892858

 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |          table_name           | primary_key | column_name | previous_value 
---------------+-------------------------------+---------------+----------+-------------+-------------------------------+-------------+-------------+----------------
       3605036 | 2018-09-20 18:23:46.960214+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41314,MDN   | value       | 4702597325
       3605037 | 2018-09-20 18:24:01.628748+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41314,MIN   | value       | 4049892850

ESN Hex:    353238060030227
Prev. MDN:  4702597325
Prev. MIN:  4049892850

 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |          table_name           | primary_key | column_name | previous_value 
---------------+-------------------------------+---------------+----------+-------------+-------------------------------+-------------+-------------+----------------
       3605028 | 2018-09-20 18:18:42.070627+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41317,MDN   | value       | 4702597507
       3605029 | 2018-09-20 18:18:59.285889+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41317,MIN   | value       | 4049892663

ESN Hex:    353238060021952
Prev. MDN:  4702597507
Prev. MIN:  4049892663

 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |          table_name           | primary_key | column_name | previous_value 
---------------+-------------------------------+---------------+----------+-------------+-------------------------------+-------------+-------------+----------------
       3605006 | 2018-09-20 18:13:38.552823+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41319,MDN   | value       | 4702597283
       3605007 | 2018-09-20 18:14:15.703429+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41319,MIN   | value       | 4049892892

ESN Hex:    353238060021630
Prev. MDN:  4702597283
Prev. MIN:  4049892892

 change_log_id |       change_timestamp        |    db_user    | staff_id | change_type |          table_name           | primary_key | column_name | previous_value 
---------------+-------------------------------+---------------+----------+-------------+-------------------------------+-------------+-------------+----------------
       3605032 | 2018-09-20 18:21:41.344387+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41323,MDN   | value       | 4702597300
       3605033 | 2018-09-20 18:21:55.461086+00 | csctoss_owner |        3 | U           | "csctoss"."unique_identifier" | 41323,MIN   | value       | 4049892875

ESN Hex:    353238060025789
Prev. MDN:  4702597300
Prev. MIN:  4049892875
