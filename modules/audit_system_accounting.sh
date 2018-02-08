# audit_system_accounting
#
# Refer to Sections 4.1.1.1-3, 4.1.2-18
#.

audit_system_accounting () {

    verbose_message "Sections 4.1.1.1-3, 4.1.2-18: System Accounting"

    check_file="/etc/audit/audit.rules"
    check_append_file $check_file "-w /var/log/sudo.log -p wa -k actions"
    log_file="sysstat.log"
    check_linux_package check sysstat
    if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
      check_file="/etc/default/sysstat"
      check_file_value $check_file ENABLED eq true hash
    fi
    if [ "$package_name" != "sysstat" ]; then
      if [ "$audit_mode" = 1 ]; then
        increment_insecure "System accounting not enabled"
        verbose_message "" fix
        if [ "$os_vendor" = "Debian" ] || [ "$os_vendor" = "Ubuntu" ]; then
          verbose_message "apt-get install $package_check" fix
        fi
        verbose_message "" fix
      fi
    else
      increment_secure "System accounting enabled"
    fi

    check_file="/etc/audit/audit.rules"
    # Set failure mode to syslog notice
    check_append_file $check_file "-f 1" hash
    # Things that could affect time
    check_append_file $check_file "-a always,exit -F arch=b32 -S adjtimex -S settimeofday -S stime -k time-change" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change" hash
    fi
    check_append_file $check_file "-a always,exit -F arch=b32 -S clock_settime -k time-change" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S clock_settime -k time-change" hash
    fi
    check_append_file $check_file "-w /etc/localtime -p wa -k time-change" hash
    # Things that affect identity
    check_append_file $check_file "-w /etc/group -p wa -k identity" hash
    check_append_file $check_file "-w /etc/passwd -p wa -k identity" hash
    check_append_file $check_file "-w /etc/gshadow -p wa -k identity" hash
    check_append_file $check_file "-w /etc/shadow -p wa -k identity" hash
    check_append_file $check_file "-w /etc/security/opasswd -p wa -k identity" hash
    # Things that could affect system locale
    check_append_file $check_file "-a exit,always -F arch=b32 -S sethostname -S setdomainname -k system-locale" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a exit,always -F arch=b64 -S sethostname -S setdomainname -k system-locale" hash
    fi
    check_append_file $check_file "-w /etc/issue -p wa -k system-locale" hash
    check_append_file $check_file "-w /etc/issue.net -p wa -k system-locale" hash
    check_append_file $check_file "-w /etc/hosts -p wa -k system-locale" hash
    check_append_file $check_file "-w /etc/sysconfig/network -p wa -k system-locale" hash
    # Things that could affect MAC policy
    check_append_file $check_file "-w /etc/selinux/ -p wa -k MAC-policy" hash
    # Things that could affect logins
    check_append_file $check_file "-w /var/log/faillog -p wa -k logins" hash
    check_append_file $check_file "-w /var/log/lastlog -p wa -k logins" hash
    #- Process and session initiation (unsuccessful and successful)
    check_append_file $check_file "-w /var/run/utmp -p wa -k session" hash
    check_append_file $check_file "-w /var/log/btmp -p wa -k session" hash
    check_append_file $check_file "-w /var/log/wtmp -p wa -k session" hash
    #- Discretionary access control permission modification (unsuccessful and successful use of chown/chmod)
    check_append_file $check_file "-a always,exit -F arch=b32 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
    fi
    check_append_file $check_file "-a always,exit -F arch=b32 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -F auid>=500 - F auid!=4294967295 -k perm_mod" hash
    fi
    check_append_file $check_file "-a always,exit -F arch=b32 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
    if [ "$os_platform" = "x86_64" ]; then
     check_append_file $check_file "-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -S removexattr -S lremovexattr -S fremovexattr -F auid>=500 -F auid!=4294967295 -k perm_mod" hash
    fi
    #- Unauthorized access attempts to files (unsuccessful)
    check_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
    check_append_file $check_file "-a always,exit -F arch=b32 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EACCES -F auid>=500 -F auid!=4294967295 -k access" hash
      check_append_file $check_file "-a always,exit -F arch=b64 -S creat -S open -S openat -S truncate -S ftruncate -F exit=-EPERM -F auid>=500 -F auid!=4294967295 -k access" hash
    fi
    #- Use of privileged commands (unsuccessful and successful)
    #check_append_file $check_file "-a always,exit -F path=/bin/ping -F perm=x -F auid>=500 -F auid!=4294967295 -k privileged" hash
    check_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k export" hash
    fi
    #- Files and programs deleted by the user (successful and unsuccessful)
    check_append_file $check_file "-a always,exit -F arch=b32 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S unlink -S unlinkat -S rename -S renameat -F auid>=500 -F auid!=4294967295 -k delete" hash
    fi
    #- All system administration actions
    check_append_file $check_file "-w /etc/sudoers -p wa -k scope" hash
    check_append_file $check_file "-w /etc/sudoers -p wa -k actions" hash
    #- Make sue kernel module loading and unloading is recorded
    check_append_file $check_file "-w /sbin/insmod -p x -k modules" hash
    check_append_file $check_file "-w /sbin/rmmod -p x -k modules" hash
    check_append_file $check_file "-w /sbin/modprobe -p x -k modules" hash
    check_append_file $check_file "-a always,exit -S init_module -S delete_module -k modules" hash
    #- Tracks successful and unsuccessful mount commands
    if [ "$os_platform" = "x86_64" ]; then
      check_append_file $check_file "-a always,exit -F arch=b64 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
    fi
    check_append_file $check_file "-a always,exit -F arch=b32 -S mount -F auid>=500 -F auid!=4294967295 -k mounts" hash
    #check_append_file $check_file "" hash
    #check_append_file $check_file "" hash
    check_append_file $check_file "" hash
    #- Manage and retain logs
    check_append_file $check_file "space_left_action = email" hash
    check_append_file $check_file "action_mail_acct = email" hash
    check_append_file $check_file "admin_space_left_action = email" hash
    #check_append_file $check_file "" hash
    check_append_file $check_file "max_log_file = MB" hash
    check_append_file $check_file "max_log_file_action = keep_logs" hash
    #- Make file immutable - MUST BE LAST!
    check_append_file $check_file "-e 2" hash
    service_name="sysstat"
    check_chkconfig_service $service_name 3 on
    check_chkconfig_service $service_name 5 on
    service_bname="auditd"
    check_chkconfig_service $service_name 3 on
    check_chkconfig_service $service_name 5 on
  fi
}
