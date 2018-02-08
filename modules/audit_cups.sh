# audit_cups
#
# Refer to Section 2.2.4
#.

audit_cups () {
  
  check_rpm cups

  if [ "$rpm_check" = "cups" ]; then
    verbose_message "Section 2.2.4: Printing Services

    service_name="cups"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    service_name="cups-lpd"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    service_name="cupsrenice"
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    check_file_perms /etc/init.d/cups 0744 root root
    check_file_perms /etc/cups/cupsd.conf 0600 lp sys
    check_file_perms /etc/cups/client.conf 0644 root lp
    check_file_value /etc/cups/cupsd.conf User space lp hash
    check_file_value /etc/cups/cupsd.conf Group space sys hash
    check_systemctl_service disable cups
  fi
}
