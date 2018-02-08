# audit_root_path
#
# Refer to Section 6.2.6
#.

audit_root_path () {

  verbose_message "Section 6.2.6: Root PATH Environment Integrity"

  if [ "`echo $PATH | grep :: `" != "" ]; then
    increment_insecure "Empty directory in PATH"
  else
    increment_secure "No empty directory in PATH"
  fi

  if [ "`echo $PATH | grep :$`"  != "" ]; then
    increment_insecure "Trailing : in PATH"
  else
    increment_secure "No trailing : in PATH"
  fi

  for dir_name in `echo $PATH | sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`; do
    if [ "$dir_name" = "." ]; then
      increment_insecure "PATH contains ."
    fi
    if [ -d "$dir_name" ]; then
      dir_perms=`ls -ld $dir_name | cut -f1 -d" "`
      if [ "`echo $dir_perms | cut -c6`" != "-" ]; then
        increment_insecure "Group write permissions set on directory $dir_name"
      else
        increment_secure "Group write permission not set on directory $dir_name"
      fi
      if [ "`echo $dir_perms | cut -c9`" != "-" ]; then
        increment_insecure "Other write permissions set on directory $dir_name"
      else
        increment_secure "Other write permission not set on directory $dir_name"
      fi
    fi
  done
}
