#!/bin/sh

# Name:			ubuntu-audit
# Version:      1
# License:      CC-BA (Creative Commons By Attribution)
#               http://creativecommons.org/licenses/by/4.0/legalcode
# URL:          https://github.com/eniware-org/ubuntu-audit
# Description:  Audit Ubuntu 16.04 LTS according to CIS Benchmarks

# audit_mode = 1 : Audit Mode
# audit_mode = 0 : Lockdown Mode
# audit_mode = 2 : Restore Mode

# Set up some global variables

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

# print_usage
#
# If given a -h or no valid switch print usage information

print_usage () {
  echo ""
  echo "Usage: $0 -[a|A|s|S|d|p|c|l|h|c|V] -[u]"
  echo ""
  echo "-a: Run in audit mode (for Operating Systems - no changes made to system)"
  echo "-A: Run in audit mode (for Operating Systems - no changes made to system)"
  echo "    [includes filesystem checks which take some time]"
  echo "-s: Run in selective mode (only run tests you want to)"
  echo "-R: Print information for a specific test"
  echo "-S: List all UNIX functions available to selective mode"
  echo "-h: Display usage"
  echo "-V: Display version"
  echo "-v: Verbose mode [used with -a and -A]"
  echo "    [Provides more information about the audit taking place]"
  echo ""
  echo "Examples:"
  echo ""
  echo "Run in Audit Mode (for Operating Systems)"
  echo ""
  echo "$0 -a"
  echo ""
  echo "Run in Audit Mode and provide more information (for Operating Systems)"
  echo ""
  echo "$0 -a -v"
  echo ""
  echo "List tests:"
  echo ""
  echo "$0 -S"
  echo ""
  echo "Only run shell based tests:"
  echo ""
  echo "$0 -s audit_shell_services"
  echo ""
  exit
}

# check_os_release
#
# Get OS release information
#.

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
  # Private modules for customers
  if [ -d "$private_dir" ]; then
      echo ""
      echo "Loading Customised Modules"
      echo ""
    if [ "$verbose" = "1" ]; then
      echo ""
    fi
    for file_name in `ls $private_dir/*.sh`; do
      . $file_name
    done
    if [ "$verbose" = "1" ]; then
      echo "Loading:   $file_name"
    fi
  fi
  if [ ! -d "$base_dir" ]; then
    mkdir -p $base_dir
    chmod 700 $base_dir
    chown root:root $base_dir
  fi
  if [ ! -d "$temp_dir" ]; then
    mkdir -p $temp_dir
  fi
  if [ "$audit_mode" = 0 ]; then
    if [ ! -d "$work_dir" ]; then
      mkdir -p $work_dir
    fi
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
  if [ "$audit_mode" != 2 ]; then
    total=`expr $total + 1` 
  fi
}

# increment_secure
#
# Increment secure count
#.

increment_secure () {
  if [ "$audit_mode" != 2 ]; then
    message=$1
    total=`expr $total + 1` 
    secure=`expr $secure + 1`
    echo "Secure:    $message [$secure Passes]"
  fi
}

# increment_insecure
#
# Increment insecure count
#.

increment_insecure () {
  if [ "$audit_mode" != 2 ]; then
    message=$1
    total=`expr $total + 1` 
    insecure=`expr $insecure + 1`
    echo "Warning:   $message [$insecure Warnings]"
  fi
}

# print_previous
#
# Print previous changes
#.

print_previous () {
  if [ -d "$base_dir" ]; then
    echo ""
    echo "Printing previous settings:"
    echo ""
    find $base_dir -type f -print -exec cat -n {} \;
  fi
}

#
# setting_message
#
# Setting message
#.

