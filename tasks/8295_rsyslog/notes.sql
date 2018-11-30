[gordaz@cctlix03 8295_mysql]$ ssh gordaz@10.17.67.14
Password: 
Password: 
Last failed login: Wed Aug 22 20:02:55 EDT 2018 from 10.17.242.42 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Wed Aug 22 19:53:55 2018 from 10.17.242.42
[gordaz@denmgt04 ~]$ mysql -u gordaz
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 13
Server version: 5.5.60-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test               |
+--------------------+
2 rows in set (0.00 sec)

MariaDB [(none)]> use information_schema;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [information_schema]> show tables;
+---------------------------------------+
| Tables_in_information_schema          |
+---------------------------------------+
| CHARACTER_SETS                        |
| CLIENT_STATISTICS                     |
| COLLATIONS                            |
| COLLATION_CHARACTER_SET_APPLICABILITY |
| COLUMNS                               |
| COLUMN_PRIVILEGES                     |
| ENGINES                               |
| EVENTS                                |
| FILES                                 |
| GLOBAL_STATUS                         |
| GLOBAL_VARIABLES                      |
| INDEX_STATISTICS                      |
| KEY_CACHES                            |
| KEY_COLUMN_USAGE                      |
| PARAMETERS                            |
| PARTITIONS                            |
| PLUGINS                               |
| PROCESSLIST                           |
| PROFILING                             |
| REFERENTIAL_CONSTRAINTS               |
| ROUTINES                              |
| SCHEMATA                              |
| SCHEMA_PRIVILEGES                     |
| SESSION_STATUS                        |
| SESSION_VARIABLES                     |
| STATISTICS                            |
| TABLES                                |
| TABLESPACES                           |
| TABLE_CONSTRAINTS                     |
| TABLE_PRIVILEGES                      |
| TABLE_STATISTICS                      |
| TRIGGERS                              |
| USER_PRIVILEGES                       |
| USER_STATISTICS                       |
| VIEWS                                 |
| INNODB_CMPMEM_RESET                   |
| INNODB_RSEG                           |
| INNODB_UNDO_LOGS                      |
| INNODB_CMPMEM                         |
| INNODB_SYS_TABLESTATS                 |
| INNODB_LOCK_WAITS                     |
| INNODB_INDEX_STATS                    |
| INNODB_CMP                            |
| INNODB_CMP_RESET                      |
| INNODB_CHANGED_PAGES                  |
| INNODB_BUFFER_POOL_PAGES              |
| INNODB_TRX                            |
| INNODB_BUFFER_POOL_PAGES_INDEX        |
| INNODB_LOCKS                          |
| INNODB_BUFFER_POOL_PAGES_BLOB         |
| INNODB_SYS_TABLES                     |
| INNODB_SYS_FIELDS                     |
| INNODB_SYS_COLUMNS                    |
| INNODB_SYS_STATS                      |
| INNODB_SYS_FOREIGN                    |
| INNODB_SYS_INDEXES                    |
| XTRADB_ADMIN_COMMAND                  |
| INNODB_TABLE_STATS                    |
| INNODB_SYS_FOREIGN_COLS               |
| INNODB_BUFFER_PAGE_LRU                |
| INNODB_BUFFER_POOL_STATS              |
| INNODB_BUFFER_PAGE                    |
+---------------------------------------+
62 rows in set (0.00 sec)

MariaDB [information_schema]> quit
Bye
[gordaz@denmgt04 ~]$ 

--
	./usr/bin
	./usr/lib/debug/usr/bin
	./usr/lib/debug/bin
	./usr/share/locale/bin
	./usr/local/bin
	./bin

10.82.8.35
10.82.8.32
10.82.8.26
10.82.8.28
10.82.8.29
10.82.8.12
10.82.8.15
10.80.13.92 

  NetScreen device_id=dencfw01  [Root]system-notification-00257(traffic): start_time="2018-08-22 09:05:54" duration=60 policy_id=1623 service=IKE proto=17 src zone=private_atm dst zone=Untrust action=Permit sent=684 rcvd=589 src=10.82.8.35 dst=209.99.106.134 src_port=57349 dst_port=500 src-xlated ip=74.115.157.233 port=48363 dst-xlated ip=209.99.106.134 port=500 session_id=48015 reason=Close - AGE OUT



