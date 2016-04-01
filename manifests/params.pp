class marathon::params {
  $package_manage = true
  $package_ensure = 'present'
  $package_provider = undef

  $service_enable = true
  $service_manage = true
  $service_provider = undef

  $zk_servers = ['localhost']
  $zk_marathon_servers = undef
  $zk_mesos_path = 'mesos'
  $zk_marathon_path = 'marathon'
  $zk_default_port = '2181'
  $libprocess_ip = '127.0.0.1'

  $java_opts = '-Xmx512m'
  $java_home = undef

  $mesos_principal = undef
  $mesos_secret = undef
  $mesos_masters = 'http://localhost:5050'

  $secret_file_path = '/etc/marathon/auth_secret'

  $config_base_path = '/etc/marathon'
  $config_dir_path = '/etc/marathon/conf'
  $config_file_mode = '0640'

  $startup_manage = false
  $startup_system = undef
  $launcher_manage = false
  $launcher_path = '/usr/bin/marathon'
  $jar_file_path = undef
  $run_user = undef
  $run_group = undef

  $options = { }

  case $::osfamily {
    'Debian': {
      $package_name = 'marathon'
      $service_name = 'marathon'
      $config_file_path = '/etc/default/marathon'
    }
    'RedHat', 'Amazon': {
      $package_name = 'marathon'
      $service_name = 'marathon'
      $config_file_path = '/etc/sysconfig/marathon'
    }
    default: {
      warning("${::osfamily} is not supported! But you can manually configure all parameters or use the default values.")
      $package_name     = 'marathon'
      $service_name     = 'marathon'
      $config_file_path = '/etc/marathon/config.sh'
    }
  }

}
