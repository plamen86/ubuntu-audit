# audit_forward_files
#
# Refer to Section 6.2.11
#.

audit_forward_files () {
	
  verbose_message "Section 6.2.11: User Forward Files"

  audit_dot_files .forward
}
