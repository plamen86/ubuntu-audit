# audit_suid_files
#
# Refer to Sections 6.1.13-4
#.

audit_suid_files () {

  verbose_message "Sections 6.1.13-4: Set UID/GID Files"

  find_command=`df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print`
                


  for check_file in "$find_command"; do
    increment_insecure "File $check_file is SUID/SGID"
  done
}
