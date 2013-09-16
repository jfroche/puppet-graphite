# Class: graphite::whisper::package
#
class graphite::whisper::package(
  $package_name = undef
) {
  $package_name_real = $package_name ? {
    undef => $::osfamily ? {
      default => 'python-whisper',
    },
    default => $package_name
  }

  $package_provider = $::osfamily ? {
    /(?i:Debian)/ => 'pip',
    default       => undef,
  }

  package { $package_name_real:
    ensure   => present,
    provider => $package_provider,
  }
}

