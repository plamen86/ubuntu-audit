# audit_writable_files
#
# Refer to Section(s) 6.1.10
#

audit_writable_files () {

  verbose_message "Section 6.1.10: World Writable Files"
  
  find_command=`df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002`

  for check_file in "$find_command"; do
    increment_insecure "File $check_file is world writable"
#    verbose_message "" fix
#    verbose_message "chmod o-w $check_file" fix
#    verbose_message "" fix
  done
}
