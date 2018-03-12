# check_append_file
#
# Code to append a file with a line
#
# check_file      = The name of the original file
# parameter       = The parameter/line to add to a file
# comment_value   = The character used in the file to distinguish a line as a comment
#.

check_append_file () {
  check_file=$1
  parameter=$2
  comment_value=$3
  
  if [ "$comment_value" = "star" ]; then
    comment_value="*"
  else
    comment_value="#"
  fi
  
#  verbose_message "Parameter \"$parameter\" is set in $check_file"

  if [ ! -f "$check_file" ]; then
    increment_insecure "Parameter \"$parameter\" does not exist in $check_file"
#    lockdown_command "echo \"$parameter\" >> $check_file"
  else
    if [ "$parameter" ]; then
      check_value=`cat "$check_file" |grep -v "^$comment_value" |grep '$parameter'`
      if [ "$check_value" != "$parameter" ]; then
        increment_insecure "Parameter \"$parameter\" does not exist in $check_file"
 #       lockdown_command "echo \"$parameter\" >> $check_file"
      else
        increment_secure "Parameter \"$parameter\" exists in $check_file"
      fi
    fi
  fi
}
