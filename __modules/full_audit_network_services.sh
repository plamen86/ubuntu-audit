# full_audit_network_services
#
# Audit Network Service
#.

full_audit_network_services () {
  audit_snmp
  audit_ntp
  audit_ipmi
  audit_echo
  audit_ocfserv
  audit_tname
  audit_service_tags
  audit_ticotsord
  audit_boot_server
  audit_slp
  audit_tnd
  audit_nobody_rpc
#ok  audit_dhcpcd
#ok  audit_dhcprd
#ok  audit_dhcpsd
  audit_mob
#  audit_dvfilter
}
