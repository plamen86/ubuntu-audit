# audit_filesystem_partitions
#
# Check filesystems are on separate partitions
#
# Refer to Sections 1.1.2,5,6,10,11,12
#.

audit_filesystem_partitions() {
  for filesystem in /tmp /var /var/tmp /var/log /var/log/audit /home; do
    verbose_message "=============================================="
    verbose_message "Filesystem $filesystem is a separate partition"
    verbose_message "Sections 1.1.2,5,6,10,11,12"
	verbose_message "=============================================="
    mount_test=`mount |awk '{print $3}' |grep "^filesystem$"`
    if [ "$mount_test" != "$filesystem" ]; then
      increment_secure "Filesystem $filesystem is a separate filesystem"
    fi
  done
}