select substr(Message,75,32)  as start_time
      ,substr(Message,120,14) as policy_id
      ,substr(Message,208,17) as sent_recv
      ,substr(Message,226,14) as src
  from SystemEvents
 where Message like '%policy_id=1623%'
   and ((Message like '%src=10.82.8.35%') OR
        (Message like '%src=10.82.8.32%') OR
        (Message like '%src=10.82.8.26%') OR
        (Message like '%src=10.82.8.28%') OR
        (Message like '%src=10.82.8.29%') OR
        (Message like '%src=10.82.8.12%') OR
        (Message like '%src=10.82.8.15%') OR
        (Message like '%src=10.80.13.92%'))
   and Message like '%policy_id=1623%';



----





select substring(Message, (locate('src=', Message) + 4), 10) as source
  from SystemEvents
 where Message like '%policy_id=1623%'
   and ((Message like '%src=10.82.8.35%') OR
        (Message like '%src=10.82.8.35%'))
;

+------------+
| source     |
+------------+
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
| 10.82.8.35 |
+------------+
19 rows in set (1 min 27.92 sec)

--

select substring(Message, (locate('start_time=', Message) + 11), 
                ((locate('duration=', Message) - 1) - (locate('start_time=', Message) + 11))) as start_time
      ,substring(Message, (locate('src=', Message) + 4), 
                ((locate('dst=', Message) - 1) - (locate('src=', Message) + 4))) as source
      ,substring(Message, (locate('sent=', Message) + 5),
                ((locate('rcvd', Message) - 1) - (locate('sent=', Message) + 5))) as sent
      ,substring(Message, (locate('rcvd=', Message) + 5),
                ((locate('src=', Message) - 1) - (locate('rcvd=', Message) + 5))) as rcvd
  from SystemEvents  
 where Message like '%policy_id=1623%'
   and ReceivedAt >= DATE_SUB(current_date, INTERVAL 30 MINUTE)
 order by 1
 limit 30;

--

CREATE TABLE IF NOT EXISTS testalert (
    source_ip    text(16),
    start_date  DATE,
    sent        INT,
    rcvd        INT
)  ENGINE=INNODB;


'10.82.8.35',
'10.82.8.32',
'10.82.8.26',
'10.82.8.28',
'10.82.8.29',
'10.82.8.12',
'10.82.8.15',
'10.80.13.92' 

--

Config files:  /etc/rsyslog.conf and /etc/rsyslog.d/*.conf


--

rsyslogd -N1

rsyslogd: version 8.24.0, config validation run (level 1), master config /etc/rsyslog.conf

rsyslogd: invalid or yet-unknown config file command 'mmnormalizeUseRawMSG' - have you forgotten to load a module? 
    [v8.24.0 try http://www.rsyslog.com/e/3003 ]

rsyslogd: invalid or yet-unknown config file command 'mmnormalizeRuleBase' - have you forgotten to load a module? 
    [v8.24.0 try http://www.rsyslog.com/e/3003 ]

rsyslogd: error during parsing file /etc/rsyslog.conf, on or before line 30: errors occured in file '/etc/rsyslog.conf' around line 30 
    [v8.24.0 try http://www.rsyslog.com/e/2207 ]

rsyslogd: module 'ommysql' already in this config, cannot be added  
    [v8.24.0 try http://www.rsyslog.com/e/2221 ]

rsyslogd:  Could not find template 0 'database' - action disabled 
    [v8.24.0 try http://www.rsyslog.com/e/3003 ]

rsyslogd: error during parsing file /etc/rsyslog.d/rds.conf, on or before line 3: errors occured in file '/etc/rsyslog.d/rds.conf' around line 3 
    [v8.24.0 try http://www.rsyslog.com/e/2207 ]

rsyslogd: unknown facility name "ommysql" 
    [v8.24.0]

rsyslogd: user name 'mmnormal...' too long - ignored 
    [v8.24.0]

rsyslogd: error during parsing file /etc/rsyslog.d/rds.conf, on or before line 22: warnings occured in file '/etc/rsyslog.d/rds.conf' around line 22 
    [v8.24.0 try http://www.rsyslog.com/e/2207 ]

rsyslogd: imudp: ruleset 'linux' for *:13515 not found - using default ruleset instead 
    [v8.24.0]
*/

