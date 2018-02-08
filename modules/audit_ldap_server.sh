# audit_ldap_server
#
# Refer to Section 2.2.6
#.

audit_ldap_server () {
  verbose_mesage "Section 2.2.6: LDAP Server"
  check_systemctl_service disable slapd
  check_linux_package uninstall openldap-clients
}
