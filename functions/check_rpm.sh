# check_rpm
#
# Check if an rpm is installed, if so rpm_check will be be set with name of rpm,
# otherwise it will be empty
#.

check_rpm () {
  package_name=$1
  check_debian_package $package_name
}
