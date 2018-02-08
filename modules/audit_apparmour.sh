# audit_apparmour
# Refer to Sections 1.6.2.1, 1.6.3
#.

audit_apparmour () {

  verbose_message "Sections 1.6.2.1, 1.6.3: AppArmour"

  check_linux_package install apparmour
  check_file="/boot/grub/menu.lst"

  if [ -f "$check_file" ]; then
    armour_test=`cat $check_file |grep "apparmour=0" |head -1 |wc -l`
  else
    armour_test=0
  fi
  if [ "$armour_test" = "1" ]; then
    increment_insecure "AppArmour is not enabled"
    temp_file="$temp_dir/apparmour"
    backup_file $check_file
    lockdown_command "cat $check_file |sed 's/apparmour=0//g' < $temp_file ; cat $temp_file > $check_file ; enforce /etc/apparmor.d/*" "Enabling AppArmour"
  else
    increment_secure "AppArmour enabled"
  fi
}
