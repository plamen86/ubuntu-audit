# audit_syslog_server
#
# Refer to Sections 4.2.1.1-5
#.

audit_syslog_server () {

  verbose_message="Sections 4.2.1.1-5: Syslog Daemon"

  service_name="syslog"
  check_chkconfig_service $service_name 3 off
  check_chkconfig_service $service_name 5 off
  service_name="rsyslog"
  check_file="/etc/rsyslog.conf"
  check_file_value $check_file "auth,user.*" tab "/var/log/messages" hash
  check_file_value $check_file "kern.*" tab "/var/log/kern.log" hash
  check_file_value $check_file "daemon.*" tab "/var/log/daemon.log" hash
  check_file_value $check_file "syslog.*" tab "/var/log/syslog" hash
  check_file_value $check_file "lpr,news,uucp,local0,local1,local2,local3,local4,local5,local6.*" tab "/var/log/unused.log" hash
  check_file_value $check_file "" tab "" hash
  check_linux_package install $service_name
  check_systemctl_service enable $service_name
  check_chkconfig_service $service_name 3 on
  check_chkconfig_service $service_name 5 on
  
  check_file_perms $check_file 0600 root root
 
   $command = `grep "^*.*[^I][^I]*@" /etc/rsyslog.conf |wc -l`
   if [ "$command" != "1" ]; then
    increment_insecure "Rsyslog is not sending messages to a remote server"
    verbose_message "" fix
    verbose_message "Add a server entry to $check_file, eg:" fix
    verbose_message "*.* @@loghost.example.com" fix
    verbose_message "" fix
  else
    increment_secure "Rsyslog is sending messages to a remote server"
  fi
 
            
#  $remote_check=`cat /etc/rsyslog.conf |grep -v '#' |grep '*.* @@' |grep -v localhost |grep '[A-z]' |wc -l`
#  if [ "$remote_check" != "1" ]; then
#    increment_insecure "Rsyslog is not sending messages to a remote server"
#    verbose_message "" fix
#    verbose_message "Add a server entry to $check_file, eg:" fix
#    verbose_message "*.* @@loghost.example.com" fix
#    verbose_message "" fix
#  else
#    increment_secure "Rsyslog is sending messages to a remote server"
#  fi
}
