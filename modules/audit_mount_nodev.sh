# audit_mount_nodev
#
# Refer to Sections 1.1.3,7,13,14,17
#.

audit_mount_nodev () {
  check_file="/etc/fstab"
  if [ -e "$check_file" ]; then
    verbose_message "Sections 1.1.3,7,13,14,17: File Systems mounted with nodev"
    
    nodev_check=`cat $check_file |grep -v "^#" |egrep "ext2|ext3|swap|tmpfs" |grep -v '/ ' |grep -v '/boot' |head -1 |wc -l`
    if [ "$nodev_check" = 1 ]; then
      increment_insecure "Found filesystems that should be mounted nodev"
#      verbose_message "" fix
#      verbose_message "cat $check_file | awk '( $3 ~ /^ext[2,3,4]|tmpfs$/ && $2 != \"/\" ) { $4 = $4 \",nodev\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
#      verbose_message "cat $temp_file > $check_file" fix
#      verbose_message "rm $temp_file" fix
#      verbose_message "" fix
    else
      increment_secure "No filesystem that should be mounted with nodev"
    fi
  fi
  check_file_perms $check_file 0644 root root
}
