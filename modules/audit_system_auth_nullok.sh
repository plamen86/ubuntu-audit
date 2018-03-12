# audit_system_auth_nullok
#
# Ensure null passwords are not accepted
#.

audit_system_auth_nullok () {

  for check_file in etc/pam.d/common-auth /etc/pam.d/system-auth; do
    if [ -f "$check_file" ]; then
#      verbose_message "For nullok entry in $check_file"
      check_value=0
      check_value=`cat $check_file |grep -v '^#' |grep 'nullok' |head -1 |wc -l`
      if [ "$check_value" = 1 ]; then
        increment_insecure "Found nullok entry in $check_file"
#        verbose_message "cp $check_file $temp_file" fix
#        verbose_message "cat $temp_file |sed 's/ nullok//' > $check_file" fix
#        verbose_message "rm $temp_file" fix
      else
        increment_secure "No nullok entries in $check_file"
      fi
    fi
  done
}
