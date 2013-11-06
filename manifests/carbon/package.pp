# Class: graphite::carbon::package
#
class graphite::carbon::package (
  $package_name = undef
) {
  $package_name_real = $package_name ? {
    undef => $::osfamily ? {
        /(?i:Debian)/ => 'python-carbon',
        /(?i:RedHat)/ => 'python-carbon',
        default       => 'carbon',
    },
    default => $package_name
  }

  package { $package_name_real:
    ensure => present;
  }
}

