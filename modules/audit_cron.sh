# audit_cron
#
# Refer to Section(s) 5.1.1 Page(s) 204   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_cron () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Cron Daemon"
    service_name="crond"
    check_chkconfig_service $service_name 3 on
    check_chkconfig_service $service_name 5 on
    check_systemctl_service enable $service_name
    if [ "$anacron_enable" = "yes" ]; then
      service_name="anacron"
      check_chkconfig_service $service_name 3 on
      check_chkconfig_service $service_name 5 on
    fi
  fi
}
