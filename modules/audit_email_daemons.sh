# audit_email_daemons
#
# Refer to Section 2.2.11
#.

audit_email_daemons () {

  verbose_message "Section 2.2.11: Mail Daemons"

  for service_name in cyrus imapd qpopper dovecot; do
    check_systemctl_service disable $service_name
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 3 off
    check_linux_package uninstall $service_name 
  done
}
