class marathon::install (
  $package_ensure   = $marathon::params::package_ensure,
  $package_name     = $marathon::params::package_name,
  $package_manage   = $marathon::params::package_manage,
  $package_provider = $marathon::params::package_provider,
) inherits ::marathon::params {
  validate_string($package_ensure)
  validate_string($package_name)
  validate_bool($package_manage)

  if $package_provider {
    validate_string($package_provider)
  }

  if $package_manage {

    package { 'marathon' :
      ensure   => $package_ensure,
      name     => $package_name,
      provider => $package_provider,
    }

    Package['marathon'] ~>
    Service <| title == 'marathon' |>

  }

}
