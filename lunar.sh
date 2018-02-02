#!/bin/sh

# Name:         lunar (Lockdown UNix Auditing and Reporting)
# Version:      7.2.7
# Release:      1
# License:      CC-BA (Creative Commons By Attribution)
#               http://creativecommons.org/licenses/by/4.0/legalcode
# Group:        System
# Source:       N/A
# URL:          http://lateralblast.com.au/
# Distribution: Solaris, Red Hat Linux, SuSE Linux, Debian Linux,
#               Ubuntu Linux, Mac OS X, AIX, FreeBSD, ESXi
# Vendor:       UNIX
# Packager:     Richard Spindler <richard@lateralblast.com.au>
# Description:  Audit script based on various benchmarks
#               Addition improvements added
#               Written in bourne shell so it can be run on different releases

# No warranty is implied or given with this script
# It is based on numerous security guidelines
# As with any system changes, the script should be vetted and
# changed to suit the environment in which it is being used

# Unless your organization is specifically using the service, disable it.
# The best defense against a service being exploited is to disable it.

# Even if a service is set to off the script will audit the configuration
# file so that if a service is re-enabled the configuration is secure
# Where possible checks are made to make sure the package is installed
# if the package is not installed the checks will not be run

# To do:
#
# - nosuid,noexec for Linux
# - Disable user mounted removable filesystems for Linux
# - Disable USB devices for Linux
# - Grub password
# - Restrict NFS client requests to privileged ports Linux

# Solaris Release Information
#  1/06 U1
#  6/06 U2
# 11/06 U3
#  8/07 U4
#  5/08 U5
# 10/08 U6
#  5/09 U7
# 10/09 U8
#  9/10 U9
#  8/11 U10
#  1/13 U11

# audit_mode = 1 : Audit Mode
# audit_mode = 0 : Lockdown Mode
# audit_mode = 2 : Restore Mode

# Defaults for AWS

aws_iam_master_role="iam-master"
aws_iam_manager_role="iam-manager"
aws_cloud_trail_name="aws-audit-log"
sns_protocol="email"
sns_endpoint="alerts@company.com"
valid_tag_string="(ue1|uw1|uw2|ew1|ec1|an1|an2|as1|as2|se1)-(d|t|s|p)-([a-z0-9\-]+)$"
aws_region=""
aws_rds_min_retention="7"
aws_ec2_min_retention="7"
aws_ec2_max_retention="30"
aws_days_to_key_deletion="7"

# Set up some global variables

args=$@
secure=0
insecure=0
total=0
syslog_server=""
syslog_logdir=""
pkg_company="LTRL"
pkg_suffix="lunar"
base_dir="/opt/$pkg_company$pkg_suffix"
date_suffix=`date +%d_%m_%Y_%H_%M_%S`
work_dir="$base_dir/$date_suffix"
temp_dir="$base_dir/tmp"
temp_file="$temp_dir/temp_file"
wheel_group="wheel"
docker_group="docker"
reboot=0
verbose=0
functions_dir="functions"
modules_dir="modules"
private_dir="private"
package_uninstall="no"
country_suffix="au"
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

