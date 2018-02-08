# audit_issue_banner
#
# Refer to Sections 1.7.1.1-6
#.

audit_issue_banner () {

    verbose_message "Sections 1.7.1.1-6 => Security Warning Message"

    file_list="/etc/issue /etc/motd /etc/issue.net"

    for check_file in $file_list; do
      check_file_perms $check_file 0644 root root
      issue_check=0
      if [ -f "$check_file" ]; then
        issue_check=`cat $check_file |grep 'NOTICE TO USERS' |wc -l`
      fi

      echo "Checking:  Security message in $check_file"
      
      if [ "$issue_check" != 1 ]; then
        increment_insecure "No security message in $check_file"
      else
        increment_secure "Security message in $check_file"
      fi
    done
}