setting_message () {
  verbose_message $1 setting
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
      echo "Checking:  $text"
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

# funct_audit_system
#
# Audit System
#.

funct_audit_system () {
  audit_mode=$1
  check_environment
  if [ "$audit_mode" = 0 ]; then
    if [ ! -d "$work_dir" ]; then
      mkdir -p $work_dir
    fi
  fi
  audit_system_all
  if [ "$do_fs" = 1 ]; then
    audit_search_fs
  fi
  #audit_test_subset
  if [ `expr "$os_platform" : "sparc"` != 1 ]; then
    audit_system_x86
  else
    audit_system_sparc
  fi
  print_results
}

# funct_audit_select
#
# Selective Audit
#.

funct_audit_select () {
  audit_mode=$1
  function=$2
  check_environment
  if [ "`echo $function |grep aws`" ]; then
    check_aws
  fi
  if [ "`expr $function : audit_`" != "6" ]; then
    function="audit_$function"
  fi
  print_audit_info $function
  $function
  print_results
}

# Get the path the script starts from

start_path=`pwd`

# Get the version of the script from the script itself

script_version=`cd $start_path ; cat $0 | grep '^# Version' |awk '{print $3}'`

# If given no command line arguments print usage information

#if [ `expr "$args" : "\-"` != 1 ]; then
#  print_usage
#fi

# apply_latest_patches
#
# Code to apply patches
# Nothing done with this yet
#.

apply_latest_patches () {
  :
}

# secure_baseline
#
# Establish a Secure Baseline
# This uses the Solaris 10 svcadm baseline
# Don't really need this so haven't coded anything for it yet
#.

secure_baseline () {
  :
}

# print_results
#
# Print Results
#.

print_results () {
  echo ""
  if [ "$audit_mode" != 1 ]; then
    if [ "$reboot" = 1 ]; then
      reboot="Required"
    else
      reboot="Not Required"
    fi
    echo "Reboot:    $reboot"
  fi
  echo "Tests:     $total"
  echo "Passes:    $secure"
  echo "Warnings:  $insecure"
  echo ""
}

#
# print_tests
# Print Tests
# 

print_tests () {
  test_string="$1"
  echo ""
  if [ "$test_string" = "UNIX" ]; then
    grep_string="-v aws"
  else
    grep_string="$test_string"
  fi
  echo "$test_string Security Tests:"
  echo ""
  ls $modules_dir | grep -v '^full_' |grep -i $grep_string |sed 's/\.sh//g'
  echo ""
}

# Handle command line arguments

audit_mode=3
do_fs=3
audit_select=0
verbose=0
do_select=

while getopts abcdlpR:r:s:u:z:hwADSWVLx args; do
  case $args in
    r)
      aws_region="$OPTARG"
      ;;
    v)
      verbose=1
      ;;
    a)
      audit_mode=1
      do_fs=0
      ;;
    s)
      audit_mode=1
      do_fs=0
      do_select=1
      function="$OPTARG"
      ;;
    z)
      audit_mode=0
      do_fs=0
      do_select=1
      function="$OPTARG"
      exit
      ;;
    w)
      audit_mode=1
      do_aws=1
      function="$OPTARG"
      exit
      ;;
    d)
      audit_mode=1
      do_docker=1
      function="$OPTARG"
      exit
      ;;
    x)
      audit_mode=1
      do_aws_rec=1
      function="$OPTARG"
      exit
      ;;
    W)
      print_tests "AWS"
      ;;
    D)
      print_tests "Docker"
      ;;  
    S)
      print_tests "UNIX"
      ;;
    A)
      audit_mode=1
      do_fs=1
      ;;
    l)
      audit_mode=0
      do_fs=0
      ;;
    L)
      audit_mode=0
      do_fs=1
      ;;
    u)
      audit_mode=2
      restore_date="$OPTARG"
      ;;
    h)
      print_usage
      exit
      ;;
    V)
      echo $script_version
      exit
      ;;
    p)
      print_previous
      exit
      ;;
    c)
      print_changes
      exit
      ;;
    R)
      check_environment
      verbose=1
      module="$OPTARG"
      print_audit_info $module
      ;;
    b)
      echo ""
      echo "Previous backups:"
      echo ""
      ls $base_dir
      exit
      ;;
    *)
      print_usage
      exit
      ;;
  esac
done

if [ "$audit_mode" != 3 ]; then
  echo ""
  if [ "$audit_mode" = 2 ]; then
    echo "Running:   In Restore mode (changes will be made to system)"
    echo "Setting:   Restore date $restore_date"
  fi
  if [ "$audit_mode" = 1 ]; then
    echo "Running:   In lockdown mode (no changes will be made to system)"
  fi
  if [ "$audit_mode" = 0 ]; then
    echo "Running:   In lockdown mode (changes will be made to system)"
  fi
  if [ "$do_fs" = 1 ]; then
    echo "           Filesystem checks will be done"
  fi
  echo ""
  if [ "$do_select" = 1 ]; then
    echo "Auditing:  Selecting $function"
    funct_audit_select $audit_mode $function
  else
    if [ "$do_docker" = 1 ]; then
      funct_audit_docker $audit_mode
    fi
    if [ "$do_aws" = 1 ]; then
      funct_audit_aws $audit_mode
    fi
    if [ "$do_aws_rec" = 1 ]; then
      funct_audit_aws_rec $audit_mode
    fi
    funct_audit_system $audit_mode
  fi
  exit
fi
