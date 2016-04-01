class marathon::startup(
  $startup_manage  = $marathon::params::startup_manage,
  $launcher_manage = $marathon::params::launcher_manage,
  $launcher_path   = $marathon::params::launcher_path,
  $jar_file_path   = $marathon::params::jar_file_path,
  $service_name    = $marathon::params::service_name,
  $startup_system  = $marathon::params::startup_system,
  $run_user        = $marathon::params::run_user,
  $run_group       = $marathon::params::run_group,
) inherits ::marathon::params {
  validate_string($service_name)
  validate_absolute_path($launcher_path)
  validate_bool($startup_manage)
  validate_bool($launcher_manage)

  if $jar_file_path {
    validate_absolute_path($jar_file_path)
  }

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if $startup_manage {

    if $startup_system == 'upstart' {

      class { '::marathon::startup::upstart' :
        launcher_path => $launcher_path,
        jar_file_path => $jar_file_path,
        service_name  => $service_name,
        run_user      => $run_user,
        run_group     => $run_group,
      }

      contain 'marathon::startup::upstart'

    } elsif $startup_system == 'systemd' {

      class { '::marathon::startup::systemd' :
        launcher_path => $launcher_path,
        jar_file_path => $jar_file_path,
        service_name  => $service_name,
        run_user      => $run_user,
        run_group     => $run_group,
      }

      contain 'marathon::startup::systemd'

    }

  }

  if $launcher_manage {

    file { 'marathon_launcher_file' :
      path    => $launcher_path,
      content => template('marathon/launcher.sh.erb'),
      mode    => '0755',
    }

    File['marathon_launcher_file'] ~>
    Service <| title == 'marathon' |>

  }

}
