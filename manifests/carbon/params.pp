# Class: graphite::carbon::params
#
class graphite::carbon::params {

  $storage_dir = "/opt/graphite/storage"

  $config_dir = $::osfamily ? {
    /(?i:Debian)/ => '/opt/graphite/conf',
    /(?i:RedHat)/ => '/etc/carbon',
    default       => '/etc/carbon',
  }

  $service_name = $::osfamily ? {
    /(?i:Debian)/ => 'carbon-cache',
    /(?i:RedHat)/ => 'carbon-cache',
    default       => 'carbon-cache',
  }

  $www_user = $::osfamily ? {
    /(?i:Debian)/ => 'www-data',
    /(?i:RedHat)/ => 'apache',
    default       => 'apache',
  }

  $www_group = $::osfamily ? {
    /(?i:Debian)/ => 'www-data',
    /(?i:RedHat)/ => 'apache',
    default       => 'apache',
  }

  $max_cache_size = 1000000
  $max_updates_per_second = 200
  $max_creates_per_second = 50
}

