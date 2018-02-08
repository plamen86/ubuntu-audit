# audit_rsh_client
#
# Refer to Section 2.3.2
#.

audit_rsh_client () {
  verbose_message "section 2.3.2: RSH Client"

  check_linux_package uninstall rsh
}
