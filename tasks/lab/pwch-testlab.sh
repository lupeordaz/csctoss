#!/bin/bash

# ------------------------------------------------------------------------------
# Log into IPG/SL device and change password
# See end of script first, then each function for execution details.
# Requires: input.txt password-ipg.txt password-sl.txt
# ------------------------------------------------------------------------------

# ---------
# Variables
# ---------

serial_number=$1
port=443 # required!

# ---------
# Functions
# ---------

# Query database to see if password field is empty
function password_check() { # {{{
  equipment_id=$(PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c \
    "SELECT e.equipment_id from equipment_credential e \
       JOIN unique_identifier u ON e.equipment_id = u.equipment_id \
      WHERE u.value = '$serial_number'")
  password=$(PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c \
    "SELECT password FROM equipment_credential WHERE equipment_id = '$equipment_id'")
} # end password_check }}}

# Update database when password change succeeded
function update_database_success() { # {{{
  equipment_id=$(PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c \
    "SELECT e.equipment_id from equipment_credential e \
       JOIN unique_identifier u ON e.equipment_id = u.equipment_id \
      WHERE u.value = '$serial_number'")
  (PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c \
    "UPDATE equipment_credential SET password = '$new_password', last_update_timestamp = 'now()', last_update_status = 'SUCCESS' WHERE equipment_id = '$equipment_id'")
} # end update_database_success }}}

# Update database when password change failed
function update_database_fail() { # {{{
  equipment_id=$(PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c "SELECT e.equipment_id from equipment_credential e JOIN unique_identifier u ON e.equipment_id = u.equipment_id where u.value = '$serial_number'")
  (PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c \
    "UPDATE equipment_credential SET last_update_timestamp = 'now()', last_update_status = 'FAIL' WHERE equipment_id = '$equipment_id'")
} # end update_database_fail }}}

# Attempt to change password on IPG devices with `wget`
# If successful, calls update_database_success, else update_database_fail
function change_password_ipg() { # {{{
  # Login and change password with `wget`
  wget -q --no-check-certificate --tries=2 --timeout=5 \
    --user=$username --password=$i --auth-no-challenge \
    --post-data="700=$username&704=$i&701=$new_password&702=$new_password&703=0" \
    https://$ip_address:$port/pwpost.cgi -O $tempfile
  # Check if password update succeeded
  if grep -q "Success" $tempfile ; then
    echo "PASSWORD CHANGE SUCCESS using $i - NEW PASSWORD is $new_password"
    update_database_success
  else
    echo "PASSWORD CHANGE FAILED using $i"
    update_database_fail
  fi
} # end change_password_ipg }}}

# Main IPG function
# Queries database for current password, if no password found, attempts to login
# with every password in $passlist; else attempts login with current password.
function main_ipg() { # {{{
  local tempfile=ipg
  local new_password="manic77"
  local passlist=("albert3" "albert2" "albert1")
  password_check
  if [[ -z $password ]]; then
    for i in "${passlist[@]}" ; do
      change_password_ipg
    done
  else
    i=$password
    change_password_ipg
  fi
} # end main_ipg }}}

# Attempt to change password on SL devices with `curl`
# If successful, calls update_database_success, else update_database_fail
function change_password_sl() { # {{{
  # Login and change password with `curl`
  curl -s -c cookie -u "$username:$i" \
    -k https://$ip_address:$port/password.php &> /dev/null
  curl -s -b cookie -u "$username:$i" \
    -d "username=$username&password=$i&newpw1=$new_password&newpw2=$new_password&auth_level=0&row=0&PWROWSUBMIT=Update" \
    -k https://$ip_address:$port/password.php > $tempfile
  # Check if password update succeeded
  if grep -q "Authenticated with 'Administrator' access." $tempfile ; then
    echo "PASSWORD CHANGE SUCCESS using $i - NEW PASSWORD is $new_password"
    update_database_success
  else
    echo "PASSWORD CHANGE FAILED using $i"
    update_database_fail
  fi
} # end change_password_sl }}}

# Main SL function
# Queries database for current password, if no password found, attempts to login
# with every password in $passlist; else attempts login with current password.
# NOTE: After 6 failed logins, the device is locked for 30 minutes. Only 3
# passwords can be tried for each device because each password change attempt
# requires 2 login attempts.
function main_sl() { # {{{
  local tempfile=sl
  local new_password="8gy^J2heya"
  local passlist=("!password1" "!password2" "sysl1nk")
  password_check
  if [[ -z $password ]]; then
    for i in "${passlist[@]}" ; do
      change_password_sl
    done
  else
    i=$password
    change_password_sl
  fi
} # end main_sl }}}

# This function checks $model and calls correct change password function
function check_model() { # {{{
  if [[ $model == IPG* ]]; then
    main_ipg
  elif [[ $model == SL* ]]; then
    main_sl
  else
    echo "DEVICE UNKNOWN"
  fi
} # end check_model }}}

# This function pings $ip_address to verify device is online
function check_online() { # {{{
  if ping -c 1 $ip_address &> /dev/null; then
    echo "DEVICE ONLINE"
    check_model
  else
    echo "DEVICE OFFLINE, TRY AGAIN LATER"
  fi
} # end check_online }}}

# Main function.
# Queries database and returns $username $ip_address and $model based on $1
function main() { # {{{
  read username ip_address model <<< $(PGPASSWORD=1234 psql -U csctoss_owner -d csctoss -q -t -A -F ' ' -c "SELECT username, ip_address, model FROM systech_devices WHERE serial_number = '$serial_number'")
  echo "$serial_number $username $ip_address $model"
  check_online
} # end main }}}

# The following functions will be tried in order for $serial_number($1)
# main > check_online > check_model > change_password_$model
main
