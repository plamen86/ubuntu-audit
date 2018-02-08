# audit_netrc_files
#
# Refer to Sections 6.2.12-3
#.

audit_netrc_files () {
  verbose_message "Sections 6.2.12-3: User Netrc Files"

  audit_dot_files .netrc
}
