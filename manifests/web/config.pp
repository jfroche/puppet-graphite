# Class: graphite::web::config
#
class graphite::web::config(
  $config_dir     = $::graphite::web::params::config_dir,
  $log_dir        = $::graphite::web::params::log_dir,
  $service_name   = $::graphite::web::params::service_name,
  $wsgi_file      = $::graphite::web::params::wsgi_file,
  $docroot        = $::graphite::web::params::docroot,
  $python_sitelib = $::graphite::web::params::python_sitelib,
  $port           = $::graphite::web::params::port
) inherits graphite::web::params {
  include graphite::carbon::config

  file { 'local_settings.py':
    ensure    => file,
    path      => "${config_dir}/local_settings.py",
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    notify    => Service[$service_name],
    content   => template('graphite/local_settings.py.erb'),
    require   => Package['graphite-web'],
  }

  apache::vhost {graphite:
    port      => $port,
    docroot   => "${docroot}",
    aliases   => [
      {alias => '/media', path => "${python_sitelib}/django/contrib/admin/media/"},
      {alias => '/content', path => "${docroot}/content"},
    ],
    wsgi_daemon_process         => 'wsgi',
    wsgi_daemon_process_options =>
        { processes => '2', threads => '15', display-name => '%{GROUP}' },
    wsgi_process_group          => 'wsgi',
    wsgi_script_aliases         => { '/' => $wsgi_file },
    custom_fragment => template("graphite/apache-fragement.erb"),
  }

  exec{"python manage.py syncdb --noinput":
    path => ["/usr/bin", "/usr/local/bin"],
    require => File['local_settings.py'],
    creates => "${::graphite::carbon::config::storage_dir}/graphite.db",
    cwd => "${python_sitelib}/graphite"
  }
}

