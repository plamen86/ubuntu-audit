# audit_sticky_bit
#
# Refer to Section 1.1.20
# FIXME
#.

audit_sticky_bit () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    if [ "$do_fs" = 1 ]; then
      verbose_message "World Writable Directories and Sticky Bits"
      if [ "$os_version" = "10" ]; then
        log_file="$work_dir/sticky_bits"
        for check_dir in `find / \( -fstype nfs -o -fstype cachefs \
          -o -fstype autofs -o -fstype ctfs \
          -o -fstype mntfs -o -fstype objfs \
          -o -fstype proc \) -prune -o -type d \
          \( -perm -0002 -a -perm -1000 \) -print`; do
          if [ "$audit_mode" = 1 ]; then
            
            increment_insecure "Sticky bit not set on $check_dir"
            verbose_message "" fix
            verbose_message "chmod +t $check_dir" fix
            verbose_message "" fix
          fi
          if [ "$audit_mode" = 0 ]; then
            echo "Setting:   Sticky bit on $check_dir"
            chmod +t $check_dir
            echo "$check_dir" >> $log_file
          fi
        done
        if [ "$audit_mode" = 2 ]; then
          restore_file="$restore_dir/sticky_bits"
          if [ -f "$restore_file" ]; then
            for check_dir in `cat $restore_file`; do
              if [ -d "$check_dir" ]; then
                echo "Restoring:  Removing sticky bit from $check_dir"
                chmod -t $check_dir
              fi
            done
          fi
        fi
      fi
    fi
  fi
}
