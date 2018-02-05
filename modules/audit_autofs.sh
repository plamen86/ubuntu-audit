# audit_autofs
#
# Refer to Sections 1.1.21
#.

audit_autofs () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
  	verbose_message "=================="
    verbose_message "Automount services"
    verbose_message "Sections 1.1.21"
    verbose_message "=================="
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" = "10" ] || [ "$os_version" = "11" ]; then
        service_name="svc:/system/filesystem/autofs"
        check_sunos_service $service_name disabled
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      service_name="autofs"
      check_chkconfig_service $service_name 3 off
      check_chkconfig_service $service_name 5 off
      check_systemctl_service disable $service_name
    fi
  fi
}
