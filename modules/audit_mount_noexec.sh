# audit_mount_noexec
#
# Refer to Sections 1.1.9,16,19
#.

audit_mount_noexec_old () {

  verbose_message "Sections 1.1.9,16,19: Filesystems mounted with noexec"

  check_file="/etc/fstab"
  if [ -e "$check_file" ]; then
    noexec_check=`cat $check_file |grep -v "^#" |grep "tmpfs" |grep -v noexec |head -1 |wc -l`
    if [ "$noexec_check" = 1 ]; then
      increment_insecure "Found tmpfs filesystems that should be mounted noexec"
#      verbose_message "" fix
#      verbose_message "cat $check_file | awk '( $3 ~ /^tmpfs$/ ) { $4 = $4 \",noexec\" }; { printf \"%-26s %-22s %-8s %-16s %-1s %-1s\n\",$1,$2,$3,$4,$5,$6 }' > $temp_file" fix
#      verbose_message "cat $temp_file > $check_file" fix
#      verbose_message "rm $temp_file" fix
#      verbose_message "" fix
    else
      increment_secure "No filesystem that should be mounted with noexec"
    fi
  fi
    
  check_file_perms $check_file 0644 root root
}