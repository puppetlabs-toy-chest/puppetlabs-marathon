# marathon Puppet module

This module is intended to manage the Marathon installation.
It can install the package, configure startup scripts, create config
files and run the service.

## Sample Usage

Without parameters:

```puppet
class { 'marathon' :}
```

With parameters:

```puppet
class { 'marathon' :
  zk_servers      => ['node1','node2'],
  startup_manage  => false,
  launcher_manage => false,
  libprocess_ip   => '192.168.0.1',
  mesos_principal => 'admin',
  mesos_secret    => 'pass',
  http_user       => 'user',
  http_password   => 'password',
  options         => {
    'event_subscriber' => 'http_callback',
  }
}
```

Using the Hiera YAML file:

```yaml
marathon::zk_servers:
- node1
- node2
marathon::libprocess_ip: 192.168.0.1
marathon::options:
  event_subscriber: http_callback
```

Marathon options will be merged across the Hiera hierarchy levels
so you can add more options to the hash.

## Parameters

### `package_manage`

Should the module try to install a marathon package?
Default: true

### `package_name`

The real name of the marathon package.
Default: marathon

### `package_ensure`

The version of marathon package to install.
Default: present

### `service_manage`

Should the module try to work with marathon service?
Default: true

### `service_enable`

Should the the module enable and run or disable and stop the service?
Default: true

### `service_name`

The name of the service to manage.
Default: marathon

### `service_provider`

Override the service provider if you have reasons to do so.
Default: undef

### `zk_servers`

The list of Zookeeper servers used by Mesos and Marathon
It will generate "master" and "zk" options with
zookeeper urls URLs. Empty array will disable these options
and the value from */etc/mesos/zk* will be used.
Default: ['localhost']

### `zk_marathon_servers`

The list of Zookeeper servers for Marathon to use for storing its state.
Will be equal to *zk_servers* unless alternative value is defined.
Default: undef

### `zk_default_port`

The default Zookeeper port to use if the server is given without
a port like "ip:port"
Default: 2181

### `zk_mesos_path`

The Zookeeper path used by Mesos.
Default: mesos

### `zk_marathon_path`

The Zookeeper path used by Marathon.
Default: marathon

### `libprocess_ip`

The IP address used by libprocess to connect to the remote Mesos master
Must be set to the real IP address of the node. If unset, the Marathon
service will only be able to work with the local Mesos master.
Default: 127.0.0.1

### `java_opts`

A string of Java options
Default: -Xmx512m

### `java_home`

Path to a custom Java home
Default: undef

### `mesos_principal`

Use this principal name for Mesos master connection.
Default: undef

### `mesos_secret`

Use this password for Mesos master connection.
Default: undef

### `mesos_masters`

This option can contain the URL of the Mesos master and will be used if
no zookeeper are provided.
Default: "http://localhost:5050"

### `secret_file_path`

The path to the file used to store the Mesos secret.
Default: /etc/marathon/auth_secret

### `config_base_path`

The path to the Marathon configuration directory.
Default: /etc/marathon

### `config_dir_path`

The path to the directory used by custom Marathon options.
Default: /etc/marathon/conf

### `config_file_path`

The path to the main Marathon config file.
Default: /etc/default/${service_name}

### `startup_manage`

Should the module try to install init/upstart scripts for the service?
You should set *startup_system* if you enable this.
Default: true

### `launcher_manage`

Should the module try to install the launcher shell script?
Default: true

### `launcher_path`

The path to the launcher shell script file.
Default: /usr/bin/marathon

### `jar_file_path`

The path to the actual Marathon jar file.
Default: undef

### startup_system

Which startup files should be installed?
Default: undef

### run_user

Run the service by this system user in the startup files.
User will NOT be created.
Default: undef

### run_group

Run the service by this system group in the startup files.
Group will NOT be created.
Default: undef

### `options`

This hash can contain additional Marathon options
You can find the list of possible values and their description
[here](https://mesosphere.github.io/marathon/docs/command-line-flags.html).
Default: {}

If your package contains startup files and the launcher file together
with the jar file you may want to disable *manage_startup* and
*manage_launcher* options if you want to keep the versions from
your package.

