# audit_home_perms
#
# Refer to Sections 6.2.8
#.

audit_home_perms () {
    verbose_message "Sections 6.2.8: Home Directory Permissions"

    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$" |grep "home"`; do
      if [ -d "$home_dir" ]; then
        check_file_perms $home_dir 0700
      fi
    done

}
