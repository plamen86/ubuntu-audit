# audit_password_expiry
#
# Refer to Sections 5.4.1.1-4
#.

audit_password_expiry () {
  verbose_message "Sections 5.4.1.1-4: Password Expiration Parameters on Active Accounts"

  check_file="/etc/login.defs"
  check_file_value $check_file PASS_MAX_DAYS eq 90 hash
  check_file_value $check_file PASS_MIN_DAYS eq 7 hash
  check_file_value $check_file PASS_WARN_AGE eq 14 hash
  check_file_value $check_file PASS_MIN_LEN eq 9 hash
  check_file_perms $check_file 0640 root root
}
