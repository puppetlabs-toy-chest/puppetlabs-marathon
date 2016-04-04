class marathon::service (
  $service_enable   = $marathon::params::service_enable,
  $service_manage   = $marathon::params::service_manage,
  $service_provider = $marathon::params::service_provider,
  $service_name     = $marathon::params::service_name,
) inherits ::marathon::params {
  validate_string($service_name)
  validate_bool($service_manage)
  validate_bool($service_enable)

  if $service_provider {
    validate_string($service_provider)
  }

  if $service_manage {

    if $service_enable {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }

    service { 'marathon' :
      ensure     => $service_ensure,
      name       => $service_name,
      hasstatus  => true,
      hasrestart => true,
      enable     => $service_enable,
      provider   => $service_provider,
    }

    Service <| title == 'mesos-master' |> ->
    Service['marathon']

  }
}
