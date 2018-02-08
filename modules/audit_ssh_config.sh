# audit_ssh_config
#
# Refer to Sections 5.2.1-15
#.

audit_ssh_config () {

  verbose_message "Section 5.2.1-15: SSH Server Configuration"
  
  for check_file in /etc/sshd_config /etc/ssh/sshd_config /usr/local/etc/sshd_config /opt/local/ssh/sshd_config; do
    if [ -f "$check_file" ]; then
      verbose_message "SSH Configuration $sshd_file"

      check_file_perms $check_file 0600 root root
      check_file_value $check_file UseLogin space no hash
      check_file_value $check_file Protocol space 2 hash
      check_file_value $check_file X11Forwarding space no hash
      check_file_value $check_file MaxAuthTries space 3 hash
      check_file_value $check_file MaxAuthTriesLog space 0 hash
      check_file_value $check_file RhostsAuthentication space no hash
      check_file_value $check_file IgnoreRhosts space yes hash
      check_file_value $check_file StrictModes space yes hash
      check_file_value $check_file AllowTcpForwarding space no hash
      check_file_value $check_file ServerKeyBits space 1024 hash
      check_file_value $check_file GatewayPorts space no hash
      check_file_value $check_file RhostsRSAAuthentication space no hash
      check_file_value $check_file PermitRootLogin space no hash
      check_file_value $check_file PermitEmptyPasswords space no hash
      check_file_value $check_file PermitUserEnvironment space no hash
      check_file_value $check_file HostbasedAuthentication space no hash
      check_file_value $check_file Banner space /etc/issue hash
      check_file_value $check_file PrintMotd space no hash
      check_file_value $check_file ClientAliveInterval space 300 hash
      check_file_value $check_file ClientAliveCountMax space 0 hash
      check_file_value $check_file LogLevel space VERBOSE hash
      check_file_value $check_file RSAAuthentication space no hash
      check_file_value $check_file UsePrivilegeSeparation space "yes|sandbox" hash
      check_file_value $check_file LoginGraceTime space 120 hash
      # Check for kerberos
      check_file="/etc/krb5/krb5.conf"
      if [ -f "$check_file" ]; then
        admin_check=`cat $check_file |grep -v '^#' |grep "admin_server" |cut -f2 -d= |sed 's/ //g' |wc -l |sed 's/ //g'`
        if [ "$admin_server" != "0" ]; then
          check_file="/etc/ssh/sshd_config"
          check_file_value $check_file GSSAPIAuthentication space yes hash
          check_file_value $check_file GSSAPIKeyExchange space yes hash
          check_file_value $check_file GSSAPIStoreDelegatedCredentials space yes hash
          check_file_value $check_file UsePAM space yes hash
          #check_file_value $check_file Host space "*" hash
        fi
      fi
    fi
  done
}
