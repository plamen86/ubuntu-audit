# audit_filesystem_partitions
#
# Check filesystems are on separate partitions
#
# Refer to Sections 1.1.2,5,6,10,11,12
#.

audit_filesystem_partitions() {
  for filesystem in /tmp /var /var/tmp /var/log /var/log/audit /home; do
#    verbose_message "Sections 1.1.2,5,6,10,11,12: Filesystem $filesystem is a separate partition"

    mount_test=`mount | grep "$filesystem" | awk '{print $3}'`
    if [ "$mount_test" = "$filesystem" ]; then
      increment_secure "Filesystem $filesystem is a separate partition"
#      echo "OK"
    else
      increment_insecure "Filesystem $filesystem is not on a separate partition"
#      echo "FAIL"
    fi
  done
}
