# audit_cron_perms
#
# Refer to Sections 5.1.2-8
#.

audit_cron_perms () {

  verbose_message "Sections 5.1.2-8: Cron Permissions"
    
  for check_file in /etc/crontab /var/spool/cron /etc/cron.daily /etc/cron.d \
  /etc/cron.weekly /etc/cron.mounthly /etc/cron.hourly /etc/anacrontab; do
      check_file_perms $check_file 0700 root root
  done
}
