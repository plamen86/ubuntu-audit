# audit_system_auth_account_reset
#
# Refer to Section(s) 6.3.2 Page(s) 161-2 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 9.3.2 Page(s) 133-4 CIS SLES 11 Benchmark v1.0.0
#.

audit_system_auth_account_reset () {
  auth_string=$1
  search_string=$2

  for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
    if [ -f "$check_file" ]; then
#      verbose_message "Account reset entry not enabled in $check_file"
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $6}'`
      if [ "$check_value" != "$search_string" ]; then
        increment_insecure "Account reset entry not enabled in $check_file"
#        verbose_message "cp $check_file $temp_file" fix
#        verbose_message "cat $temp_file |awk '( $1 == \"account\" && $2 == \"required\" && $3 == \"pam_permit.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail no_magic_root reset\"; print $0; next };' > $check_file" fix
#        verbose_message "rm $temp_file" fix
      else
        increment_secure "Account entry enabled in $check_file"
      fi
    fi
  done
}
