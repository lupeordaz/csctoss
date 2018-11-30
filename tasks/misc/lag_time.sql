

[postgres@denoss01 jobs]$ psql -U postgres 
SET
Welcome to psql 8.0.14, the PostgreSQL interactive terminal.

Type:  \copyright for distribution terms
       \h for help with SQL commands
       \? for help with psql commands
       \g or terminate with semicolon to execute query
       \q to quit


SELECT
  relname, (relpages * 8) / 1024 AS size_mb
FROM pg_class
ORDER BY relpages DESC
LIMIT 20;

                relname                | size_mb 
---------------------------------------+---------
 line_usage_day                        |    6173
 line_usage_day_2012_2014              |    1999
 sl_seqlog_idx                         |    1854
 line_usage_day_pkey                   |    1848
 line_usage_day_history                |    1313
 line_usage_day_line_id_idx            |    1191
 pg_toast_107094332                    |    1173
 line_usage_day_usage_date_idx         |    1107
 attachments                           |     383
 change_log                            |     333
 mrad                                  |     271
 line_usage_day_pkey1                  |     244
 sessions                              |     230
 line_usage_month                      |     200
 line_usage_day_history_line_id_idx    |     195
 line_usage_day_history_usage_date_idx |     195
 api_request_log                       |     106
 pg_trigger_tgrelid_tgname_index       |      99
 sessions_pkey                         |      98
 pg_trigger_tgconstrname_index         |      93
(20 rows)


csctoss=# set timezone to MST7MDT;

SET
csctoss=#
csctoss=# select * from _csctoss_repl.sl_status ;
 st_origin | st_received | st_last_event |      st_last_event_ts      | st_last_received |    st_last_received_ts     | st_last_received_event_ts  | st_lag_num_events |   st_lag_time    
-----------+-------------+---------------+----------------------------+------------------+----------------------------+----------------------------+-------------------+------------------
       201 |         101 |      15089730 | 2018-05-03 22:34:38.732639 |         15089730 | 2018-05-03 22:34:42.462173 | 2018-05-03 22:34:38.732639 |                 0 | -05:59:51.997789
       201 |         301 |      15089730 | 2018-05-03 22:34:38.732639 |         15089730 | 2018-05-03 22:34:38.838889 | 2018-05-03 22:34:38.732639 |                 0 | -05:59:51.997789
(2 rows)

csctoss=# show timezone
csctoss-# ;
 TimeZone 
----------
 mst7mdt
(1 row)
