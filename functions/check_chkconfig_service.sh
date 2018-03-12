# check_chkconfig_service
#
# Code to audit a service managed by chkconfig, and enable, or disbale
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_chkconfig_service () {

  service_name=$1
  service_level=$2
  correct_status=$3

  chk_config="/usr/sbin/sysv-rc-conf"

  if [ "$service_level" = "3" ]; then
    actual_status=`$chk_config --list $service_name 2> /dev/null |awk '{print $5}' |cut -f2 -d':' |awk '{print $1}'`
  fi
  
  if [ "$service_level" = "5" ]; then
    actual_status=`$chk_config --list $service_name 2> /dev/null |awk '{print $7}' |cut -f2 -d':' |awk '{print $1}'`
  fi
    
  if [ "$actual_status" = "on" ] || [ "$actual_status" = "off" ]; then
#    echo "Checking:  Service $service_name at run level $service_level is $correct_status"
    if [ "$actual_status" != "$correct_status" ]; then
      increment_insecure "Service $service_name at run level $service_level is not $correct_status"
    else
      increment_secure "Service $service_name at run level $service_level is $correct_status"
    fi
  fi
}
