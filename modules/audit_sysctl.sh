# audit_sysctl
#
# Refer to Section(s) 1.5.3, 3.3.1-2, 3.2.1-8, 3.3.1-3
#.

audit_sysctl () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Sysctl Configuration"
    check_file="/etc/sysctl.conf"
    check_file_value $check_file net.ipv4.conf.default.secure_redirects eq 0 hash
    check_file_value $check_file net.ipv4.conf.all.secure_redirects eq 0 hash
    check_file_value $check_file net.ipv4.icmp_echo_ignore_broadcasts eq 1 hash
    check_file_value $check_file net.ipv4.conf.all.accept_redirects eq 0 hash
    check_file_value $check_file net.ipv4.conf.default.accept_redirects eq 0 hash
    check_file_value $check_file net.ipv4.tcp_syncookies eq 1 hash
    check_file_value $check_file net.ipv4.tcp_max_syn_backlog eq 4096 hash
    check_file_value $check_file net.ipv4.conf.all.rp_filter eq 1 hash
    check_file_value $check_file net.ipv4.conf.default.rp_filter eq 1 hash
    check_file_value $check_file net.ipv4.conf.all.accept_source_route eq 0 hash
    check_file_value $check_file net.ipv4.conf.default.accept_source_route eq 0 hash
    # Disable these if machine used as a firewall or gateway
    check_file_value $check_file net.ipv4.tcp_max_orphans eq 256 hash
    check_file_value $check_file net.ipv4.conf.all.log_martians eq 1 hash
    check_file_value $check_file net.ipv4.ip_forward eq 0 hash
    check_file_value $check_file net.ipv4.conf.all.send_redirects eq 0 hash
    check_file_value $check_file net.ipv4.conf.default.send_redirects eq 0 hash
    check_file_value $check_file net.ipv4.icmp_ignore_bogus_error_responses eq 1 hash
    # IPv6 stuff
    check_file_value $check_file net.ipv6.conf.default.accept_redirects eq 0 hash
    check_file_value $check_file net.ipv6.conf.all.accept_ra eq 0 hash
    check_file_value $check_file net.ipv6.conf.default.accept_ra eq 0 hash
    check_file_value $check_file net.ipv6.route.flush eq 1 hash
    # Randomise kernel memory placement
    check_file_value $check_file kernel.randomize_va_space eq 2 hash
    # Configure kernel shield
    check_file_value $check_file kernel.exec-shield eq 1 hash
    # Restrict core dumps
    check_file_value $check_file fs.suid.dumpable eq 0 hash
    check_append_file /etc/security/limits.conf "* hard core 0"
    # Check file permissions
    check_file_perms $check_file 0600 root root
  fi
}