company_name="Lateral Blast Pty Ltd"

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
  echo "-w: Run in audit mode (for AWS - no changes made to system)"
  echo "-d: Run in audit mode (for Docker - no changes made to system)"
  echo "-x: Run in recommendations mode (for AWS - no changes made to system)"
  echo "-s: Run in selective mode (only run tests you want to)"
  echo "-R: Print information for a specific test"
  echo "-S: List all UNIX functions available to selective mode"
  echo "-W: List all AWS functions available to selective mode"
  echo "-D: List all Docker functions available to selective mode"
  echo "-l: Run in lockdown mode (for Operating Systems - changes made to system)"
  echo "-L: Run in lockdown mode (for Operating Systems - changes made to system)"
  echo "    [includes filesystem checks which take some time]"
  echo "-c: Show changes previously made to system"
  echo "-p: Show previously versions of file"
  echo "-u: Undo lockdown (for Operating Systems - changes made to system)"
  echo "-h: Display usage"
  echo "-V: Display version"
  echo "-v: Verbose mode [used with -a and -A]"
  echo "    [Provides more information about the audit taking place]"
  echo ""
  echo "Examples:"
  echo ""
  echo "Run AWS CLI audit"
  echo ""
  echo "$0 -w"
  echo ""
  echo "Run Docker audit"
  echo ""
  echo "$0 -d"
  echo ""
  echo "Run in Audit Mode (for Operating Systems)"
  echo ""
  echo "$0 -a"
  echo ""
  echo "Run in Audit Mode and provide more information (for Operating Systems)"
  echo ""
  echo "$0 -a -v"
  echo ""
  echo "Display previous backups:"
  echo ""
  echo "$0 -b"
  echo "Previous backups:"
  echo "21_12_2012_19_45_05  21_12_2012_20_35_54  21_12_2012_21_57_25"
  echo ""
  echo "Restore from previous backup:"
  echo ""
  echo "$0 -u 21_12_2012_19_45_05"
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
  if [ "$os_name" = "Darwin" ]; then
    set -- $(sw_vers | awk 'BEGIN { FS="[:\t.]"; } /^ProductVersion/ && $0 != "" {print $3, $4, $5}')
    os_version=$1.$2
    os_release=$2
    os_update=$3
    os_vendor="Apple"
  fi
  if [ "$os_name" = "Linux" ]; then
    if [ -f "/etc/redhat-release" ]; then
      os_version=`cat /etc/redhat-release | awk '{print $3}' |cut -f1 -d'.'`
      os_update=`cat /etc/redhat-release | awk '{print $3}' |cut -f2 -d'.'`
      os_vendor=`cat /etc/redhat-release | awk '{print $1}'`
      linux_dist="redhat"
    else
      if [ -f "/etc/debian_version" ]; then
        os_version=`lsb_release -r |awk '{print $2}' |cut -f1 -d'.'`
        os_update=`lsb_release -r |awk '{print $2}' |cut -f2 -d'.'`
        os_vendor=`lsb_release -i |awk '{print $3}'`
        linux_dist="debian"
        if [ ! -f "/usr/sbin/sysv-rc-conf" ] && [ "$os_version" -lt 16 ]; then
          echo "Notice:    The sysv-rc-conf package is required by this script"
		      while true; do
      			read -p "Do you wish to install this program? " yn
      			case $yn in
      				[Yy]* ) apt-get install sysv-rc-conf; break;;
      				[Nn]* ) echo "Exiting script"; exit;;
      				* ) echo "Please answer yes or no.";;
      			esac
    		  done
        fi
        if [ ! -f "/usr/bin/bc" ]; then
          echo "Notice:    The bc package is required by this script"
          while true; do
      			read -p "Do you wish to install this program?" yn
      			case $yn in
      				[Yy]* ) apt-get install bc; break;;
      				[Nn]* ) echo "Exiting script"; exit;;
      				* ) echo "Please answer yes or no.";;
      			esac
    		  done
        fi
        if [ ! -f "/usr/bin/finger" ]; then
          echo "Notice:    The finger package is required by this script"
    		  while true; do
    			read -p "Do you wish to install this program?" yn
    			case $yn in
    				[Yy]* ) apt-get install finger; break;;
    				[Nn]* ) echo "Exiting script"; exit;;
    				* ) echo "Please answer yes or no.";;
    			esac
    		  done
        fi
      else
        if [ -f "/etc/SuSE-release" ]; then
          os_version=`cat /etc/SuSe-release |grep '^VERSION' |awk '{print $3}' |cut -f1 -d "."`
          os_update=`cat /etc/SuSe-release |grep '^VERSION' |awk '{print $3}' |cut -f2 -d "."`
          os_vendor="SuSE"
          linux_dist="suse"
        else
          if [ -f "/etc/os-release" ]; then
            os_vendor="Amazon"
            os_version=`cat /etc/os-release |grep '^VERSION_ID' |cut -f2 -d'"' |cut -f1 -d.`
            os_update=`cat /etc/os-release |grep '^VERSION_ID' |cut -f2 -d'"' |cut -f2 -d.`
          fi
        fi
      fi
    fi
  fi
  if [ "$os_name" = "SunOS" ]; then
    os_vendor="Oracle Solaris"
    os_version=`uname -r |cut -f2 -d"."`
    if [ "$os_version" = "11" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $3}' |cut -f2 -d'.'`
    fi
    if [ "$os_version" = "10" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $5}' |cut -f2 -d'_' |sed 's/[A-z]//g'`
    fi
    if [ "$os_version" = "9" ]; then
      os_update=`cat /etc/release |grep Solaris |awk '{print $4}' |cut -f2 -d'_' |sed 's/[A-z]//g'`
    fi
  fi
  if [ "$os_name" = "FreeBSD" ]; then
    os_version=`uname -r |cut -f1 -d "."`
    os_update=`uname -r |cut -f2 -d "."`
    os_vendor=$os_name
  fi
  if [ "$os_name" = "AIX" ]; then
    os_vendor="IBM"
    os_version=`oslevel |cut -f1 -d.`
    os_update=`oslevel |cut -f2 -d.`
  fi
  if [ "$os_name" = "VMkernel" ]; then
    os_version=`uname -r`
    os_update=`uname -v |awk '{print $4}'`
    os_vendor="VMware"
  fi
  if [ "$os_name" != "Linux" ] && [ "$os_name" != "SunOS" ] && [ "$os_name" != "Darwin" ] && [ "$os_name" != "FreeBSD" ] && [ "$os_name" != "AIX" ] && [ "$os_name" != "VMkernel" ]; then
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
  if [ "$os_name" = "Darwin" ]; then
    echo ""
    echo "Checking:  If node is managed"
    managed_node=`sudo pwpolicy -n -getglobalpolicy 2>&1 |cut -f1 -d:`
    if [ "$managed_node" = "Error" ]; then
      echo "Notice:    Node is not managed"
    else
      echo "Notice:    Node is managed"
    fi
    echo ""
  fi
  if [ "$os_name" != "VMkernel" ]; then
    if [ "$os_name" = "SunOS" ]; then
      id_check=`id |cut -c5`
    else
      id_check=`id -u`
    fi
    if [ "$id_check" != "0" ]; then
      if [ "$os_name" != "Darwin" ]; then
        echo ""
        echo "Stopping: $0 needs to be run as root"
        echo ""
        exit
      fi
    fi
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
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        source $file_name
      fi
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
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] || [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        if [ "$file_name" = "modules/audit_ftp_users.sh" ]; then
          if [ "$os_name" != "VMkernel" ]; then
             source $file_name
          fi
        else
          source $file_name
        fi
      fi
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
      if [ "$os_name" = "SunOS" ] || [ "$os_name" = "AIX" ] ||  [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
        . $file_name
      else
        source $file_name
      fi
    done
    if [ "$verbose" = "1" ]; then
      echo "Loading:   $file_name"
    fi
  fi
  if [ ! -d "$base_dir" ]; then
    mkdir -p $base_dir
    chmod 700 $base_dir
    if [ "$os_name" != "Darwin" ]; then
      chown root:root $base_dir
    fi
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

# lockdown_command
#
# Run a lockdown command
# Check that we are in lockdown mode
# If not in lockdown mode output a verbose message
#.

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

# restore_command
#
# Restore command
# Check we are running in restore mode run a command
#.

restore_command () {
  command=$1
  message=$2
  if [ "$audit_mode" = 0 ]; then
    if [ "$message" ]; then
      echo "Restoring: $message"
    fi
    echo "Executing: $command"
   `$command`
  else
    verbose_message "$command" fix
  fi
}

#
# backup_state
#
# Backup state to a log file for later restoration
#.

backup_state () {
  if [ "$audit_mode" = 0 ]; then
    backup_name=$1
    backup_value=$1
    backup_file="$work_dir/$backup_name.log"
    echo "$backup_value" > $backup_file
  fi
}

#
# restore_state
#
# Restore state from a log file
#.

restore_state () {
  if [ "$audit_mode" = 2 ]; then
    restore_name=$1
    current_value=$2
    restore_command=$3
    restore_file="$restore_dir/$restore_name"
    if [ -f "$restore_file" ]; then
      restore_value=`cat $restore_file`
      if [ "$current_value" != "$restore_value" ]; then
        echo "Executing: $command"
        `$restore_command`
      fi
    fi
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


# print_changes
#
# Do a diff between previous file (saved) and existing file
#.

print_changes () {
  if [ -f "$base_dir" ]; then
    echo ""
    echo "Printing changes:"
    echo ""
    for saved_file in `find $base_dir -type f -print`; do
      check_file=`echo $saved_file |cut -f 5- -d"/"`
      top_dir=`echo $saved_file |cut -f 1-4 -d"/"`
      echo "Directory: $top_dir"
      log_test=`echo "$check_file" |grep "log$"`
      if [ `expr "$log_test" : "[A-z]"` = 1 ]; then
        echo "Original system parameters:"
        cat $saved_file |sed "s/,/ /g"
      else
        echo "Changes to /$check_file:"
        diff $saved_file /$check_file
      fi
    done
  else
    echo "No changes made recently"
  fi
}


# check_aws
#
# Check AWS CLI etc is installed
#.

check_aws () {
  aws_bin=`which aws 2> /dev/null`
  if [ -f "$aws_bin" ]; then
    aws_creds="$HOME/.aws/credentials"
    if [ -f "$aws_creds" ]; then
      if [ "$os_name" = "Darwin" ]; then
        base64_d="base64 -D"
      else
        base64_d="base64 -d"
      fi
    else
      echo "AWS credentials file does not exit"
      exit
    fi
  else
    echo "AWS CLI is not installed"
    exit
  fi
  if [ ! "$aws_region" ]; then
    aws_region=`aws configure get region`
  fi
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_docker () {
  audit_mode=$1
  check_environment
  audit_docker_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_all
  print_results
}

# funct_audit_aws
#
# Audit AWS
#.

funct_audit_aws_rec () {
  audit_mode=$1
  check_environment
  check_aws
  audit_aws_rec_all
  print_results
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
      if [ "$os_name" = "SunOS" ]; then
        echo "Creating:  Alternate Boot Environment $date_suffix"
        if [ "$os_version" = "11" ]; then
          beadm create audit_$date_suffix
        fi
        if [ "$os_version" = "8" ] || [ "$os_version" = "9" ] || [ "$os_version" = "10" ]; then
          if [ "$os_platform" != "i386" ]; then
            lucreate -n audit_$date_suffix
          fi
        fi
      else
        :
        # Add code to do LVM snapshot
      fi
    fi
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_dir="$base_dir/$restore_date"
    if [ ! -d "$restore_dir" ]; then
      echo "Restore directory $restore_dir does not exit"
      exit
    else
      echo "Setting:   Restore directory to $restore_dir"
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

if [ `expr "$args" : "\-"` != 1 ]; then
  print_usage
fi

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
  if [ "$audit_mode" = 0 ]; then
    echo "Backup:    $work_dir"
    echo "Restore:   $0 -u $date_suffix"
  fi
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
do_select=0
do_aws=0
do_aws_rec=0
do_docker=0

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

