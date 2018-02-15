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

  if [ "$check_exists" = "no" ]; then
    echo "Checking:  File $check_file does not exist"
    if [ -f "$check_file" ]; then
      increment_insecure "File $check_file exists"
    else
      increment_secure "File $check_file does not exist"
    fi
  else
    echo "Checking:  File $check_file exists"
    if [ ! -f "$check_file" ]; then
      increment_insecure "File $check_file does not exist"
    else
      increment_secure "File $check_file exists"
    fi
  fi
}
