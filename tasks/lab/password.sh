#!/bin/bash

# ------------------------------------------------------------------------------
# Log into IPG/SL device and change password
# See end of script first, then each function for execution details.
# Requires: input.txt passlist-ipg.txt passlist-sl.txt
# ------------------------------------------------------------------------------

# Exit immediately if required files don't exist!
if [[ ! -f input.txt ]] ; then
  echo "Can't find input.txt! Exiting..."
  exit
elif [[ ! -f passlist-ipg.txt ]] ; then
  echo "Can't find passlist-ipg.txt! Exiting..."
  exit
elif [[ ! -f passlist-sl.txt ]] ; then
  echo "Can't find passlist-sl.txt! Exiting..."
  exit
fi

# ---------
# Variables
# ---------

new_password_ipg="albert2018"
new_password_sl="iax+er1Aa{"
timestamp=$(date "+%x %H:%M:%S")
fail_file=fail.txt
success_file=success.txt
IFS=,

nc='\033[0m'
red='\033[1;31m'
blue='\033[1;34m'
green='\033[1;32m'
yellow='\033[1;33m'

# ---------
# Functions
# ---------

# Attempt to change password on IPG devices with `wget` using every password in
# $passlist. If successful, write to $success_file, else, write to $fail_file.
function change_password_ipg() { # {{{
  local port=443 # required!
  local passlist=passlist-ipg.txt
  local tempfile=ipg
  while read password ; do
    # Login and change password with `wget`
    wget -q --no-check-certificate --tries=2 --timeout=5 \
      --user=$username --password=$password --auth-no-challenge \
      --post-data="700=$username&704=$password&701=$new_password_ipg&702=$new_password_ipg&703=0" \
      https://$ip_address:$port/pwpost.cgi -O $tempfile
    # Check if password update succeeded and log
    if grep -q "Success" $tempfile ; then
      echo -e "${green}==>${nc} PASSWORD CHANGE SUCCESS using ${blue}$password${nc}"
      echo -e "${green}==>${nc} NEW PASSWORD is ${yellow}$new_password_ipg${nc}"
      echo "$timestamp $username $serial_number $model_fix $new_password_ipg PASSWORD CHANGE SUCCESS" >> $success_file
      break
    else
      echo -e "${red}---${nc} PASSWORD CHANGE FAILED using $password"
      echo "$timestamp $username $serial_number $model_fix $password PASSWORD CHANGE FAILED" >> $fail_file
    fi
  done < $passlist
} # end change_password_ipg }}}

# Attempt to change password on SL devices with `curl` using every password in
# $passlist. If successful, write to $success_file, else, write to $fail_file.
# NOTE: After 6 failed logins, the device is locked for 30 minutes. Only 3
# passwords can be tried for each device because each password change attempt
# requires 2 login attempts.
function change_password_sl() { # {{{
  local port=443 # required!
  local passlist=passlist-sl.txt
  local tempfile=sl
  while read password ; do
    # Login and change password with `curl`
    curl -s -c cookie -u "$username:$password" \
      -k https://$ip_address:$port/password.php &> /dev/null
    curl -s -b cookie -u "$username:$password" \
      -d "username=$username&password=$password&newpw1=$new_password_sl&newpw2=$new_password_sl&auth_level=0&row=0&PWROWSUBMIT=Update" \
      -k https://$ip_address:$port/password.php > $tempfile
    # Check if password update succeeded and log
    if grep -q "Authenticated with 'Administrator' access." $tempfile ; then
      echo -e "${green}==>${nc} PASSWORD CHANGE SUCCESS using ${blue}$password${nc}"
      echo -e "${green}==>${nc} NEW PASSWORD is ${yellow}$new_password_sl${nc}"
      echo "$timestamp $username $serial_number $model_fix $new_password_sl PASSWORD CHANGE SUCCESS" >> $success_file
      break
    else
      echo -e "${red}---${nc} PASSWORD CHANGE FAILED using $password"
      echo "$timestamp $username $serial_number $model_fix $password PASSWORD CHANGE FAILED" >> $fail_file
    fi
  done < $passlist
} # end change_password_sl }}}

# This function verifies $model_fix and calls correct change password function
function check_model() { # {{{
  if [[ $model_fix = "ipg" ]] ; then
    echo -e "${green}-->${nc} MODEL: IPG"
    change_password_ipg
  elif [[ $model_fix = "sl" ]] ; then
    echo -e "${green}-->${nc} MODEL: SL"
    change_password_sl
  else
    echo -e "${red}---${nc} UNKNOWN DEVICE"
    echo "$timestamp $username $serial_number $model_fix UNKNOWN DEVICE" >> $fail_file
  fi
} # end check_model }}}

# This function pings $ip_address to verify device is online.
function check_online() { # {{{
  if ping -c 1 $ip_address &> /dev/null; then
    echo -e "${green}-->${nc} DEVICE ONLINE"
    check_model
  else
    echo -e "${red}---${nc} DEVICE OFFLINE"
    echo "$timestamp $username $serial_number $model_fix OFFLINE" >> $fail_file
  fi
} # end check_online }}}

# This function can be used to query a database and check for a NULL field, or
# attempt to use a script such as "queryip.sh" to find device $ip_address.
function check_ip() { # {{{
  if [[ ! -z $ip_address ]] ; then
    echo -e "${green}-->${nc} IP ADDRESS FOUND"
    check_online
  else
    echo -e "${red}---${nc} NO IP ADDRESS FOUND"
    echo "$timestamp $username $serial_number $model_fix NO IP ADDRESS FOUND" >> $fail_file
  fi
} # end check_ip }}}

# Main loop
function main() { # {{{
  while read username serial_number ip_address model ; do
    model_fix=$(echo $model | tr '[A-Z]' '[a-z]') # ensure $model is lowercase
    echo
    echo "USER: $username | SN: $serial_number | IP: $ip_address"
    check_ip
  done < input.txt
} # end main }}}

# The following functions will be tried in order for every line in `input.txt`
# main > check_ip > check_online > check_model > change_password_$model_fix
main
