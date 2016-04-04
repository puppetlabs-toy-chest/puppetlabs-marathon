require 'spec_helper'

describe 'marathon::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        package_parameters = {
          ensure: 'running',
          enable: true,
          name: 'marathon',
        }
        it { is_expected.to contain_service('marathon').with(package_parameters) }
      end

      context 'with custome parameters' do
        let(:params) do
          {
            service_manage: true,
            service_enable: false,
            service_name: 'my-marathon',
            service_provider: 'systemd',
          }
        end

        it { is_expected.to compile.with_all_deps }

        package_parameters = {
          ensure: 'stopped',
          enable: false,
          name: 'my-marathon',
          provider: 'systemd',
        }
        it { is_expected.to contain_service('marathon').with(package_parameters) }
      end

      context 'with service_manage disabled' do
        let(:params) do
          {
            service_manage: false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_service('marathon') }
      end
    end
  end
end
