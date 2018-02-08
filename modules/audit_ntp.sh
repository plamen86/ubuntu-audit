# audit_ntp
#
# Refer to Sections 2.2.1.1-3
#.

audit_ntp () {

  verbose_message "Section 2.2.1.1 => Network Time Protocol"

  check_file="/etc/ntp.conf"
  log_file="ntp.log"
  check_linux_package install ntp

  check_linux_package install chrony
  check_file="/etc/sysconfig/chronyd"
  check_file_value $check_file OPTIONS eq '"-u chrony"' hash
  check_file="/usr/lib/systemd/system/ntpd.service"
  check_file_value $check_file ExecStart eq "/usr/sbin/ntpd -u ntp:ntp $OPTIONS" hash

  echo "Checking:  NTP is enabled"


  if [ "$package_name" != "ntp" ]; then
    increment_insecure "NTP not enabled"
  else
    increment_secure "NTP installed"
  fi

  service_name="ntp"
  check_chkconfig_service $service_name 3 on
  check_chkconfig_service $service_name 5 on
  check_append_file $check_file "restrict default kod nomodify nopeer notrap noquery" hash
  check_append_file $check_file "restrict -6 default kod nomodify nopeer notrap noquery" hash
  check_file_value $check_file OPTIONS eq '"-u ntp:ntp -p /var/run/ntpd.pid"' hash

  check_file="/etc/chrony/chrony.conf"
  for server_number in `seq 0 3`; do
    ntp_server="$server_number.$country_suffix.pool.ntp.org"
    check_file_value $check_file server space $ntp_server hash
  done

  check_file="/etc/ntp.conf"
  for server_number in `seq 0 3`; do
    ntp_server="$server_number.$country_suffix.pool.ntp.org"
    check_file_value $check_file server space $ntp_server hash
  done
}