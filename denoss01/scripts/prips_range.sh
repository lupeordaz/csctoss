#!/bin/bash
#
#  Prips program to create ip addresses for range requested
#

range=$1
cmd_str="/usr/local/src/prips-0.9.7/prips ${range}"
$cmd_str

