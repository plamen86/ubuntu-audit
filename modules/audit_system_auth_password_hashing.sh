# audit_system_auth_password_hashing
#
# Refer to Section(s) 5.3.4 Page(s) 243   CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 5.3.4 Page(s) 224   CIS Amazon Linux Benchmark v2.0.0
#.

audit_system_auth_password_hashing () {
  auth_string=$1
  search_string=$2

  for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
    if [ -f "$check_file" ]; then
      verbose_message "Password minimum strength enabled in $check_file"
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        increment_insecure "Password strength settings not enabled in $check_file"
#        verbose_message "cp $check_file $temp_file" fix
#        verbose_message "cat $temp_file |sed 's/^password\ssufficient\spam_unix.so/password sufficient pam_unix.so sha512/g' > $check_file" fix
#        verbose_message "rm $temp_file"
      else
        increment_secure "Password strength settings enabled in $check_file"
      fi
    fi
  done
}