CREATE TABLE IF NOT EXISTS nagalert (
starttime         datetime,
host              varchar(100),
device            text,
fw_type           varchar(15),
device_id         varchar(15),
filler1           varchar(50),
fwstart_time      datetime,
duration          INT,
policy_id         text,
service           text,
proto             INT,
src_zone          varchar(12),
dst_zone          varchar(12),
action            text,
sent              INT,
rcvd              INT,
src_ip            text(16),
dst_ip            text(16),
src_port          INT,
dst_port          INT,
srx_xtranslateip  varchar(12),
srxxlatedport     INT,
dst_xtranslateip  INT,
dstxlatedport     INT,
session_id        INT,
reason            VARCHAR(20)
)  ENGINE=INNODB;


$template database,"insert into nagalert (source_ip, start_date, sent, rcvd) 
                                  values ('src:%$!ipv4%'
                                          '%$!fwstart_time%'
                                          '%$!sent%'
                                          '%$!rcvd%')",SQL



starttime,
host,
device,
fw_type,
device_id,
filler1,
fwstart_time,
duration,
policy_id,
service,
proto,
src_zone,
dst_zone,
action,
sent,
rcvd,
src_ip,
dst_ip,
src_port,
dst_port,
srx_xtranslateip,
srxxlatedport,
dst_xtranslateip,
dstxlatedport,
session_id,
reason



$template database,"insert into nagalert (starttime, host, device, fw_type, device_id, filler1, fwstart_time, duration, policy_id, service, proto, src_zone, dst_zone, action, sent, rcvd, src_ip, dst_ip, src_port, dst_port, srx_xtranslateip, srxxlatedport, dst_xtranslateip, dstxlatedport, session_id, reason) values ('%$!start_time%''%$!host%''%$!device%''%$!fw_type%''%$!device_id%''%$!filler1%''%$!fwstart_time%''%$!duration%''%$!policy_id%''%$!service%''%$!proto%''%$!src_zone%''%$!dst_zone%''%$!action%''%$!sent%''%$!rcvd%''%$!src_ip%''%$!dst_ip%''%$!src_port%''%$!dst_port%''%$!srx_xtranslateip%''%$!srxxlatedport%''%$!dst_xtranslateip%''%$!dstxlatedport%''%$!session_id%''%$!reason%')",SQL


rule=:
%start_time:date-rfc3164% 
%host:word% 
%device:word% 
%fw_type:word% 
device_id=%device_id:word% 
%filler1:char-to:\x3A%: 
start_time="%fwstart_time:char-to:\x22%" 
duration=%duration:number% 
policy_id=%policy_id:number% 
service=%service:word% 
proto=%proto:word% 
src zone=%src_zone:word% 
dst zone=%dst_zone:word% 
action=%action:word% 
sent=%sent:number% 
rcvd=%rcvd:number% 
src=%src_ip:ipv4% 
dst=%dst_ip:ipv4% 
src_port=%src_port:number% 
dst_port=%dst_port:number% 
src-xlated ip=%srx_xtranslateip:ipv4% 
port=%srxxlatedport:number% 
dst-xlated ip=%dst_xtranslateip:ipv4% 
port=%dstxlatedport:number% 
session_id=%session_id:number% 
reason=%reason:rest%


