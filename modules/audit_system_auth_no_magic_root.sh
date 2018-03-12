# audit_system_auth_no_magic_root
#
# Make sure root account isn't locked as part of account locking
#.

audit_system_auth_no_magic_root () {
  auth_string=$1
  search_string=$2

  for check_file in /etc/pam.d/common-auth /etc/pam.d/system-auth; do 
    if [ -f "$check_file" ]; then
#      verbose_message "Auth entry not enabled in $check_file"
      check_value=`cat $check_file |grep '^$auth_string' |grep '$search_string$' |awk '{print $5}'`
      if [ "$check_value" != "$search_string" ]; then
        increment_insecure "Auth entry not enabled in $check_file"
#        verbose_message "rm $temp_file" fix
#        verbose_message "cat $temp_file |awk '( $1 == \"auth\" && $2 == \"required\" && $3 == \"pam_deny.so\" ) { print \"auth\trequired\tpam_tally2.so onerr=fail no_magic_root\"; print $0; next };' > $check_file" fix
#        verbose_message "rm $temp_file" fix
      else
        increment_secure "Auth entry enabled in $check_file"
      fi
    fi
  done
}
