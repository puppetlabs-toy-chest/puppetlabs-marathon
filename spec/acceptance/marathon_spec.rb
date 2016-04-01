require 'spec_helper_acceptance'

describe 'marathon' do
  pp = <<-eof
if $::operatingsystem == 'Ubuntu' {
  $startup_system = 'upstart'
} elsif $::operatingsystem == 'CentOS' {
  $startup_system = 'systemd'
}

class { '::marathon' :
  launcher_manage => true,
  launcher_path   => '/usr/bin/marathon-launcher',
  startup_manage  => true,
  startup_system  => $startup_system,
  jar_file_path   => '/usr/bin/marathon',
  options         => {
    'event_subscriber' => 'http_callback',
    'http_port' => '8080',
  }
}
  eof

  it_behaves_like 'manifest', pp

  describe service('marathon') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  if os[:family] == 'ubuntu'
    config_file_path = '/etc/default/marathon'
  elsif os[:family] == 'redhat'
    config_file_path = '/etc/sysconfig/marathon'
  else
    config_file_path = '/etc/marathon/config.sh'
  end

  describe file(config_file_path) do
    it { is_expected.to be_file }
    its(:content) { is_expected.to match /export MARATHON_MASTER='zk:\/\/localhost:2181\/mesos'/ }
    its(:content) { is_expected.to match /export MARATHON_ZK='zk:\/\/localhost:2181\/marathon'/ }
    its(:content) { is_expected.to match /export LIBPROCESS_IP='127.0.0.1'/ }
    its(:content) { is_expected.to match /export JAVA_OPTS='-Xmx512m'/ }
  end

  describe file('/usr/bin/marathon-launcher') do
    it { is_expected.to be_file }
  end

  describe file('/usr/bin/marathon') do
    it { is_expected.to be_file }
  end

  describe file('/etc/marathon/conf/http_port') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to eq "8080\n" }
  end

  describe file('/etc/marathon/conf/event_subscriber') do
    it { is_expected.to be_file }
    its(:content) { is_expected.to eq "http_callback\n" }
  end

  describe command('wget --retry-connrefused -t 10 -qO - http://localhost:8080/ping') do
    its(:stdout) { is_expected.to match /pong/ }
  end

  describe command('wget --retry-connrefused -t 10 -qO - http://localhost:5050/frameworks') do
    its(:stdout) { is_expected.to match /marathon/ }
  end

end
