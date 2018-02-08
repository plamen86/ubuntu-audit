# audit_apache
#
# Refer to Sections 2.2.10,13
#.

audit_apache () {

  verbose_message "Sections 2.2.10,13 - Apache and web based services"
    
  for service_name in httpd apache apache2 tomcat5 squid prixovy; do
    check_systemctl_service disable $service_name
    check_chkconfig_service $service_name 3 off
    check_chkconfig_service $service_name 5 off
    check_linux_package uninstall $service_name 
  done
}
