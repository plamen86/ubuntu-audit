# check_linux_package
#
# Check package
# Takes the following variables:
# package_mode:   Mode, eg check install uninstall restore
# package_check:  Package to check for
#.

check_linux_package () {
 
  package_mode=$1
  package_check=$2

  if [ "$package_mode" = "install" ]; then
    package_status="installed"
  else
    package_status="uninstalled"
  fi

#    verbose_message "Checking if package is $package_check $package_status"
#    echo "Checking:  Package $package_check is installed"

  package_name=`dpkg -l $package_check 2>&1 |grep $package_check |awk '{print $2}'`
      
  if [ "$package_mode" = "install" ] && [ "$package_name" = "$package_check" ]; then
    increment_secure "Package $package_check is $package_status"
  else
    if [ "$package_mode" = "uninstall" ] && [ "$package_name" != "$package_check" ]; then
      increment_secure "Package $package_check is $package_status"
    else
      increment_insecure "Package $package_check is not $package_status"
    fi
  fi
      
#  if [ "$package_mode" = "install" ]; then
#    package_command="apt-get install $package_check"
#  fi
#      
#  if [ "$package_mode" = "uninstall" ]; then
#    package_command="apt-get purge $package_check"
#  fi
#
#  verbose_message "" fix
#  verbose_message "$command" fix
#  verbose_message "" fix
}
