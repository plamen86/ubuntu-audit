# audit_postfix_daemon
#
# Refer to Section(s) 2.2.15
#.

audit_postfix_daemon () {

  verbose_message="Section 2.2.15: Postfix Daemon"

  check_file="/etc/postfix/main.cf"
  check_file_value $check_file inet_interfaces eq localhost hash

}
