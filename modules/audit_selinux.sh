# audit_selinux
#
# Make sure SELinux is configured appropriately.
#
# Refer to Sections 1.6.1.1-3
#.

audit_selinux () {

  verbose_message "Sections 1.6.1.1-3 => SELinux"

  check_file="/etc/selinux/config"
  check_file_value $check_file SELINUX eq enforcing hash
  check_file_value $check_file SELINUXTYPE eq targeted hash
  check_file_perms $check_file 0400 root root
  for check_file in /etc/grub.conf /boot/grub/grub.cfg; do
    if [ -e "$check_file" ]; then
      check_file_perms $check_file 0400 root root
      check_file_value $check_file selinux eq 1 hash
      check_file_value $check_file enforcing eq 1 hash
    fi
  done
  check_rpm uninstall setroubleshoot
  check_rpm uninstall mctrans
}
