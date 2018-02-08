# audit_tcp_wrappers
#
# Refer to Sections 3.4.1-5
#.

audit_tcp_wrappers () {

    verbose_message "Sections 3.4.1-5: TCP Wrappers"

    check_file="/etc/hosts.deny"
    check_file_value $check_file ALL colon " ALL" hash
    check_file="/etc/hosts.allow"
    check_file_value $check_file ALL colon " localhost" hash
    check_file_value $check_file ALL colon " 127.0.0.1" hash

    if [ ! -f "$check_file" ]; then
      for ip_address in `ifconfig -a |grep 'inet addr' |grep -v ':127.' |awk '{print $2}' |cut -f2 -d":"`; do
        netmask=`ifconfig -a |grep '$ip_address' |awk '{print $3}' |cut -f2 -d":"`
        check_file_value $check_file ALL colon " $ip_address/$netmask" hash
      done
    fi

    group_name="root"

    check_file_perms /etc/hosts.deny 0644 root $group_name
    check_file_perms /etc/hosts.allow 0644 root $group_name

  check_linux_package install tcpd
}
