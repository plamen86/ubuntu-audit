# audit_system_auth_password_strength
#
#.

audit_system_auth_password_strength () {
  auth_string=$1
  search_string=$2

  for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do
    if [ -f "$check_file" ]; then
#      verbose_message "Password minimum strength enabled in $check_file"
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        increment_insecure "Password strength settings not enabled in $check_file"
#        verbose_message "cp $check_file $temp_file" fix
#        verbose_message "cat $temp_file |sed 's/^password.*pam_deny.so$/&\npassword\t\trequisite\t\t\tpam_passwdqc.so min=disabled,disabled,16,12,8/' > $check_file" fix
#        verbose_message "rm $temp_file" fix
      else
        increment_secure "Password strength settings enabled in $check_file"
      fi
    fi
  done
}
