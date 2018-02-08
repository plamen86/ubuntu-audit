# audit_samba
#
# Refer to Sections 2.2.12
#.

audit_samba () {
  verbose_message "Sections 2.2.12: Samba Daemons"
  
  service_name="smb"
  check_systemctl_service disable $service_name
  check_chkconfig_service $service_name 3 off
  check_chkconfig_service $service_name 5 off
  check_linux_package uninstall samba

  for check_dir in /etc /etc/sfw /etc/samba /usr/local/etc /usr/sfw/etc /opt/sfw/etc; do
    check_file="$check_dir/smb.conf"
    if [ -f "$check_file" ]; then
      check_file_value $check_file "restrict anonymous" eq 2 semicolon after "\[Global\]"
      check_file_value $check_file "guest OK" eq no semicolon after "\[Global\]"
      check_file_value $check_file "client ntlmv2 auth" eq yes semicolon after "\[Global\]"
    fi
  done
}
