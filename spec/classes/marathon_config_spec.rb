require 'spec_helper'

describe 'marathon::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      config_file_path = if facts[:osfamily] == 'Debian'
                           '/etc/default/marathon'
                         elsif facts[:osfamily] == 'RedHat'
                           '/etc/sysconfig/marathon'
                         else
                           '/etc/marathon/config.sh'
                         end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        directory_parameters = {
          ensure: 'directory',
          mode: '0640',
          owner: 'root',
          group: 'root',
        }

        it { is_expected.to contain_file('marathon_config_base').with(directory_parameters) }

        it { is_expected.to contain_file('marathon_config_dir').with(directory_parameters) }

        config = <<-eof
# Mesos connection information
# Master can be set either to the Zookeeper URL
# or to the direct URL of the Mesos master
export MARATHON_MASTER='zk://localhost:2181/mesos'
# Zookeeper URL for Marathon to use for its data
export MARATHON_ZK='zk://localhost:2181/marathon'
# You should provide the IP for libprocess to use for the Mesos master connection
# It will be 127.0.0.1 by default and 0.0.0.0 will not work
# Without this value set Marathon will be able to connect only to the local Mesos master
export LIBPROCESS_IP='127.0.0.1'
# Java options
export JAVA_OPTS='-Xmx512m'
        eof
        config_parameters = {
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0640',
          content: config,
          path: config_file_path,
        }
        it { is_expected.to contain_file('marathon_config_file').with(config_parameters) }

        it { is_expected.to have_marathon__option_resource_count(0) }
      end

      context 'with custom parameters' do
        let(:params) do
          {
            zk_servers: %w(user:pass@zk1 zk2:2183 zk3),
            zk_marathon_servers: %w(zk4 zk5),
            zk_marathon_path: 'my-marathon',
            zk_default_port: '2182',

            libprocess_ip: '192.168.0.1',

            mesos_principal: 'admin',
            mesos_secret: 'secret',

            secret_file_path: '/usr/local/etc/marathon/secret',
            config_base_path: '/usr/local/etc/marathon',
            config_dir_path: '/usr/local/etc/marathon/conf',
            config_file_path: '/etc/default/my-marathon',
            config_file_mode: '0600',

            java_opts: '-Xmx1024m',
            java_home: '/usr/local/java',

            options: {
              'event_subscriber' => 'http_callback',
            }
          }
        end

        it { is_expected.to compile.with_all_deps }

        directory_parameters = {
          ensure: 'directory',
          mode: '0600',
          owner: 'root',
          group: 'root',
        }

        it { is_expected.to contain_file('marathon_config_base').with(directory_parameters) }

        it { is_expected.to contain_file('marathon_config_dir').with(directory_parameters) }

        config = <<-eof
# Mesos connection information
# Master can be set either to the Zookeeper URL
# or to the direct URL of the Mesos master
export MARATHON_MASTER='zk://user:pass@zk1,zk2:2183,zk3:2182/mesos'
# Zookeeper URL for Marathon to use for its data
export MARATHON_ZK='zk://zk4:2182,zk5:2182/my-marathon'
# Mesos Auth connection credentials
# They will be used to connect to the Mesos master
export MARATHON_MESOS_AUTHENTICATION_PRINCIPAL='admin'
export MARATHON_MESOS_AUTHENTICATION_SECRET_FILE='/usr/local/etc/marathon/secret'
# You should provide the IP for libprocess to use for the Mesos master connection
# It will be 127.0.0.1 by default and 0.0.0.0 will not work
# Without this value set Marathon will be able to connect only to the local Mesos master
export LIBPROCESS_IP='192.168.0.1'
# Java options
export JAVA_OPTS='-Xmx1024m'
export JAVA_HOME='/usr/local/java'
        eof

        config_parameters = {
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0600',
          content: config,
        }

        it { is_expected.to contain_file('marathon_config_file').with(config_parameters) }

        it { is_expected.to contain_file('marathon_secret_file').with_content('secret') }

        it { is_expected.to contain_marathon__option('event_subscriber').with_value('http_callback') }

        it { is_expected.to contain_file('marathon-option-event_subscriber').with_content("http_callback\n") }
      end

      context 'with alternative zk_marathon_servers' do
        let(:params) do
          {
            zk_servers: %w(user:pass@zk1 zk2:2183 zk3),
            zk_marathon_servers: %w(user:pass@zk14 zk5:2183 zk6),
          }
        end

        config = <<-eof
# Mesos connection information
# Master can be set either to the Zookeeper URL
# or to the direct URL of the Mesos master
export MARATHON_MASTER='zk://user:pass@zk1,zk2:2183,zk3:2181/mesos'
# Zookeeper URL for Marathon to use for its data
export MARATHON_ZK='zk://user:pass@zk14,zk5:2183,zk6:2181/marathon'
# You should provide the IP for libprocess to use for the Mesos master connection
# It will be 127.0.0.1 by default and 0.0.0.0 will not work
# Without this value set Marathon will be able to connect only to the local Mesos master
export LIBPROCESS_IP='127.0.0.1'
# Java options
export JAVA_OPTS='-Xmx512m'
        eof

        config_parameters = {
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0640',
          content: config,
        }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('marathon_config_file').with(config_parameters) }
      end

      context 'without zk_servers' do
        let(:params) do
          {
            zk_servers: [],
          }
        end

        config = <<-eof
# You should provide the IP for libprocess to use for the Mesos master connection
# It will be 127.0.0.1 by default and 0.0.0.0 will not work
# Without this value set Marathon will be able to connect only to the local Mesos master
export LIBPROCESS_IP='127.0.0.1'
# Java options
export JAVA_OPTS='-Xmx512m'
        eof

        config_parameters = {
          ensure: 'present',
          owner: 'root',
          group: 'root',
          mode: '0640',
          content: config,
        }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_file('marathon_config_file').with(config_parameters) }
      end

      context 'unsupported operating system' do
        describe 'falls back to the default values on Solaris/Nexenta' do
          let(:facts) do
            {
              osfamily: 'Solaris',
              operatingsystem: 'Nexenta',
              puppetversion: ENV['PUPPET_VERSION'] || '3.7.0',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_file('marathon_config_file').with_path('/etc/marathon/config.sh') }
        end
      end
    end
  end
end
