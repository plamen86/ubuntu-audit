# audit_pam_wheel
#
# PAM Wheel group membership. Make sure wheel group membership is required to su.
#
# Refer to Section 5.6
#.

audit_pam_wheel () {

  verbose_message "Section 5.6: PAM SU Configuration"

  check_file="/etc/pam.d/su"
  search_string="use_uid"

  check_value=`cat $check_file |grep '^auth' |grep '$search_string$' |awk '{print $8}'`

  if [ "$check_value" != "$search_string" ]; then
    increment_insecure "Wheel group membership not required for su in $check_file"
  else
    increment_secure "Wheel group membership required for su in $check_file"
  fi
}
