# audit_default_umask
#
# Refer to Section 5.4.4
#.

audit_default_umask () {
  
  verbose_message "Section 5.4: Default umask for Users"
    

  for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile /etc/csh.login \
    /etc/csh.cshrc /etc/zprofile /etc/skel/.zshrc /etc/skel/.bashrc; do
    check_file_value $check_file "umask" space 077 hash
  done
  for check_file in /etc/bashrc /etc/skel/.bashrc /etc/login.defs; do
    check_file_value $check_file UMASK eq 077 hash
  done

}
