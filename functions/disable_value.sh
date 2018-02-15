# disable_value
#
# Code to comment out a line
#
# This routine takes 3 values
# check_file      = Name of file to check
# parameter_name  = Line to comment out
# comment_value   = The character to use as a comment, eg # (passed as hash)
#.

disable_value () {
  check_file=$1
  parameter_name=$2
  comment_value=$3
  if [ -f "$check_file" ]; then
    if [ "$comment_value" = "star" ]; then
      comment_value="*"
    else
      if [ "$comment_value" = "bang" ]; then
        comment_value="!"
      else
        comment_value="#"
      fi
    fi

    echo "Checking:  Parameter \"$parameter_name\" in $check_file is disabled"
    if [ "$separator" = "tab" ]; then
      check_value=`cat $check_file |grep -v "^$comment_value" |grep "$parameter_name" |uniq`
      if [ "$check_value" != "$parameter_name" ]; then
        increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
      fi
    else
      increment_secure "Parameter \"$parameter_name\" already set to \"$correct_value\" in $check_file"
    fi
  fi
}
