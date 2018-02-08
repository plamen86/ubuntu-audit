# audit_password_fields
#
# Ensure Password Fields are Not Empty
# Verify System Account Default Passwords
# Ensure Password Fields are Not Empty
#
# Refer to Sections 6.2.1-4
#.

audit_password_fields () {

  verbose_message "Sections 6.2.1-4: Password Fields"

  check_file="/etc/shadow"
  empty_count=0

  users=`cat /etc/shadow |awk -F':' '{print $1":"$2":"}' |grep "::$" |cut -f1 -d:`

  for user_name in $users; do
    empty_count=1
    increment_insecure "No password field for $user_name in $check_file"
  done

  if [ "$empty_count" = 0 ]; then
    increment_secure "No empty password entries"
  fi

  for check_file in /etc/passwd /etc/shadow; do
    legacy_check=`cat $check_file |grep '^+:' |head -1 |wc -l`
    if [ "$legacy_check" != "0" ]; then
      increment_insecure "Legacy field found in $check_file"
    else
      increment_secure "No legacy entries in $check_file"
    fi
  done
}
