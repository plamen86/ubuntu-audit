# audit_home_ownership
#
# Refer to Sections 6.2.7,9
#.

audit_home_ownership() {

    verbose_message "Section 6.2.7,9: Ownership of Home Directories"
    home_check=0

    getent passwd | awk -F: '{ print $1" "$6 }' | while read check_user home_dir; do
      found=0
      for test_user in root bin daemon adm lp sync shutdown halt mail news uucp \
        operator games gopher ftp nobody nscd vcsa rpc mailnull smmsp pcap \
        dbus sshd rpcuser nfsnobody haldaemon distcache apache \
        oprofile webalizer dovecot squid named xfs gdm sabayon; do
        if [ "$check_user" = "$test_user" ]; then
          found=1
        fi
      done
  
      if [ "$found" = 0 ]; then
        home_check=1
        if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
          increment_insecure "User $check_user has no home directory defined"
        else
          if [ -d "$home_dir" ]; then
            dir_owner=`ls -ld $home_dir/. | awk '{ print $3 }'`
            if [ "$dir_owner" != "$check_user" ]; then
              increment_insecure "Home Directory for $check_user is owned by $dir_owner"
            else
              if [ -z "$home_dir" ] || [ "$home_dir" = "/" ]; then
                increment_insecure "User $check_user has no home directory"
              fi
            fi
          fi
        fi
      fi
    done
    
    if [ "$home_check" = 0 ]; then
      increment_secure "No ownership issues with home directories"
    fi
}
