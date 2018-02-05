# audit_system_all
#
# Audit All System
#.

audit_system_all () {
	
#Sections 1.1.1.1-8, 3.5.1-4
  audit_modprobe_conf
  
#Sections 1.1.2,5,6,10,11,12
  audit_filesystem_partitions
  
#Sections 1.1.3,7,13,14,17
  audit_mount_nodev
  
#Sections 1.1.4,8,15,18
  audit_mount_setuid
  
 #Sections 1.1.9,16,19
   audit_mount_noexec
   
 #Section 1.1.20
  audit_sticky_bit
  
#Section 1.1.21
  audit_autofs
  
#Sections 1.3.1-2
  audit_aide	
 
#Section 1.4.1-2
#Section 1.4.3 is audited in 6.2.1
  audit_grub_security
  
#Section 1.5.1
  audit_core_dumps
  	
  full_audit_shell_services
  full_audit_accounting_services
  full_audit_firewall_services
  full_audit_password_services
  full_audit_kernel_services
  full_audit_mail_services
  full_audit_user_services
  full_audit_disk_services
  full_audit_hardware_services
  full_audit_power_services
  full_audit_virtualisation_services
  full_audit_x11_services
  full_audit_naming_services
  full_audit_file_services
  full_audit_web_services
  full_audit_print_services
  full_audit_routing_services
  full_audit_windows_services
  full_audit_startup_services
  full_audit_log_services
  full_audit_network_services
  full_audit_other_services
  full_audit_update_services
  if [ "$os_name" = "Darwin" ]; then
    full_audit_osx_services
  fi
}
