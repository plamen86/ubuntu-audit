# audit_user_dotfiles
#
# Refer to Sections 6.2.10
#.

audit_user_dotfiles () {
    verbose_message "Sections 6.2.10: User Dot Files"

    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$"`; do
      for check_file in $home_dir/.[A-Za-z0-9]*; do
        if [ -f "$check_file" ]; then
          check_file_perms $check_file 0600
        fi
      done
    done

}
