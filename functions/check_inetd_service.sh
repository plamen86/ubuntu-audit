# check_inetd_service
#
# Change status of an inetd (/etc/inetd.conf) services
#
#.

check_inetd_service () {

  service_name=$1
  correct_status=$2
  check_file="/etc/inetd.conf"

  if [ -f "$check_file" ]; then
    if [ "$correct_status" = "disabled" ]; then
      actual_status=`cat $check_file |grep '^$service_name' |grep -v '^#' |awk '{print $1}'`
    else
      actual_status=`cat $check_file |grep '^$service_name' |awk '{print $1}'`
    fi

#    echo "Checking:  If inetd service $service_name is set to $correct_status"
    if [ "$actual_status" != "" ]; then
      increment_insecure "Service $service_name does not have $parameter_name set to $correct_status"

      if [ "$correct_status" = "disable" ]; then
        disable_value $check_file $service_name hash
      else
        :
      fi
    else
      increment_secure "Service $service_name is set to $correct_status"
    fi
  fi
}
