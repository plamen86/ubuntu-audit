# audit_default_umask
#
# Refer to Section(s) 5.4.4 Page(s) 246-7 CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_default_umask () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
    verbose_message "Default umask for Users"
    if [ "$os_name" = "SunOS" ]; then
      check_file="/etc/default/login"
      check_file_value $check_file UMASK eq 077 hash
    fi
    if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
      for check_file in /etc/.login /etc/profile /etc/skel/.bash_profile /etc/csh.login \
        /etc/csh.cshrc /etc/zprofile /etc/skel/.zshrc /etc/skel/.bashrc; do
        check_file_value $check_file "umask" space 077 hash
      done
      for check_file in /etc/bashrc /etc/skel/.bashrc /etc/login.defs; do
        check_file_value $check_file UMASK eq 077 hash
      done
    fi
  fi
}
