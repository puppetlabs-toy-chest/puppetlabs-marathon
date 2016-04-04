class marathon::startup::upstart (
  $launcher_path = $marathon::params::launcher_path,
  $jar_file_path = $marathon::params::jar_file_path,
  $service_name  = $marathon::params::service_name,
  $run_user      = $marathon::params::run_user,
  $run_group     = $marathon::params::run_group,
) inherits ::marathon::params {

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'marathon_upstart_file' :
    path    => "/etc/init/${service_name}.conf",
    content => template('marathon/startup/upstart.conf.erb'),
  }

  file { 'marathon_init.d_wrapper' :
    ensure => 'symlink',
    path   => "/etc/init.d/${service_name}",
    target => '/lib/init/upstart-job',
  }

  File['marathon_upstart_file'] ~>
  Service <| title == 'marathon' |>

  File['marathon_init.d_wrapper'] ~>
  Service <| title == 'marathon' |>

}
