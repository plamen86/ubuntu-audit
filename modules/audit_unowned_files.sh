# audit_unowned_files
#
# Refer to Section(s) 6.1.11-2
#.

audit_unowned_files () {

  verbose_message "Section(s) 6.1.11-2: Unowned Files and Directories"

  $command=`df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser`

  for check_file in "$command"; do
    increment_insecure "File $check_file is unowned"
  done
}
