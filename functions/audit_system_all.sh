# audit_system_all
#
# Audit All System
#.

audit_system_all () {

#==============================================================================  
#===Section 1: Initial Setup
#==============================================================================

  #Sections 1.1.1.1-8, 3.5.1-4
  #12
  audit_modprobe_conf
  
  #Sections 1.1.2,5,6,10,11,12
  #6
  audit_filesystem_partitions
 
  #Sections 1.1.3,7,13,14,17
  #5
  audit_mount_nodev
  
  #Sections 1.1.4,8,15,18
  #4
  audit_mount_setuid
  
  #Sections 1.1.9,16,19
  #3
  audit_mount_noexec
   
  #Section 1.1.20
  #1
  audit_sticky_bit
  
  #Section 1.1.21
  #1
  audit_autofs
  
  #Sections 1.3.1-2, 1.5.4
  #1
  audit_aide	
 
  #Section 1.4.1-2
  #Section 1.4.3 is audited in 6.2.1
  #3
  audit_grub_security
  
  #Section 1.5.1
  #1
  audit_core_dumps
  
  #Section 1.5.3, 3.1.1-2, 3.2.1-8, 3.3.1-3
  #1
  audit_sysctl

  #Section 1.6.1.1-3
  #3
  audit_selinux
  
  #Sections 1.6.2.1, 1.6.3
  #2
  audit_apparmour


  #Section 1.7.1.1-6
  audit_issue_banner
  
  #Section 1.7.2
#  audit_gnome_banner
  
#==============================================================================  
#===Section 2: Services
#==============================================================================
  
  #Sections 2.1.1-10
  #2.1.10 => xinetd???
  audit_legacy
  
  #Sections 2.2.1.1-3
  audit_ntp

  #Section 2.2.2
  #no GUI installed on server

  #Section 2.2.3
  audit_avahi_server
  
  #Section 2.2.4
  audit_cups
  
  #Section 2.2.5
  audit_dhcp_server

  #Section 2.2.6
  audit_ldap_server
  
  #Section 2.2.7
  audit_nfs
  
  #Section 2.2.8
  audit_dns_server
  
  #Section 2.2.9
  audit_ftp_server
  
  #Sections 2.2.10,13
  audit_apache
  
  #Section 2.2.11
  audit_email_daemons
  
  #Section 2.2.12
  audit_samba
  
  #Section 2.2.14
  audit_snmp
  
   #Section 2.2.15
   audit_postfix_daemon
   
   #Section 2.2.16
   audit_rsync
   
   #Section 2.2.17
   audit_nis_server
   
   #Section 2.3.1
   audit_nis_client
   
   #Section 2.3.2
   audit_rsh_client
   
   #Section 2.3.3   
   audit_talk_client
   
   #Section 2.3.4
   audit_telnet_client
   
   #Section 2.3.5
   audit_ldap

#==============================================================================  
#===Section 3
#==============================================================================

  #Sections 3.1.1-2, 3.2.1-8, 3.3.1-3 are audited in Section 1.5.3
  
  #Sections 3.4.1-5
  audit_tcp_wrappers
  
  #Sections 3.5.1-4 are audited in Sections 1.1.1.1-8

  #Section 3.6.1-5
  audit_iptables

#==============================================================================
#===Section 4
#==============================================================================

  #Sections 4.1.1.1-3, 4.1.2-18
  audit_system_accounting
  
  #Sections 4.2.1.1-5
  audit_syslog_server

#==============================================================================
#===Section 5
#==============================================================================

  #Section 5.1.1-8
  audit_cron
  
  #Section 5.2.1-15
  audit_ssh_config
  
  #Section 5.3.1-4
  audit_system_auth
  
  #Section 5.4.1.1-4
  audit_password_expiry
  
  #Section 5.4.2
  audit_system_accounts
  
  #Section 5.4.3
  audit_root_primary_group  
  
  #Section 5.4.4
  audit_default_umask
  
  #Section 5.5
  audit_console_login
  
  #Section 5.6
  audit_pam_wheel
  
#==============================================================================
#===Section 6
#==============================================================================

  #Section 6.1.2-9
  audit_passwd_perms
  
  #Section 6.1.10
  audit_writable_files
  
  #Section 6.1.11-2
  audit_unowned_files
  
  #Section 6.1.13-4
  audit_suid_files
  
  #Section 6.2.1-4
  audit_password_fields
  
  #Sections 6.2.5
  audit_super_users
  
  #Section 6.2.6
  audit_root_path
  
  #Section 6.2.7,9
  audit_home_ownership
  
  #Section 6.2.8
  audit_home_perms
  
  #Section 6.2.10
  audit_user_dotfiles
  
  #Section 6.2.11
  audit_forward_files
  
  #Section 6.2.12-13
  audit_netrc_files  
  
  #Section 6.2.14
  audit_user_rhosts
  
  #Section 6.2.15
  audit_groups_exist
  
  #Section 6.2.16, 18
  audit_duplicate_users  
  
  #Section 6.2.17, 19
  audit_duplicate_groups
  
  #Section 6.2.20
  audit_shadow_group
}
