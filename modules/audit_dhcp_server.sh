# audit_dhcp_server
#
# Refer to Section 2.2.5 
#.

audit_dhcp_server () {
  verbose_message "Section 2.2.5: DHCP Server"
    
  check_systemctl_service disable dhcpd
  check_linux_package uninstall dhcp

}
