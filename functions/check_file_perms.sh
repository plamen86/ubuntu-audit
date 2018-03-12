# check_file_perms
#
# Code to check permissions on a file
# If running in audit mode it will check permissions and report
# If running in lockdown mode it will fix permissions if they
# don't match those passed to routine
# Takes:
# check_file:   Name of file
# check_perms:  Octal of file permissions, eg 755
# check_owner:  Owner of file
# check_group:  Group ownership of file
#.

check_file_perms () {
  check_file=$1
  check_perms=$2
  check_owner=$3
  check_group=$4
  
  if [ "$id_check" = "0" ]; then
    find_command="find"
  else
    find_command="sudo find"
  fi
  
  echo "Checking:  File permissions on $check_file"
  
  if [ ! -e "$check_file" ]; then
    echo "Notice:    File $check_file does not exist"
    return
  fi
  
  if [ "$check_owner" != "" ]; then
    check_result=`find "$check_file" -perm $check_perms -user $check_owner -group $check_group -depth 0 2> /dev/null`
  else
    check_result=`find "$check_file" -perm $check_perms -depth 0 2> /dev/null`
  fi
  
  if [ "$check_result" != "$check_file" ]; then
    increment_insecure "File $check_file has incorrect permissions"
#    verbose_message "" fix
#    verbose_message "chmod $check_perms $check_file" fix
#    if [ "$check_owner" != "" ]; then
#      verbose_message "chown $check_owner:$check_group $check_file" fix
#    fi
#    verbose_message "" fix
  else
    increment_secure "File $check_file has correct permissions"
  fi
}
