# audit_system_accounts
#
# Refer to Section 5.4.2
#.

audit_system_accounts () {
  verbose_message "Sections 5.4.2: System Accounts that do not have a shell"

  check_file="/etc/passwd"

  for user_name in `cat /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<500 && $7!="/sbin/nologin" && $7!="/bin/false" ) {print $1}'`; do
    shadow_field=`grep "$user_name:" /etc/shadow |egrep -v "\*|\!\!|NP|UP|LK" |cut -f1 -d:`;
    if [ "$shadow_field" = "$user_name" ]; then
      increment_insecure "System account $user_name has an invalid shell but the account is disabled"
    else
      increment_insecure "System account $user_name has an invalid shell"
    fi
  done
}