{  "reason": "Close - TCP RST"
 , "session_id": "79861"
 , "dstxlatedport": "443"
 , "dst_xtranslateip": "216.58.192.174"
 , "srxxlatedport": "46937"
 , "srx_xtranslateip": "74.115.157.233"
 , "dst_port": "443"
 , "src_port": "64507"
 , "dst_ip": "216.58.192.174"
 , "src_ip": "10.82.8.10"
 , "rcvd": "68"
 , "sent": "136"
 , "action": "Permit"
 , "dst_zone": "Untrust"
 , "src_zone": "private_atm"
 , "proto": "6"
 , "service": "https"
 , "policy_id": "1623"
 , "duration": "2"
 , "fwstart_time": "2018-08-30 18:36:56"
 , "filler1": " [Root]system-notification-00257(traffic)"
 , "device_id": "dencfw01"
 , "fw_type": "NetScreen"
 , "device": "dencfw01:"
 , "host": "dencfw01.contournetworks.net"
 , "start_time": "Aug 30 20:36:58" 

 }

--

5400.566175141:main Q:Reg/w0  : ruleset.c: Filter: check for property 'msg' (value ' NetScreen device_id=dencfw01  [Root]system-notification-00257(traffic): start_time="2018-09-06 17:08:44" duration=76 policy_id=1025 service=https proto=6 src zone=PRIVATE_INET dst zone=Untrust action=Permit sent=5888 rcvd=7866 src=10.47.208.210 dst=23.96.248.197 src_port=55763 dst_port=443 src-xlated ip=74.115.157.198 port=14016 dst-xlated ip=23.96.248.197 port=443 session_id=119818 reason=Close - TCP RST') contains 'policy_id=1623': FALSE


--


