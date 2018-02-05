# audit_sticky_bit
#
# Refer to Section 1.1.20
# 
#.

audit_sticky_bit () {

  verbose_message "=========================================="
  verbose_message "World Writable Directories and Sticky Bits"
  verbose_message "Section 1.1.20"
  verbose_message "=========================================="

  log_file="$work_dir/sticky_bits"
  for check_dir in `find / \( -fstype nfs -o -fstype cachefs \
    -o -fstype autofs -o -fstype ctfs \
    -o -fstype mntfs -o -fstype objfs \
    -o -fstype proc \) -prune -o -type d \
    \( -perm -0002 -a -perm -1000 \) -print`; do
           
    increment_insecure "Sticky bit not set on $check_dir"
    verbose_message "" fix
    verbose_message "chmod +t $check_dir" fix
    verbose_message "" fix
  done
}
