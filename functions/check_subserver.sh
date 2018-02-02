# check_subserver
#
# Function to check subserver under AIX
#.

check_subserver() {
  if [ "$os_name" = "AIX" ]; then
    service_name=$1
    protocol_name=$2
    correct_value=$3
    log_file="$service_name.log"
    actual_value=`cat /etc/inetd.conf |grep '$service_name ' |grep '$protocol_name ' |grep -v '^#' |awk '{print $1}'`
    if [ "$actual_value" != "$service_name" ]; then
      actual_value="off"
    else
      actual_value="on"
    fi
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:   Service \"$service_name\" Protocol \"$protocol_name\" is \"$correct_value\""
      if [ "$actual_value" != "$service_name" ]; then
        if [ "$audit_mode" = 1 ]; then
          increment_insecure "Service \"$service_name\" Protocol \"$protocol_name\" is not \"$correct_value\""
          if [ "$correct_value" = "off" ]; then
            verbose_message "" fix
            verbose_message "chsubserver -r inetd -C /etc/inetd.conf -d -v '$service_name' -p '$protocol_name'" fix
            verbose_message "" fix
          else
            verbose_message "" fix
            verbose_message "chsubserver -r inetd -C /etc/inetd.conf -a -v '$service_name' -p '$protocol_name'" fix
            verbose_message "" fix
          fi
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Service \"$service_name\" Protocol \"$protocol_name\" to \"$correct_value\""
          echo "$actual_value" > $log_file
          if [ "$correct_value" = "off" ]; then
            chsubserver -r inetd -C /etc/inetd.conf -d -v '$service_name' -p '$protocol_name'
          else
            chsubserver -r inetd -C /etc/inetd.conf -a -v '$service_name' -p '$protocol_name'
          fi
        fi
      else
        increment_secure "Service \"$service_name\" Protocol \"$protocol_name\" is \"$correct_value\""
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
        if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Service \"$service_name\" Protocol \"$protocol_name\" to \"$previous_value\""
          if [ "$previous_value" = "off" ]; then
            chsubserver -r inetd -C /etc/inetd.conf -d -v '$service_name' -p '$protocol_name'
          else
            chsubserver -r inetd -C /etc/inetd.conf -a -v '$service_name' -p '$protocol_name'
          fi
        fi
      fi
    fi
  fi
}
