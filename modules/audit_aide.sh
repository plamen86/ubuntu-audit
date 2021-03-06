# audit_aide
#
# Refer to Sections 1.3.1-2
#.

audit_aide() {
  verbose_message "Sections 1.3.1-2, 1.5.4: Filesystem Integrity Checking"

  check_file="/etc/sysconfig/prelink"

  if [ -f "$check_file" ]; then
    prelink_check=`cat $check_file |grep PRELINKING |cut -f2 -d= |sed 's/ //g'`
  else
    prelink_check="no"
  fi
  
  if [ "$prelink_check" = "no" ]; then
    check_linux_package install aide
    check_append_file /etc/cron.d/aide "0 5 * * * /usr/sbin/aide --check"
  fi
  
  check_linux_package uninstall prelink
}
