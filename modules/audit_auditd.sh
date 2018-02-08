# audit_auditd
#
# Check auditd is installed - Required for various other tests like docker
#
# Refer to Sections 4.1
#.

audit_auditd () {
  verbose_message "Section 4.1: Audit Daemon"

  check_linux_package install auditd
}
