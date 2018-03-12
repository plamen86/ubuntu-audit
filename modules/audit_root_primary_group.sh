# audit_root_primary_group
#
# Refer to Section 5.4.3
#.

audit_root_primary_group () {
	
  verbose_message "Section 5.4.3: Root Primary Group"
  
  check_file="/etc/group"
  group_check=`grep "^root:" /etc/passwd | cut -f4 -d:`

  if [ "$group_check" != "0" ];then
    increment_insecure "Group $group_id does not exist in group file"
  else
    increment_secure "Primary group for root is root"
  fi
}
