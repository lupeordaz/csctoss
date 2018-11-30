#!/usr/bin/perl

use DBI;
use strict;

my $driver  = "Pg"; 
my $database = "testoss01";
my $dsn = "DBI:$driver:dbname = $database;host = testoss01.cctus.com;port = 5450";
my $userid = "csctoss_owner";
my $password = "owner";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
   or die $DBI::errstr;

print "Opened database successfully\n";

$dbh->disconnect();
