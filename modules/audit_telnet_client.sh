# audit_telnet_client
#
# Refer to Section 2.3.4
#.

audit_telnet_client () {
  verbose_message "Section 2.3.4: Telnet Client"

  check_linux_package uninstall telnet
}
