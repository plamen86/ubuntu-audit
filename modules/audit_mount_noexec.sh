# audit_mount_noexec
#
# Refer to Sections 1.1.9,16,19
# FIXME
#.

audit_mount_noexec () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "No-exec on /tmp"
    check_file="/etc/fstab"
    if [ -e "$check_file" ]; then
      verbose_message "Temp File Systems mounted with noexec"
      if [ "$audit_mode" != "2" ]; then
        nodev_check=`cat $check_file |grep -v "^#" |grep "tmpfs" |grep -v noexec |head -1 |wc -l`
        if [ "$nodev_check" = 1 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Found tmpfs filesystems that should be mounted noexec"
            verbose_message "" fix
            verbose_message "cat $check_file | awk '( $3 ~ /^tmpfs$/ ) { $4 = $4 \",noexec\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
            verbose_message "cat $temp_file > $check_file" fix
            verbose_message "rm $temp_file" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Setting noexec on tmpfs"
            backup_file $check_file
            cat $check_file | awk '( $3 ~ /^tmpfs$/ ) { $4 = $4 ",noexec" }; { printf "%-26s %-22s %-8s %-16s %-1s %-1s\n",$1,$2,$3,$4,$5,$6 }' > $temp_file
            cat $temp_file > $check_file
            rm $temp_file
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "No filesystem that should be mounted with noexec"
          fi
          if [ "$audit_mode" = 2 ]; then
            restore_file $check_file $restore_dir
          fi
        fi
      fi
      check_file_perms $check_file 0644 root root
    fi
  fi
}
