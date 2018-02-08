# audit_rsync
#
# Refer to Section(s) 2.2.17
#.

audit_rsync () {
  verbose_message "Section 2.2.16: RSync Service"
  
  service_name="rsync"
  check_systemctl_service disable $service_name
  check_chkconfig_service $service_name 3 off
  check_chkconfig_service $service_name 5 off
}
