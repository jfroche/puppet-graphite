# Class: graphite::carbon::config
#
class graphite::carbon::config(
  $storage_dir            = $::graphite::carbon::params::storage_dir,
  $config_dir             = $::graphite::carbon::params::config_dir,
  $service_name           = $::graphite::carbon::params::service_name,
  $www_group              = $::graphite::carbon::params::www_group,
  $www_user               = $::graphite::carbon::params::www_user,
  $max_cache_size         = $::graphite::carbon::params::max_cache_size,
  $max_updates_per_second = $::graphite::carbon::params::max_updates_per_second,
  $max_creates_per_second = $::graphite::carbon::params::max_creates_per_second,
) inherits graphite::carbon::params {
  include concat::setup

  file {$config_dir:
    ensure => directory,
    mode   => '0644',
  }

  concat { "${config_dir}/storage-schemas.conf":
    group  => '0',
    mode   => '0644',
    owner  => '0',
    notify => Service['carbon-cache'];
  }

  concat::fragment { 'header':
    target => "${config_dir}/storage-schemas.conf",
    order  => 0,
    source => 'puppet:///modules/graphite/storage-schemas.conf',
  }

  file { "${config_dir}/carbon.conf":
    ensure  => present,
    mode    => '0640',
    content => template('graphite/carbon.conf.erb'),
  }
  if $storage_dir == '/opt/graphite/storage' {
    file{'/opt/graphite':
      ensure => directory
    }
  }
  file { "${storage_dir}":
    ensure  => directory,
    recurse => true,
    owner   => $www_user,
    group   => $www_group,
    before  => Service[$service_name],
  }

  if $::osfamily == 'Debian' {
    file { '/etc/init.d/carbon-cache':
      ensure  => present,
      mode    => '0755',
      owner   => '0',
      group   => '0',
      content => template('graphite/carbon-cache_Debian.init'),
      before  => Service[$service_name],
    }
  }
}

