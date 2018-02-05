# audit_dhcp_server
#
# Refer to Section(s) 2.2.5 Page(s) 105  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_dhcp_server () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    verbose_message "DHCP Server"
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/network/dhcp-server:default"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      check_systemctl_service disable dhcpd
      check_linux_package uninstall dhcp
    fi
  fi
}