2910.281285406:main Q:Reg/w0  : iminternal.c: signaling new internal message via SIGTTOU: 'The error statement was: 
insert into nagalert (device_id, filler1, fwstart_time, duration, policy_id, service, proto, src_zone, dst_zone, action, sent, rcvd, src_ip, dst_ip, src_port, dst_port, srx_xtranslateip, srxxlatedport, dst_xtranslateip, dstxlatedport, session_id, reason) 
values ('', 'dencfw01', ' [Root]system-notification-00257(traffic)', '2018-09-10 12:08:26', '4', '1623', 'https', '6', 'private_atm', 'Untrust', 'Permit', '136', '68', '10.82.8.14', '172.217.4.206', '62628', '443', '74.115.157.233', '7726', '172.217.4.206', '443', '114555', 'Close - TCP RST')
 [v8.37.0 try http://www.rsyslog.com/e/2218 ]'
rsyslogd: action 'action-2-ommysql' (module 'ommysql') message lost, could not be processed. Check for additional error messages before this one. [v8.37.0 try http://www.rsyslog.com/e/2218 ]
rsyslogd: ommysql: db error (1136): Column count doesn't match value count at row 1  [v8.37.0]
rsyslogd: The error statement was: insert into nagalert (device_id, filler1, fwstart_time, duration, policy_id, service, proto, src_zone, dst_zone, action, sent, rcvd, src_ip, dst_ip, src_port, dst_port, srx_xtranslateip, srxxlatedport, dst_xtranslateip, dstxlatedport, session_id, reason) values ('', 'dencfw01', ' [Root]system-notification-00257(traffic)', '2018-09-10 12:08:26', '4', '1623', 'https', '6', 'private_atm', 'Untrust', 'Permit', '136', '68', '10.82.8.20', '172.217.4.206', '59411', '443', '74.115.157.233', '7736', '172.217.4.206', '443', '103712', 'Close - TCP RST') [v8.37.0 try http://www.rsyslog.com/e/2218 ]

describe nagalert;
+------------------+--------------+------+-----+---------+-------+
| Field            | Type         | Null | Key | Default | Extra |
+------------------+--------------+------+-----+---------+-------+
| starttime        | datetime     | YES  |     | NULL    |       |
| host             | varchar(100) | YES  |     | NULL    |       |
| device           | text         | YES  |     | NULL    |       |
| fw_type          | varchar(15)  | YES  |     | NULL    |       |
| device_id        | varchar(15)  | YES  |     | NULL    |       |
| filler1          | varchar(50)  | YES  |     | NULL    |       |
| fwstart_time     | datetime     | YES  |     | NULL    |       |
| duration         | int(11)      | YES  |     | NULL    |       |
| policy_id        | text         | YES  |     | NULL    |       |
| service          | text         | YES  |     | NULL    |       |
| proto            | int(11)      | YES  |     | NULL    |       |
| src_zone         | varchar(12)  | YES  |     | NULL    |       |
| dst_zone         | varchar(12)  | YES  |     | NULL    |       |
| action           | text         | YES  |     | NULL    |       |
| sent             | int(11)      | YES  |     | NULL    |       |
| rcvd             | int(11)      | YES  |     | NULL    |       |
| src_ip           | tinytext     | YES  |     | NULL    |       |
| dst_ip           | tinytext     | YES  |     | NULL    |       |
| src_port         | int(11)      | YES  |     | NULL    |       |
| dst_port         | int(11)      | YES  |     | NULL    |       |
| srx_xtranslateip | varchar(12)  | YES  |     | NULL    |       |
| srxxlatedport    | int(11)      | YES  |     | NULL    |       |
| dst_xtranslateip | int(11)      | YES  |     | NULL    |       |
| dstxlatedport    | int(11)      | YES  |     | NULL    |       |
| session_id       | int(11)      | YES  |     | NULL    |       |
| reason           | varchar(20)  | YES  |     | NULL    |       |
+------------------+--------------+------+-----+---------+-------+



insert into nagalert (device_id
                     ,filler1
                     ,fwstart_time
                     ,duration
                     ,policy_id
                     ,service
                     ,proto
                     ,src_zone
                     ,dst_zone
                     ,action
                     ,sent
                     ,rcvd
                     ,src_ip
                     ,dst_ip
                     ,src_port
                     ,dst_port
                     ,srx_xtranslateip
                     ,srxxlatedport
                     ,dst_xtranslateip
                     ,dstxlatedport
                     ,session_id
                     ,reason) 
              values (''
                     ,'dencfw01'
                     ,' [Root]system-notification-00257(traffic)'
                     ,'2018-09-10 12:08:26'
                     ,'4'
                     ,'1623'
                     ,'https'
                     ,'6'
                     ,'private_atm'
                     ,'Untrust'
                     ,'Permit'
                     ,'136'
                     ,'68'
                     ,'10.82.8.14'
                     ,'172.217.4.206'
                     ,'62628'
                     ,'443'
                     ,'74.115.157.233'
                     ,'7726'
                     ,'172.217.4.206'
                     ,'443'
                     ,'114555'
                     ,'Close - TCP RST');


MariaDB [Syslog]> select now();
+---------------------+
| now()               |
+---------------------+
| 2018-09-10 14:58:04 |
+---------------------+
1 row in set (0.00 sec)

MariaDB [Syslog]> select date_sub(now(), interval 30 minute);
+-------------------------------------+
| date_sub(now(), interval 30 minute) |
+-------------------------------------+
| 2018-09-10 14:28:08                 |
+-------------------------------------+
1 row in set (0.00 sec)

MariaDB [Syslog]> 



select count(*)
  from nagalert
 where src_ip = '10.82.8.10'
   and fwstart_time > (select date_sub(now(), interval 30 minute));



10.82.8.36
10.82.8.9
10.82.8.10
10.82.8.14
10.82.8.20
10.82.8.29

--

MariaDB [Syslog]> CREATE USER 'nagios'@'denmgt04.contournetworks.net';
Query OK, 0 rows affected (0.02 sec)

MariaDB [Syslog]> select User, Host, Password from mysql.user;
+---------+------------------------------+-------------------------------------------+
| User    | Host                         | Password                                  |
+---------+------------------------------+-------------------------------------------+
| root    | localhost                    |                                           |
| root    | denmgt04.contournetworks.net |                                           |
| root    | 127.0.0.1                    |                                           |
| root    | ::1                          |                                           |
|         | localhost                    |                                           |
|         | denmgt04.contournetworks.net |                                           |
| rsyslog | localhost                    | *4CEB281BF3A18FF9B01CB23AC1194B91280B8762 |
| nagios  | denmgt04.contournetworks.net |                                           |
+---------+------------------------------+-------------------------------------------+
8 rows in set (0.00 sec)

MariaDB [Syslog]> GRANT SELECT on Syslog.* to 'nagios'@'denmgt04.contournetworks.net';
Query OK, 0 rows affected (0.02 sec)




