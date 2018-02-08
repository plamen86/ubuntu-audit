# audit_snmp
#
# Refer to Section(s) 2.2.14
#.

audit_snmp () {
  if [ "$snmpd_disable" = "yes" ]; then
    verbose_message "2.2.14: SNMP Daemons and Log Permissions"

    check_rpm net-snmp
    if [ "$rpm_check" = "net-snmp" ]; then
      for service_name in snmp snmptrapd; do
        check_systemctl_service disable $service_name
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
      check_append_file /etc/snmp/snmpd.conf "com2sec notConfigUser default public" hash
      check_linux_package uninstall net-snmp
    fi
  fi
}
