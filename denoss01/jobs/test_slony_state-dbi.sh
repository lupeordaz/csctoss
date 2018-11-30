#!/bin/bash
# 
# Shell wrapper to call perl program test_slony_state-dbi.pl to perform slony check and report problems.
#
source /home/postgres/.bash_profile
/usr/bin/perl /home/postgres/slony/test_slony_state-dbi.pl > /home/postgres/dba/logs/test_slony_state-dbi.H`/bin/date +%H`
