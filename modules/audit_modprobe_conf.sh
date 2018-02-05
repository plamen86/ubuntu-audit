# audit_modprobe_conf
#
# Refer to Sections 1.1.1.1-8,3.5.1-4
#

audit_modprobe_conf () {
  verbose_message "==========================="
  verbose_message "Modprobe Configuration"
  verbose_message "Sections 1.1.1.1-8, 3.5.1-4"
  verbose_message "==========================="
  check_file="/etc/modprobe.conf"
  check_append_file $check_file "install tipc /bin/true"
  check_append_file $check_file "install rds /bin/true"
  check_append_file $check_file "install sctp /bin/true"
  check_append_file $check_file "install dccp /bin/true"
  check_append_file $check_file "install udf /bin/true"
  check_append_file $check_file "install squashfs /bin/true"
  check_append_file $check_file "install hfs /bin/true"
  check_append_file $check_file "install hfsplus /bin/true"
  check_append_file $check_file "install jffs2 /bin/true"
  check_append_file $check_file "install freevxfs /bin/true"
  check_append_file $check_file "install cramfs /bin/true"
  check_append_file $check_file "install vfat /bin/true"
}
