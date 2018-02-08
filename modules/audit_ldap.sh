# audit_ldap
#
# Refer to Section 2.3.5
#.

audit_ldap () {
  verbose_message "Section 2.3.5: LDAP Client"

  check_linux_package uninstall openldap-clients
}
