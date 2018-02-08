# audit_dns_server
#
# Refer to Sections 2.2.8
#.

audit_dns_server () {
  if [ "$named_disable" = "yes" ]; then
    verbose_message "Section 2.2.8: DNS Server"
  
    for service_name in dnsmasq named bind9; do
      check_systemctl_service disable $service_name
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
    done

  fi
}
