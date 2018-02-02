# backup_file
#
# Backup file
#.

backup_file () {
  check_file=$1
  if [ "$audit_mode" = 0 ]; then
    backup_file="$work_dir$check_file"
    if [ ! -f "$backup_file" ]; then
      echo "Saving:    File $check_file to $backup_file"
      find $check_file | cpio -pdm $work_dir 2> /dev/null
      if [ "$check_file" = "/etc/system" ]; then
        reboot=1
      	echo "Notice:    Reboot required"
      fi
      if [ "$check_file" = "/etc/ssh/sshd_config" ] || [ "$check_file" = "/etc/sshd_config" ]; then
         echo "Notice:    Service restart required for SSH"
      fi
    fi
  fi
}
