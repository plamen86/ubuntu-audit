# audit_cron_perms
#
# Refer to Section(s) 5.1.2-8 Page(s) 205-12  CIS Ubuntu 16.04 Benchmark v1.0.0
#.

audit_cron_perms () {
  if [ "$os_name" = "Linux" ]; then
    verbose_message "Cron Permissions"
    for check_file in /etc/crontab /var/spool/cron /etc/cron.daily /etc/cron.d \
    /etc/cron.weekly /etc/cron.mounthly /etc/cron.hourly /etc/anacrontab; do
        check_file_perms $check_file 0700 root root
    done
  fi
}
