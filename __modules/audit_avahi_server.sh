# audit_avahi_server
#
# Refer to Section(s) 2.2.3 Page(s) 103  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_avahi_server () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Avahi Server"
    for service_name in avahi avahi-autoipd avahi-daemon avahi-dnsconfd; do
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    done
    check_systemctl_service disable avahi-daemon
  fi
}
