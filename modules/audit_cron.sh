# audit_cron
#
# Refer to Section 5.1.1
#.

audit_cron () {

  verbose_message "Section 5.1.1: Cron Daemon"
  
  service_name="crond"
  check_chkconfig_service $service_name 3 on
  check_chkconfig_service $service_name 5 on
  check_systemctl_service enable $service_name
}
