# audit_dns_server
#
# Refer to Section(s) 2.2.9  Page(s) 109  CIS Ubuntu Linux 16.04 Benchmark v1.0.0
# Refer to Section(s) 2.2.8  Page(s) 108  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_dns_server () {
  if [ "$named_disable" = "yes" ]; then
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      verbose_message "DNS Server"
      if [ "$os_name" = "AIX" ]; then
        check_rctcp named off
      fi
      if [ "$os_name" = "SunOS" ]; then
        if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
          service_name="svc:/network/dns/server:default"
          check_sunos_service $service_name disabled
        fi
      fi
      if [ "$os_name" = "Linux" ]; then
        for service_name in dnsmasq named bind9; do
          check_systemctl_service disable $service_name
          check_chkconfig_service $service_name 3 off
          check_chkconfig_service $service_name 5 off
        done
        if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
          check_linux_package uninstall bind
        fi
      fi
      if [ "$os_name" = "FreeBSD" ]; then
        check_file="/etc/rc.conf"
        check_file_value $check_file named_enable eq NO hash
      fi
    fi
  fi
}
