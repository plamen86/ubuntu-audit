# audit_duplicate_groups
#
# Refer to Section(s) 6.2.17,19 Page(s) 284,6        CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_duplicate_groups () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "AIX" ]; then
    verbose_message "Duplicate Groups"
    audit_duplicate_ids 1 groups name /etc/group
    audit_duplicate_ids 3 groups id /etc/group
  fi
}
