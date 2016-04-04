class marathon::startup::systemd (
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

  file { 'marathon_systemd_unit' :
    path    => "/lib/systemd/system/${service_name}.service",
    content => template('marathon/startup/systemd.unit.erb'),
  }

  File['marathon_systemd_unit'] ~>
  Service <| title == 'marathon' |>

}
