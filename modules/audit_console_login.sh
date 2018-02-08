# audit_console_login
#
# Refer to Section 5.5
#.

audit_console_login () {

  verbose_message "Section 5.5: Root Login to System Console"
    
  disable_ttys=0
  check_file="/etc/securetty"
  console_list=""

  for console_device in `cat $check_file |grep '^tty[0-9]'`; do
    disable_ttys=1
    console_list="$console_list $console_device"
  done
  
  if [ "$disable_ttys" = 1 ]; then
    increment_insecure "Consoles enabled on$console_list"
  else
    increment_secure "No consoles enabled on tty[0-9]*"
  fi
}
