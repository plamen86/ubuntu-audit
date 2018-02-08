# audit_gnome_banner
#
# Create Warning Banner for GNOME Users
#
# Refer to Section 1.7.2
#.

audit_gnome_banner () {
    verbose_message "Gnome Warning Banner"

    check_file="/etc/dconf/profile/gdm"
    if [ -f "$check_file" ]; then
      check_file_value $check_file user-db colon user hash
      check_file_value $check_file system-db colon gdm hash
      check_file_value $check_file file-db colon /usr/share/gdm/greeter-dconf-defaults hash
    fi
    check_file="/etc/dconf/db/gdm.d/01-banner-message"
    if [ -f "$check_file" ]; then
      check_file_value $check_file banner-message-enable eq true hash
      check_file_value $check_file banner-message-text eq "Authorized uses only. All activity may be monitored and reported." hash
    fi

    gconf_bin=`which gconftool-2 2> /dev/null`
    if [ -f "$gconf_bin" ]; then
      warning_message="Authorised users only"
      actual_value=`gconftool-2 --get /apps/gdm/simple-greeter/banner_message_text`
      log_file="gnome_banner_warning"

      if [ "$actual_value" != "$warning_message" ]; then
        increment_insecure "Warning banner not found in $check_file"
        verbose_message "" fix
        verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -t string -s /apps/gdm/simple-greeter/banner_message_text \"$warning_message\"" fix
        verbose_message "" fix
      else
        increment_secure "Warning banner is set to \"$warning_message\""
      fi

    actual_value=`gconftool-2 --get /apps/gdm/simple-greeter/banner_message_enable`
    log_file="gnome_banner_status"
    
    
    if [ "$actual_value" != "true" ]; then
      increment_insecure "Warning banner not found in $check_file"
      verbose_message "" fix
      verbose_message "gconftool-2 -direct -config-source=xml:readwrite:$HOME/.gconf -type bool -set /apps/gdm/simple-greeter/banner_message_enable true" fix
      verbose_message "" fix
    else
      increment_secure "Warning banner is set to \"$warning_message\""
    fi
}
