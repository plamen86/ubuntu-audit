# check_systemctl_service
#
# Code to audit a service managed by systemctl, and enable, or disable
#
# service_name    = Name of service
# service_level   = Level service runs at
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_systemctl_service () {
  temp_status=$1
  temp_name=$2
  use_systemctl="no"
  if [ "$temp_name" = "on" ] || [ "$temp_name" = "off" ]; then
    correct_status=$temp_name 
    service_name=$temp_status
  else
    correct_status=$temp_status
    service_name=$temp_name
  fi
  if [ "$correct_status" = "enable" ] || [ "$correct_status" = "enabled" ] || [ "$correct_status" = "on" ]; then
    service_switch="enable"
    correct_status="enabled"
  else
    service_switch="disable"
    correct_status="disabled"
  fi

  actual_status=`systemctl is-enabled $service_name 2> /dev/null`

  echo "Checking:  Service $service_name is $correct_status"
  if [ "$actual_status" = "enabled" ] || [ "$actual_status" = "disabled" ]; then
    if [ "$actual_status" != "$correct_status" ]; then
      increment_insecure "Service $service_name is not $correct_status"
#      lockdown_command "echo \"$service_name,$actual_status\" >> $log_file ; systemctl $service_name $service_switch" "Service $service_name to $correct_status"
    else
      increment_secure "Service $service_name is $correct_status"
    fi
  fi
}
