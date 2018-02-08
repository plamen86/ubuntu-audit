# audit_suid_files
#
# Refer to Sections 6.1.13-4
#.

audit_suid_files () {

  verbose_message "Sections 6.1.13-4: Set UID/GID Files"

  find_command="df --local -P | awk {'if (NR!=1) print $6'} \
  | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print"

  for check_file in `$find_command`; do
    increment_insecure "File $check_file is SUID/SGID"
    file_type=`file $check_file |awk '{print $5}'`
    if [ "$file_type" != "script" ]; then
      elfsign_check=`elfsign verify -e $check_file 2>&1`
      echo "Result:    $elfsign_check"
    else
      echo "Result:    Shell script"
    fi
  done
}
