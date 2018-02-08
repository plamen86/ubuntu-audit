# audit_core_dumps
#
# Refer to Section 1.5.1
#.

audit_core_dumps () {


  verbose_message "Section 1.5.1: Core Dumps"

  check_file="/etc/security/limits.conf"
  check_append_file $check_file "* hard core 0"
  check_file="/etc/sysctl.conf"
  check_file_value $check_file fs.suid_dumpable eq 0 hash
}
