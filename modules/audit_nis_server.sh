# audit_nis_server
#
# Refer to Section(s) 2.2.17
#.

audit_nis_server () {
  verbose_message "Section 2.2.17: NIS Server Daemons"
  
  service_name="nis"
  check_systemctl_service disable $service_name
  check_chkconfig_service $service_name 3 off
  check_chkconfig_service $service_name 5 off
}
