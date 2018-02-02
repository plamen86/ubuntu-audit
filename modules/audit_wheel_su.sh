# audit_wheel_su
#
# Make sure su has a wheel group ownership
#.

audit_wheel_su () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "Darwin" ]; then
  	verbose_mode "Wheel group ownership"
    check_file=`which su`
    check_file_perms $check_file 4750 root $wheel_group
  fi
}
