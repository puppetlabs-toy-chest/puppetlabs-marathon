class marathon::config (
  $zk_servers            = $marathon::params::zk_servers,
  $zk_marathon_servers   = $marathon::params::zk_marathon_servers,
  $zk_mesos_path         = $marathon::params::zk_mesos_path,
  $zk_marathon_path      = $marathon::params::zk_marathon_path,
  $zk_default_port       = $marathon::params::zk_default_port,

  $libprocess_ip         = $marathon::params::libprocess_ip,

  $mesos_principal       = $marathon::params::mesos_principal,
  $mesos_secret          = $marathon::params::mesos_secret,
  $mesos_masters         = $marathon::params::mesos_masters,

  $secret_file_path      = $marathon::params::secret_file_path,

  $config_base_path      = $marathon::params::config_base_path,
  $config_dir_path       = $marathon::params::config_dir_path,
  $config_file_path      = $marathon::params::config_file_path,
  $config_file_mode      = $marathon::params::config_file_mode,

  $java_opts             = $marathon::params::java_opts,
  $java_home             = $marathon::params::java_home,

  $options               = $marathon::params::options,
) inherits ::marathon::params {
  if $zk_servers {
    validate_array($zk_servers)
  }

  if $zk_marathon_servers {
    validate_array($zk_marathon_servers)
  }

  if $mesos_principal or $mesos_secret {
    validate_string($mesos_principal)
    validate_string($mesos_secret)
  }

  if $java_home {
    validate_absolute_path($java_home)
  }

  validate_string($java_opts)
  validate_string($zk_mesos_path)
  validate_string($zk_marathon_path)
  validate_integer($zk_default_port)
  validate_ip_address($libprocess_ip)
  validate_string($mesos_masters)
  validate_absolute_path($secret_file_path)
  validate_absolute_path($config_base_path)
  validate_absolute_path($config_dir_path)
  validate_absolute_path($config_file_path)
  validate_string($config_file_mode)
  validate_hash($options)

  $real_zk_marathon_servers = pick($zk_marathon_servers, $zk_servers)

  if $zk_servers {
    $marathon_master = marathon_zk_url($zk_servers, $zk_mesos_path, $zk_default_port)
  } else {
    $marathon_master = $mesos_masters
  }

  if $real_zk_marathon_servers {
    $marathon_zk = marathon_zk_url($real_zk_marathon_servers, $zk_marathon_path, $zk_default_port)
  }

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => $config_file_mode,
  }

  file { 'marathon_config_base' :
    ensure => 'directory',
    path   => $config_base_path,
  }

  file { 'marathon_config_dir' :
    ensure  => 'directory',
    path    => $config_dir_path,
    purge   => true,
    recurse => true,
  }

  file { 'marathon_config_file' :
    path    => $config_file_path,
    content => template('marathon/config.sh.erb'),
  }

  file { 'marathon_secret_file' :
    path    => $secret_file_path,
    content => $mesos_secret,
  }

  $hiera_options = hiera_hash('marathon::options', { })
  $options_structute = marathon_options($hiera_options, $options)
  $options_defaults = { }
  create_resources('marathon::option', $options_structute, $options_defaults)

  Package <| title == 'marathon' |> ->
  File['marathon_config_base']

  File['marathon_config_dir'] ~>
  Service <| title == 'marathon' |>

  File['marathon_config_file'] ~>
  Service <| title == 'marathon' |>

  File['marathon_secret_file'] ~>
  Service <| title == 'marathon' |>

}
