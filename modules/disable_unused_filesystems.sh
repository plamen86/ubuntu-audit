#disable_unused_filesystems
#
# Sections 1.1.1.1-8
#

audit_separate_partition() {
  test_num=$1
  filesystem=$2
  
  mount_test=`mount | grep "$filesystem" | awk '{print $3}'`
  if [ "$mount_test" = "$filesystem" ]; then
    increment_secure "$test_num: Separate partition for $filesystem exists"
  else
   increment_insecure "$test_num: Separate partition for $filesystem does not exists!"
  fi
}

audit_mount_nodev() {
  test_num=$1
  filesystem=$2
  
  nodev_test=`mount | grep "$filesystem" | grep nodev | wc -l`
  if [ "$nodev_test" = "0" ]; then
    increment_insecure "$test_num: nodev option is not set on $filesystem!"
  else
    increment_secure "$test_num: nodev option is set on $filesystem"
  fi  
}

audit_mount_nosuid() {
  test_num=$1
  filesystem=$2
  
  nosuid_test=`mount | grep "$filesystem" | grep nosuid | wc -l`
  if [ "$nosuid_test" = "0" ]; then
    increment_insecure "$test_num: nosuid option is not set on $filesystem!"
  else
    increment_secure "$test_num: nosuid option is set on $filesystem"
  fi
}

audit_mount_noexec() {
  test_num=$1
  filesystem=$2
  
  noexec_test=`mount | grep "$filesystem" | grep noexec | wc -l`
  if [ "$noexec_test" = "0" ]; then
    increment_insecure "$test_num: noexec option is not set on $filesystem!"
  else
    increment_secure "$test_num: noexec option is set on $filesystem"
  fi
}

audit_disabled_filesystem() {
  test_num=$1
  fs_type=$2
  
  modprobe_result=`modprobe -n -v $fs_type | grep "install /bin/true" | wc -l`
  lsmod_result=`lsmod | grep $fs_type | wc -l`
    
  #the lsmod test should return an empty line(0) for a successful result
  #but I want an 1 if the test is ok
  lsmod_result=`expr $lsmod_result + 1`
    
  test_result=`expr $modprobe_result + $lsmod_result`
  if [ "$test_result" = "2" ]; then
    increment_secure "$test_num: Filesystem type $fs_type is disabled"
  else
    increment_insecure "$test_num: Filesystem type $fs_type is not disabled!"	
  fi
}

audit_sticky_bits () {

  message="1.1.20: Ensure sticky bit is set on all world-writable directories: "
  dir_list=""
  
  command=`df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d\( -perm -0002 -a ! -perm -1000 \) 2>/dev/null`

  for check_dir in "$command"; do 
  	dir_list=$dir_list+" $check_dir"+"\n"
  done
  
  if [ "$dir_list" = "" ]; then
  	increment_secure $message+"OK"
  else
  	increment_insecure $message
  	#echo "$dir_list"
  fi
}

audit_systemctl_service () {
  test_num=$1
  check_service=$2
  check_status=$3
  
  if [ "$check_status" = "enable" ]; then
    correct_status="enabled"
  else
    correct_status="disabled"
  fi

  actual_status=`systemctl is-enabled $check_service 2> /dev/null`

  if [ "$actual_status" = "enabled" ] || [ "$actual_status" = "disabled" ]; then
    if [ "$actual_status" != "$correct_status" ]; then
      increment_insecure "$test_num: Service $check_service is not $correct_status"
    else
      increment_secure "$test_num: Service $check_service is $correct_status"
    fi
  fi
}


disable_unused_filesystems() {

  #1.1.1.1-8
  count=1	
  for filesystem in cramfs freevxfs jffs2 hfs hfsplus squashfs udf vfat; do
    audit_disabled_filesystem 1.1.1."$count" "$filesystem" 
    	
	count=`expr $count + 1`
  done
  
  #1.1.2
  audit_separate_partition 1.1.2 /tmp

  #1.1.3
  audit_mount_nodev 1.1.3 /tmp

  #1.1.4
  audit_mount_nosuid 1.1.4 /tmp
  
  #1.1.5
  audit_separate_partition 1.1.5 /var
  
  #1.1.6
  audit_separate_partition 1.1.6 /var/tmp
  
  #1.1.7
  audit_mount_nodev 1.1.7 /var/tmp
  
  #1.1.8
  audit_mount_nosuid 1.1.8 /var/tmp
  
  #1.1.9
  audit_mount_noexec 1.1.9 /var/tmp
  
  #1.1.10
  audit_separate_partition 1.1.10 /var/log
  
  #1.1.11
  audit_separate_partition 1.1.11 /var/log/audit
  
  #1.1.12
  audit_separate_partition 1.1.12 /home
  
  #1.1.13
  audit_mount_nodev 1.1.13 /home
  
  #1.1.14
  audit_mount_nodev 1.1.14 /dev/shm
  
  #1.1.15
  audit_mount_nosuid 1.1.15 /dev/shm
  
  #1.1.16
  audit_mount_noexec 1.1.16 /dev/shm
  
  #1.1.20
  audit_sticky_bits
  
  #1.1.21
  audit_systemctl_service 1.1.21 autofs disable
  
  
}