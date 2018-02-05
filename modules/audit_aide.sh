# audit_aide
#
# Refer to Sections 1.3.1-2
#.

audit_aide() {
  verbose_message "============================="
  verbose_message "Filesystem Integrity Checking"
  verbose_message "Sections 1.3.1-2"
  verbose_message "============================="
  check_file="/etc/sysconfig/prelink"
  if [ -f "$check_file" ]; then
    prelink_check=`cat $check_file |grep PRELINKING |cut -f2 -d= |sed 's/ //g'`
  else
    prelink_check="no"
  fi
  if [ "$prelink_check" = "no" ]; then
    audit_linux_package install aide
    check_append_file /etc/cron.d/aide "0 5 * * * /usr/sbin/aide --check"
  fi
  check_linux_package uninstall prelink
}
