# audit_autofs
#
# Refer to Section 1.1.21
#.

audit_autofs () {

  verbose_message "=================="
  verbose_message "Automount services"
  verbose_message "Section 1.1.21"
  verbose_message "=================="

  check_chkconfig_service autofs 3 off
  check_chkconfig_service autofs 5 off
  check_systemctl_service disable autofs
}
