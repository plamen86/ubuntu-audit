# audit_avahi_server
#
# Refer to Section 2.2.3
#.

audit_avahi_server () {
  verbose_message "Section 2.2.3: Avahi Server"
      
  for service_name in avahi avahi-autoipd avahi-daemon avahi-dnsconfd; do
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
  done
  check_systemctl_service disable avahi-daemon
}
