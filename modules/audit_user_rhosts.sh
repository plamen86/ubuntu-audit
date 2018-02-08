# audit_user_rhosts
#
# Refer to Section 6.2.14
#.

audit_user_rhosts () {
  verbose_message "Section 6.2.14: User RHosts Files"

  check_fail=0
  for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$"`; do
    check_file="$home_dir/.rhosts"
    if [ -f "$check_file" ]; then
      check_fail=1
      check_file_exists $check_file no
    fi
  done

  if [ "$check_fail" != 1 ]; then
    increment_secure "No user rhosts files exist"
  fi
}
