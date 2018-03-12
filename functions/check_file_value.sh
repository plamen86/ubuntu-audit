# check_file_value
#
# Audit file values
#
# This routine takes four values
#
# check_file      = The name of the file to check
# parameter_name  = The parameter to be checked
# seperator       = Character used to seperate parameter name from it's value (eg =)
# correct_value   = The value we expect to be returned
# comment_value   = Character used as a comment (can be #, *, etc)
#
# If the current_value is not the correct_value then it is fixed if run in lockdown mode
# A copy of the value is stored in a log file, which can be restored
#.

check_file_value () {
  check_file=$1
  parameter_name=$2
  separator=$3
  correct_value=$4
  comment_value=$5
  position=$6
  search_value=$7
  sshd_test=`echo "$check_file" |grep "sshd_config"`

  if [ "$comment_value" = "star" ]; then
    comment_value="*"
  else
    if [ "$comment_value" = "bang" ]; then
      comment_value="!"
    else
      if [ "$comment_value" = "semicolon" ]; then
        comment_value=";"
      else
        comment_value="#"
      fi
    fi
  fi

  if [ `expr "$separator" : "eq"` = 2 ]; then
    separator="="
    spacer="\="
  else
    if [ `expr "$separator" : "space"` = 5 ]; then
      separator=" "
      spacer=" "
    else
      if [ `expr "$separator" : "colon"` = 5 ]; then
        separator=":"
        space=":"
      fi
    fi
  fi

  cat_command="sudo cat"
  sed_command="sudo sed"
  echo_command="sudo echo"

#  echo "Checking:  Value of \"$parameter_name\" is set to \"$correct_value\" in $check_file"
  if [ ! -f "$check_file" ]; then
    increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
  else
    if [ "$separator" = "tab" ]; then
      check_value=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |awk '{print $2}' |sed 's/"//g' |uniq |egrep "$correct_value"`
    else
      if [ "$sshd_test" ]; then
        check_value=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |cut -f2 -d"$separator" |sed 's/"//g' |sed 's/ //g' |uniq |egrep "$correct_value"`
        if [ ! "$check_value" ]; then
          check_value=`$cat_command $check_file |grep "$parameter_name" |cut -f2 -d"$separator" |sed 's/"//g' |sed 's/ //g' |uniq |egrep "$correct_value"`
        fi
      else
        check_value=`$cat_command $check_file |grep -v "^$comment_value" |grep "$parameter_name" |cut -f2 -d"$separator" |sed 's/"//g' |sed 's/ //g' |uniq |egrep "$correct_value"`
      fi
    fi
    if [ ! "$check_value" ]; then
      increment_insecure "Parameter \"$parameter_name\" not set to \"$correct_value\" in $check_file"
#      if [ "$check_parameter" != "$parameter_name" ]; then
#        if [ "$separator_value" = "tab" ]; then
#          verbose_message "" fix
#          verbose_message "echo -e \"$parameter_name\t$correct_value\" >> $check_file" fix
#          verbose_message "" fix
#        else
#          if [ "$position" = "after" ]; then
#            verbose_message "" fix
#            verbose_message "$cat_command $check_file |sed \"s,$search_value,&\n$parameter_name$separator$correct_value,\" > $temp_file" fix
#            verbose_message "$cat_command $temp_file > $check_file" fix
#            verbose_message "" fix
#          else
#            verbose_message "" fix
#            verbose_message "echo \"$parameter_name$separator$correct_value\" >> $check_file" fix
#            verbose_message "" fix
#          fi
#        fi
#      else
#        if [ "$check_file" = "/etc/default/sendmail" ] || [ "$check_file" = "/etc/sysconfig/mail" ] || [ "$check_file" = "/etc/rc.conf" ] || [ "$check_file" = "/boot/loader.conf" ] || [ "$check_file" = "/etc/sysconfig/boot" ]; then
#          verbose_message "" fix
#          verbose_message "$sed_command \"s/^$parameter_name.*/$parameter_name$spacer\"$correct_value\"/\" $check_file > $temp_file" fix
#        else
#          verbose_message "" fix
#          verbose_message "$sed_command \"s/^$parameter_name.*/$parameter_name$spacer$correct_value/\" $check_file > $temp_file" fix
#        fi
#        verbose_message "$cat_command $temp_file > $check_file" fix
#        verbose_message "" fix
#      fi
    else
      increment_secure "Parameter \"$parameter_name\" already set to \"$correct_value\" in $check_file"
    fi
  fi
}
