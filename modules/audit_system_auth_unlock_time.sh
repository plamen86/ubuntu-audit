# audit_system_auth_unlock_time
#
# Refer to Section(s) 6.3.3 Page(s) 139-140 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.3.3 Page(s) 143-4   CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.3.2 Page(s) 234     CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_system_auth_unlock_time () {
  auth_string=$1
  search_string=$2
  search_value=$3

  for check_file in /etc/pam.d/system-auth /etc/pam.d/common-auth; do
    if [ -f "$check_file" ]; then
#      verbose_message "Lockout time for failed password attempts enabled in $check_file"
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk -F '$search_string=' '{print $2}' |awk '{print $1}'`
      if [ "$check_value" != "$search_string" ]; then
        increment_insecure "Lockout time for failed password attempts not enabled in $check_file"
#        verbose_message "cp $check_file $temp_file" fix
#        verbose_message "cat $temp_file |awk '( $1 == \"auth\" && $2 == \"required\" && $3 == \"pam_tally2.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail audit silent deny=5 unlock_time=900\"; print $0; next };' > $check_file" fix
#        verbose_message "rm $temp_file" fix
      else
        increment_secure "Lockout time for failed password attempts enabled in $check_file"
      fi
    fi
  done
}
