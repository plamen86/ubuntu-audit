# audit_core_dumps
#
# Refer to Section 1.5.1
#.

audit_core_dumps () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ] || [ "$os_name" = "FreeBSD" ]; then
  	verbose_message "============="
    verbose_message "Core Dumps"
    verbose_message "Section 1.5.1"
    verbose_message "============="
    if [ "$os_name" = "SunOS" ]; then
      if [ "$os_version" != "6" ]; then
        cores_dir="/var/cores"
        check_file="/etc/coreadm.conf"
        cores_check=`coreadm |head -1 |awk '{print $5}'`
        
        if [ `expr "$cores_check" : "/var/cores"` != 10 ]; then
          if [ "$audit_mode" = 1 ]; then
            increment_insecure "Cores are not restricted to a private directory"
          else
            if [ "$audit_mode" = 0 ]; then
              echo "Setting:   Making sure restricted to a private directory"
              if [ -f "$check_file" ]; then
                echo "Saving:    File $check_file to $work_dir$check_file"
                find $check_file | cpio -pdm $work_dir 2> /dev/null
              else
                touch $check_file
                find $check_file | cpio -pdm $work_dir 2> /dev/null
                rm $check_file
                log_file="$work_dir/$check_file"
                coreadm | sed -e 's/^ *//g' |sed 's/ /_/g' |sed 's/:_/:/g' |awk -F: '{ print $1" "$2 }' | while read option value; do
                  if [ "$option" = "global_core_file_pattern" ]; then
                    echo "COREADM_GLOB_PATTERN=$value" > $log_file
                  fi
                  if [ "$option" = "global_core_file_content" ]; then
                    echo "COREADM_GLOB_CONTENT=$value" >> $log_file
                  fi
                  if [ "$option" = "init_core_file_pattern" ]; then
                    echo "COREADM_INIT_PATTERN=$value" >> $log_file
                  fi
                  if [ "$option" = "init_core_file_content" ]; then
                    echo "COREADM_INIT_CONTENT=$value" >> $log_file
                  fi
                  if [ "$option" = "global_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "per-process_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "global_setid_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_SETID_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "per-process_setid_core_dumps" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_PROC_SETID_ENABLED=$value" >> $log_file
                  fi
                  if [ "$option" = "global_core_dump_logging" ]; then
                    if [ "$value" = "enabled" ]; then
                      value="yes"
                    else
                      value="no"
                    fi
                    echo "COREADM_GLOB_LOG_ENABLED=$value" >> $log_file
                  fi
                done
              fi
              coreadm -g /var/cores/core_%n_%f_%u_%g_%t_%p -e log -e global -e global-setid -d process -d proc-setid
            fi
            if [ ! -d "$cores_dir" ]; then
              mkdir $cores_dir
              chmod 700 $cores_dir
              chown root:root $cores_dir
            fi
          fi
        else
          if [ "$audit_mode" = 1 ]; then
            increment_secure "Cores are restricted to a private directory"
          fi
        fi
        if [ "$audit_mode" = 2 ]; then
          restore_file $check_file $restore_dir
          restore_file="$restore_dir$check_file"
          if [ -f "$restore_file" ]; then
            coreadm -u
          fi
        fi
      fi
    fi
    if [ "$os_name" = "Linux" ]; then
      verbose_message "Core Dumps"
      for service_name in kdump; do
        check_chkconfig_service $service_name 3 off
        check_chkconfig_service $service_name 5 off
      done
      check_file="/etc/security/limits.conf"
      check_append_file $check_file "* hard core 0"
      check_file="/etc/sysctl.conf"
      check_file_value $check_file fs.suid_dumpable eq 0 hash
    fi
    if [ "$os_name" = "FreeBSD" ]; then
      check_file="/etc/sysctl.conf"
      check_file_value $check_file kern.coredump eq 0 hash
    fi
  fi
}
