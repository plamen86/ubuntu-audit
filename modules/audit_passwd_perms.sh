# audit_passwd_perms
#
# Refer to Sections 6.1.2-9
#.

audit_passwd_perms () {

  verbose_message "Sections 6.1.2-9: Group and Password File Permissions"

  for check_file in /etc/passwd /etc/group ; do
    check_file_perms $check_file 0644 root root
  done

  for check_file in /etc/shadow /etc/gshadow; do
    check_file_perms $check_file 0600 root root
  done

  for check_file in /etc/group- /etc/passwd- /etc/shadow- /etc/gshadow-; do
    check_file_perms $check_file 0600 root root
  done
}
