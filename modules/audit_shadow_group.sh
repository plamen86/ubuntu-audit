# audit_shadow_group
#
# Refer to Section 6.2.20
#.

audit_shadow_group () {
  verbose_message "Section 6.2.20: Shadow Group"

  shadow_check=`cat /etc/group |grep -v "^#" |grep ^shadow |cut -f4 -d":" |wc -c`

  if [ "$shadow_check" != 0 ]; then
    increment_insecure "Shadow group contains members"
  else
    increment_secure "No members in shadow group"
  fi
}
