# check_rpm
#
# Check if an rpm is installed, if so rpm_check will be be set with name of rpm,
# otherwise it will be empty
#.

check_rpm () {
  package_name=$1
  rpm_check=`dpkg -l $package_name 2>&1 |grep $package_name |awk '{print $2}' |grep "^$package_name$"`
}
