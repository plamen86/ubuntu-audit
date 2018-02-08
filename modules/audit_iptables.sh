# audit_iptables
#
# Refer to Sections 3.6.1-3
#.

audit_iptables () {

  verbose_message "Sections 3.6.1-3: IP Tables"
  check_linux_package install iptables
  for service_name in iptables ip6tables; do
    check_systemctl_service enable $service_name
    check_chkconfig_service $service_name 3 on
    check_chkconfig_service $service_name 5 on
  done

  check=`which iptables`
  if [ "$check" ]; then
    check=`iptables -L INPUT -v -n |grep "127.0.0.0" |grep "0.0.0.0" |grep DROP`
    if [ ! "$check" ]; then
      increment_insecure "All other devices allow trafic to the loopback network"
    else
      increment_secure "All other devices deny trafic to the loopback network"
    fi
  fi
}
