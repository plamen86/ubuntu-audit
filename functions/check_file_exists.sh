#
# check_file_exists
#
# Check to see a file exists and create it or delete it
#
# check_file    = File to check fo
# check_exists  = If equal to no and file exists, delete it
#                 If equal to yes and file doesn't exist, create it
#.

check_file_exists () {
  check_file=$1
  check_exists=$2
  log_file="$work_dir/file.log"
  if [ "$check_exists" = "no" ]; then
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  File $check_file does not exist"
    fi
    if [ -f "$check_file" ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_insecure "File $check_file exists"
      fi
      if [ "$audit_mode" = 0 ]; then
        backup_file $check_file
        echo "Removing:  File $check_file"
        echo "$check_file,rm" >> $log_file
        rm $check_file
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        increment_secure "File $check_file does not exist"
      fi
    fi
  else
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  File $check_file exists"
    fi
    if [ ! -f "$check_file" ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_insecure "File $check_file does not exist"
      fi
      if [ "$audit_mode" = 0 ]; then
        echo "Creating:  File $check_file"
        touch $check_file
        echo "$check_file,touch" >> $log_file
      fi
    else
      if [ "$audit_mode" = 1 ]; then
        increment_secure "File $check_file exists"
      fi
    fi
  fi
  if [ "$audit_mode" = 2 ]; then
    restore_file $check_file $restore_dir
  fi
}
