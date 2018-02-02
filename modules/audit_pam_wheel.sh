# audit_pam_wheel
#
# PAM Wheel group membership. Make sure wheel group membership is required to su.
#
# Refer to Section(s) 6.5 Page(s) 142-3 CIS CentOS Linux 6 Benchmark v1.0.0
# Refer to Section(s) 6.5 Page(s) 165-6 CIS RHEL 5 Benchmark v2.1.0
# Refer to Section(s) 6.5 Page(s) 145-6 CIS RHEL 6 Benchmark v1.2.0
# Refer to Section(s) 5.6 Page(s) 257-8 CIS RHEL 7 Benchmark v2.1.0
# Refer to Section(s) 9.5 Page(s) 135-6 CIS SLES 11 Benchmark v1.0.0
# Refer to Section(s) 5.5 Page(s) 235-6 CIS Amazon Linux Benchmark v2.0.0
# Refer to Section(s) 5.6 Page(s) 249   CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_pam_wheel () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "PAM SU Configuration"
    check_file="/etc/pam.d/su"
    search_string="use_uid"
    if [ "$audit_mode" != 2 ]; then
      check_value=`cat $check_file |grep '^auth' |grep '$search_string$' |awk '{print $8}'`
      if [ "$check_value" != "$search_string" ]; then
        if [ "$audit_mode" = "1" ]; then
          increment_insecure "Wheel group membership not required for su in $check_file"
          verbose_message "" fix
          verbose_message "cp $check_file $temp_file" fix
          verbose_message "cat $temp_file |awk '( $1==\"#auth\" && $2==\"required\" && $3~\"pam_wheel.so\" ) { print \"auth\t\trequired\t\",$3,\"\tuse_uid\"; next }; { print }' > $check_file" fix
          verbose_message "rm $temp_file" fix
          verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          backup_file $check_file
          echo "Setting:   Su to require wheel group membership in PAM in $check_file"
          cp $check_file $temp_file
          cat $temp_file |awk '( $1=="#auth" && $2=="required" && $3~"pam_wheel.so" ) { print "auth\t\trequired\t",$3,"\tuse_uid"; next }; { print }' > $check_file
          rm $temp_file
        fi
      else
        if [ "$audit_mode" = "1" ]; then
          increment_secure "Wheel group membership required for su in $check_file"
        fi
      fi
    else
      restore_file $check_file $restore_dir
    fi
  fi
}
