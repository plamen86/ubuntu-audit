# audit_grub_security
#
# Refer to Sections 1.4.1,2
#.

audit_grub_security () {

  verbose_message "Section 1.4.1-2: Secure Boot Settings"
  
  for check_file in /etc/grub.conf /boot/grub/grub.cfg /boot/grub/menu.list; do
    check_file_perms $check_file 0600 root root
  done

  check_file="/boot/grub/grub.cfg"
  
  grub_user=`cat $check_file | grep "^set superusers" | wc -l`
  grub_pass=`cat $check_file | grep "^password" | wc -l`
  
  if [ "$grub_user" = "1" ] && [ "$grub_pass" = "1" ]; then
    increment_secure "Grub password is set"
  else
  	increment_insecure "Grub passowrd is not set"
  fi
 }
