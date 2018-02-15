#!/bin/sh
# Name:			ubuntu-audit
# Version:      1
# License:      CC-BA (Creative Commons By Attribution)
#               http://creativecommons.org/licenses/by/4.0/legalcode
# URL:          https://github.com/eniware-org/ubuntu-audit
# Description:  Audit Ubuntu 16.04 LTS according to CIS Benchmarks

# Set up some global variables

#CHECK THEM:
# - lockdown_command

args=$@
secure=0
insecure=0
total=0
syslog_server=""
syslog_logdir=""
pkg_company="Eniware"
pkg_suffix="ubuntu-audit"
base_dir="/opt/$pkg_company$pkg_suffix"
date_suffix=`date +%d_%m_%Y_%H_%M_%S`
work_dir="$base_dir/$date_suffix"
temp_dir="$base_dir/tmp"
temp_file="$temp_dir/temp_file"
wheel_group="wheel"
reboot=0
verbose=0
functions_dir="functions"
modules_dir="modules"
private_dir="private"
package_uninstall="no"
country_suffix="en"
language_suffix="en_US"
osx_mdns_enable="yes"
max_super_user_id="100"

# Disable daemons

nfsd_disable="yes"
snmpd_disable="yes"
dhcpcd_disable="yes"
dhcprd_disable="yes"
sendmail_disable="yes"
ipv6_disable="yes"
routed_disable="yes"
named_disable="yes"

# Install packages

install_rsyslog="no"

# This is the company name that will go into the securit message
# Change it as required

company_name="Eniware.org"

check_os_release () {
  echo ""
  echo "# SYSTEM INFORMATION:"
  echo ""

  os_name=`uname`
  if [ "$os_name" = "Linux" ]; then
    if [ -f "/etc/debian_version" ]; then
      os_version=`lsb_release -r |awk '{print $2}' |cut -f1 -d'.'`
      os_update=`lsb_release -r |awk '{print $2}' |cut -f2 -d'.'`
      os_vendor=`lsb_release -i |awk '{print $3}'`
      linux_dist="debian"
    fi
  fi

  if [ "$os_name" != "Linux" ] && [ "$os_vendor" != "Ubuntu" ] && [ "$os_version" != "16" ] && [ "$os_update" != "04" ] ; then
    echo "OS not supported"
    exit
  fi
  
  os_platform=`uname -p`
  os_machine=`uname -m`
  echo "Processor: $os_platform"
  echo "Machine:   $os_machine"
  echo "Vendor:    $os_vendor"
  echo "Name:      $os_name"
  echo "Version:   $os_version"
  echo "Update:    $os_update"
}

# check_environment
#
# Do some environment checks
# Create base and temporary directory
#.

check_environment () {
  check_os_release
  
  id_check=`id -u`
  if [ "$id_check" != "0" ]; then
  	echo ""
    echo "Stopping: $0 needs to be run as root"
    echo ""
    exit
  fi
 
  base_dir="$HOME/.$pkg_suffix"
  temp_dir="/tmp"
  work_dir="$base_dir/$date_suffix"

  # Load functions from functions directory
  if [ -d "$functions_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Functions"
      echo ""
    fi
    for file_name in `ls $functions_dir/*.sh`; do
      . $file_name
      if [ "$verbose" = "1" ]; then
        echo "Loading:   $file_name"
      fi
    done
  fi
  # Load modules for modules directory
  if [ -d "$modules_dir" ]; then
    if [ "$verbose" = "1" ]; then
      echo ""
      echo "Loading Modules"
      echo ""
    fi
    for file_name in `ls $modules_dir/*.sh`; do
      . $file_name
      if [ "$verbose" = "1" ]; then
        echo "Loading:   $file_name"
      fi
    done
  fi
  
  if [ ! -d "$base_dir" ]; then
    mkdir -p $base_dir
    chmod 700 $base_dir
    chown root:root $base_dir
  fi

  if [ ! -d "$temp_dir" ]; then
    mkdir -p $temp_dir
  fi
}

lockdown_command () {
  command=$1
  message=$2
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      echo "Setting:   $message"
    fi
    echo "Executing: $command"
   `$command`
  else
    verbose_message "$command" fix
  fi
}


# increment_total
#
# Increment total count
#.

increment_total () {
  total=`expr $total + 1` 
}

# increment_secure
#
# Increment secure count
#.

increment_secure () {
  message=$1
  total=`expr $total + 1` 
  secure=`expr $secure + 1`
  echo "Secure:    $message [$secure Passes]"
}

# increment_insecure
#
# Increment insecure count
#.

increment_insecure () {
  message=$1
  total=`expr $total + 1` 
  insecure=`expr $insecure + 1`
  echo "Warning:   $message [$insecure Warnings]"
}


# verbose_message
#
# Print a message if verbose mode enabled
#.

verbose_message () {
  text=$1
  style=$2
  if [ "$verbose" = 1 ]; then
    if [ "$style" = "fix" ]; then
      if [ "$text" = "" ]; then
        echo ""
      else
        echo "[ Fix ]    $text"
      fi
    else
      echo "$text"
    fi
  else
    if [ ! "$style" ] && [ "$text" ]; then
#      echo "Checking:  $text"
	  do_nothing = 1
    else
      if [ "$style" = "notice" ]; then
        "Notice:    $text"
      fi
      if [ "$style" = "backup" ]; then
        "Backup:    $text"
      fi
      if [ "$style" = "setting" ]; then
        "Setting:   $text"
      fi
    fi
  fi
}

print_results () {
  echo ""
  echo "Tests:     $total"
  echo "Passes:    $secure"
  echo "Warnings:  $insecure"
  echo ""
}


  verbose=1
  audit_mode=1
  do_fs=0

  check_environment
  audit_system_all

  print_results