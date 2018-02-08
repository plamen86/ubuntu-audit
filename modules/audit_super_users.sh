# audit_super_users
#
# Refer to Sections 6.2.5
#.

audit_super_users() {

  verbose_message "Sections 6.2.5: Accounts with UID 0"
    
  for user_name in `awk -F: '$3 == "0" { print $1 }' /etc/passwd |grep -v root`; do
    increment_insecure "UID 0 for $user_name"
  done

  if [ "$user_name" = "" ]; then
    increment_secure "No accounts other than root have UID 0"
  fi
}
