# audit_duplicate_groups
#
# Refer to Sections 6.2.17,19
#.

audit_duplicate_groups () {
  verbose_message "Sections 6.2.17,19: Duplicate Groups"

  audit_duplicate_ids 1 groups name /etc/group
  audit_duplicate_ids 3 groups id /etc/group
}
