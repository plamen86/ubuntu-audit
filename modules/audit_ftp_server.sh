# audit_ftp_server
#
# Refer to Section 2.2.9
#.

audit_ftp_server () {
  verbose_message "Section 2.2.9: FTP Daemon"
    
 check_systemctl_service disable vsftpd
 check_linux_package uninstall vsftpd
 
}
