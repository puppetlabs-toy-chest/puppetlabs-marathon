class marathon (
  $package_manage       = $marathon::params::package_manage,
  $package_ensure       = $marathon::params::package_ensure,
  $package_name         = $marathon::params::package_name,
  $package_provider     = $marathon::params::package_provider,

  $service_manage       = $marathon::params::service_manage,
  $service_enable       = $marathon::params::service_enable,
  $service_name         = $marathon::params::service_name,
  $service_provider     = $marathon::params::service_provider,

  $zk_servers           = $marathon::params::zk_servers,
  $zk_marathon_servers  = $marathon::params::zk_marathon_servers,
  $zk_mesos_path        = $marathon::params::zk_mesos_path,
  $zk_default_port      = $marathon::params::zk_default_port,
  $zk_marathon_path     = $marathon::params::zk_marathon_path,

  $libprocess_ip        = $marathon::params::libprocess_ip,

  $java_opts            = $marathon::params::java_opts,
  $java_home            = $marathon::params::java_home,

  $mesos_principal      = $marathon::params::mesos_principal,
  $mesos_secret         = $marathon::params::mesos_secret,
  $mesos_masters        = $marathon::params::mesos_masters,

  $secret_file_path     = $marathon::params::secret_file_path,

  $config_base_path     = $marathon::params::config_base_path,
  $config_dir_path      = $marathon::params::config_dir_path,
  $config_file_path     = $marathon::params::config_file_path,
  $config_file_mode     = $marathon::params::config_file_mode,

  $startup_manage       = $marathon::params::startup_manage,
  $startup_system       = $marathon::params::startup_system,
  $run_user             = $marathon::params::run_user,
  $run_group            = $marathon::params::run_group,
  $launcher_manage      = $marathon::params::launcher_manage,
  $launcher_path        = $marathon::params::launcher_path,
  $jar_file_path        = $marathon::params::jar_file_path,

  $options              = $marathon::params::options,
) inherits ::marathon::params {

  class { '::marathon::install' :
    package_ensure   => $package_ensure,
    package_name     => $package_name,
    package_manage   => $package_manage,
    package_provider => $package_provider,
  }

  class { '::marathon::config' :
    zk_servers          => $zk_servers,
    zk_marathon_servers => $zk_marathon_servers,
    zk_mesos_path       => $zk_mesos_path,
    zk_marathon_path    => $zk_marathon_path,
    zk_default_port     => $zk_default_port,

    libprocess_ip       => $libprocess_ip,

    mesos_principal     => $mesos_principal,
    mesos_secret        => $mesos_secret,
    mesos_masters       => $mesos_masters,

    secret_file_path    => $secret_file_path,

    config_base_path    => $config_base_path,
    config_dir_path     => $config_dir_path,
    config_file_path    => $config_file_path,
    config_file_mode    => $config_file_mode,

    java_opts           => $java_opts,
    java_home           => $java_home,

    options             => $options,
  }

  class { '::marathon::startup' :
    launcher_manage => $launcher_manage,
    launcher_path   => $launcher_path,
    startup_manage  => $startup_manage,
    jar_file_path   => $jar_file_path,
    service_name    => $service_name,
    startup_system  => $startup_system,
    run_user        => $run_user,
    run_group       => $run_group,
  }

  class { '::marathon::service' :
    service_enable   => $service_enable,
    service_manage   => $service_manage,
    service_name     => $service_name,
    service_provider => $service_provider,
  }

  contain 'marathon::install'
  contain 'marathon::config'
  contain 'marathon::startup'
  contain 'marathon::service'

  Class['marathon::install'] ->
  Class['marathon::config'] ->
  Class['marathon::startup'] ->
  Class['marathon::service']

}
