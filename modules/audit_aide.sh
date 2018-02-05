# audit_aide
#
# Refer to Sections 1.3.1-2
#.

audit_aide() {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "=================="
    verbose_message "AIDE"
    verbose_message "Section(s) 1.3.1-2"
    verbose_message "=================="
    if [ "$os_vendor" = "CentOS" ] || [ "$os_vendor" = "Red" ] || [ "$os_vendor" = "Amazon" ]; then
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
    fi
  fi
}
