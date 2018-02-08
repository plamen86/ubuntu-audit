# audit_duplicate_users
#
# Refer to Sections 6.2.16,18
#.

audit_duplicate_users () {
    verbose_message "Sections 6.2.16,18: Duplicate Users"

    audit_duplicate_ids 1 users name /etc/passwd
    audit_duplicate_ids 3 users id /etc/passwd
}
