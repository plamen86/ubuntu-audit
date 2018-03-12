
# check_initd_service
#
# Code to audit an init.d service, and enable, or disable service
#
# service_name    = Name of service
# correct_status  = What the status of the service should be, ie enabled/disabled
#.

check_initd_service () {

  service_name=$1
  correct_status=$2
    
  service_check=`ls /etc/init.d |grep "^$service_name$" |wc -l |sed 's/ //g'`
    
  if [ "$service_check" != 0 ]; then
#    echo "Checking:  If init.d service $service_name is $correct_status"
    if [ "$actual_status" != "$correct_status" ]; then
      increment_insecure "Service $service_name is not $correct_status"
    else
      increment_secure "Service $service_name is $correct_status"
    fi
  fi
}
