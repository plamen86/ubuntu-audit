# audit_xinetd_service
#
# Code to audit an xinetd service, and enable, or disable
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

audit_xinetd_service () {
  if [ "$os_name" = "Linux" ]; then
    service_name=$1
    parameter_name=$2
    correct_status=$3
    check_file="/etc/xinetd.d/$service_name"

    if [ -f "$check_file" ]; then
      actual_status=`cat $check_file |grep $parameter_name |awk '{print $3}'`
#      echo "Checking:  If xinetd service $service_name has $parameter_name set to $correct_status"
      if [ "$actual_status" != "$correct_status" ]; then
        command="update-rc.d $service_name $correct_status"
        increment_insecure "Service $service_name does not have $parameter_name set to $correct_status"
 #       log_file="$work_dir/$log_file"
 #       backup_file $check_file
 #       lockdown_command "echo \"$parameter_name,$actual_status\" >> $log_file ; cat $check_file |sed 's/$parameter_name.*/$parameter_name = $correct_status/g' > $temp_file ; cp $temp_file $check_file ; $command" "Service to $parameter_name"
      else
        increment_secure "Service $service_name has $parameter_name set to $correct_status"
      fi
    fi
  fi
}
