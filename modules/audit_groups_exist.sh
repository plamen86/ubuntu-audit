# audit_groups_exist
#
# Refer to Section 6.2.15
#.

audit_groups_exist () {

  verbose_message "6.2.15 => Ensure all groups in /etc/passwd exist in /etc/group"
    
  check_file="/etc/group"
  group_fail=0
    
  for group_id in `getent passwd |cut -f4 -d ":"`; do
    group_exists=`cat $check_file |grep -v "^#" |cut -f3 -d":" |grep "^$group_id$" |wc -l |sed "s/ //g"`
    if [ "$group_exists" = 0 ]; then
      group_fail=1
      increment_insecure "Group $group_id does not exist in group file"
    fi
  done

  if [ "$group_fail" != 1 ]; then
    increment_secure "No non existant group issues"
  fi
}
