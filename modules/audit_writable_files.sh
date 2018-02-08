# audit_writable_files
#
# Refer to Section(s) 6.1.10   Page(s) 261     CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_writable_files () {

  if [ "$do_fs" = 1 ]; then
    verbose_message "Section 6.1.10: World Writable Files"
    log_file="worldwritable.log"

    find_command="df --local -P | awk {'if (NR!=1) print $6'} \
    | xargs -I '{}' find '{}' -xdev -type f -perm -0002"

    for check_file in `$find_command`; do
      increment_insecure "File $check_file is world writable"
    done
  fi
 }
