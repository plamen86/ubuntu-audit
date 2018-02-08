# audit_system_auth
#
# Refer to Sections 5.3.1-4
#.

audit_system_auth () {
  verbose_message "Sections 5.3.1-4:PAM Authentication"

  check_file="/etc/security/pwquality.conf"
#  check_file_value $check_file minlen eq 14 hash  
#  check_file_value $check_file dcredit eq -1 hash  
#  check_file_value $check_file ocredit eq -1 hash  
#  check_file_value $check_file ucredit eq -1 hash  
#  check_file_value $check_file lcredit eq -1 hash  
  audit_system_auth_nullok
  auth_string="auth"
  search_string="unlock_time"
  search_value="900"
  audit_system_auth_unlock_time $auth_string $search_string $search_value
  auth_string="account"
  search_string="remember"
  search_value="5"
  audit_system_auth_password_history $auth_string $search_string $search_value
  auth_string="password"
  search_string="sha512"
  audit_system_auth_password_hashing $auth_string $search_string

  check_rpm libpam-cracklib

  audit_system_auth_nullok
  auth_string="account"
  search_string="remember"
  search_value="10"
  audit_system_auth_password_history $auth_string $search_string $search_value
  auth_string="auth"
  search_string="no_magic_root"
  audit_system_auth_no_magic_root $auth_string $search_string
  auth_string="account"
  search_string="reset"
  audit_system_auth_account_reset $auth_string $search_string
  auth_string="password"
  search_string="minlen"
  search_value="9"
  audit_system_auth_password_policy "$auth_string" "$search_string" "$search_value"
  auth_string="password"
  search_string="dcredit"
  search_value="-1"
  audit_system_auth_password_policy "$auth_string" "$search_string" "$search_value"
  auth_string="password"
  search_string="lcredit"
  search_value="-1"
  audit_system_auth_password_policy "$auth_string" "$search_string" "$search_value"
  auth_string="password"
  search_string="ocredit"
  search_value="-1"
  audit_system_auth_password_policy "$auth_string" "$search_string" "$search_value"
  auth_string="password"
  search_string="ucredit"
  search_value="-1"
  audit_system_auth_password_policy "$auth_string" "$search_string" "$search_value"
  auth_string="password"
  search_string="16,12,8"
  audit_system_auth_password_strength $auth_string $search_string
  auth_string="auth"
  search_string="unlock_time"
  search_value="900"
  audit_system_auth_unlock_time $auth_string $search_string $search_value
}
