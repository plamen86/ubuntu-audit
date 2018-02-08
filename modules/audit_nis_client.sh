# audit_nis_client
#
# Refer to Section 2.3.1
#.

audit_nis_client () {
  verbose_message "Section 2.3.1: NIS Client Daemons"

  for service_name in ypbind nis; do
    check_systemctl_service disable $service_name
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    check_linux_package uninstall $service_name
   done
}
