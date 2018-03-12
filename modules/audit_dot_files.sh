# audit_dot_files
#
# Check for a dot file and copy it to backup directory
#.

audit_dot_files () {
#  verbose_message "Dot Files"
  check_file=$1

  for dir_name in `cat /etc/passwd |cut -f6 -d':'`; do
    if [ "$dir_name" = "/" ]; then
      dot_file="/$check_file"
    else
      dot_file="$dir_name/$check_file"
    fi
    if [ -f "$dot_file" ]; then
      increment_insecure "File $dot_file exists"
#      verbose_message "mv $dot_file $dot_file.disabled" fix
    else
      increment_secure "File $dot_file does not exist"
    fi
  done
}
