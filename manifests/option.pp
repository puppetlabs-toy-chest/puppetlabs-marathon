define marathon::option (
  $ensure = 'present',
  $owner  = 'root',
  $group  = 'root',
  $mode   = undef,
  $path   = undef,
  $value  = undef,
) {
  include '::marathon::params'

  $config_dir_path = $::marathon::params::config_dir_path
  $config_file_mode = $::marathon::params::config_file_mode

  $file_path = pick($path, "${config_dir_path}/${name}")
  $file_mode = pick($mode, $config_file_mode)
  $file_title = "marathon-option-${name}"

  file { $file_title :
    ensure  => $ensure,
    path    => $file_path,
    owner   => $owner,
    group   => $group,
    mode    => $file_mode,
    content => "${value}\n",
  }

  File <| title == 'marathon_config_dir' |> ->
  File[$file_title] ~>
  Service <| title == 'marathon' |>
}
