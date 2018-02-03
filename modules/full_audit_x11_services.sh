# full_audit_x11_services
#
# Audit X11 Services
#.

full_audit_x11_services () {
#ok  audit_cde_ttdb
#ok  audit_cde_cal
#ok  audit_cde_spc
#ok  audit_cde_print
  audit_xlogin
  audit_gdm_conf
#ok  audit_cde_banner
  audit_gnome_banner
#ok  audit_cde_screen_lock
  audit_gnome_screen_lock
  audit_opengl
  audit_font_server
  audit_vnc
  audit_xwindows_server
}
