# Class: graphite::web::params
#
class graphite::web::params {
  $port = 80

  $config_dir = $::osfamily ? {
    /(?i:Debian)/ => '/opt/graphite/webapp/graphite',
    /(?i:RedHat)/ => '/etc/graphite-web',
    default       => '/etc/graphite-web',
  }

  $log_dir = $::osfamily ? {
    /(?i:RedHat)/ => '/var/log/graphite-web',
    default       => '/opt/graphite/storage/log/webapp'
  }

  $service_name = $::osfamily ? {
    /(?i:Debian)/ => 'apache2',
    /(?i:RedHat)/ => 'httpd',
    default       => 'httpd',
  }

  $wsgi_file      = $::osfamily ? {
    /(?i:RedHat)/ => '/usr/share/graphite/graphite-web.wsgi',
    default       => '/opt/graphite/webapp/graphite/graphite.wsgi'
  }

  $docroot        = $::osfamily ? {
    /(?i:RedHat)/ => '/usr/share/graphite/webapp',
    default       => '/opt/graphite/webapp'
  }

  $python_version = $::operatingsystem ? {
    /RedHat|CentOS/ => 'python2.6', # graphite won't work on python 2.4 anyway
    /Ubuntu/ => $::operatingsystemrelease ? {
      /^1[01]\./ => 'python2.6',
      default => 'python2.7'
    },
    default => 'python2.6'
  }
  $python_sitelib = "/usr/lib/${python_version}/site-packages"
}

