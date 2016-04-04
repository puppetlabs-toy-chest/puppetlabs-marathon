require 'spec_helper'

describe 'marathon::install' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        package_parameters = {
          ensure: 'present',
          name: 'marathon',
        }

        it { is_expected.to contain_package('marathon').with(package_parameters) }
      end

      context 'with custom parameters' do
        let(:params) do
          {
            package_manage: true,
            package_name: 'my-marathon',
            package_provider: 'pip',
            package_ensure: 'latest',
          }
        end

        it { is_expected.to compile.with_all_deps }

        package_parameters = {
          ensure: 'latest',
          name: 'my-marathon',
          provider: 'pip',
        }

        it { is_expected.to contain_package('marathon').with(package_parameters) }
      end

      context 'with package_manage disabled' do
        let(:params) do
          {
            package_manage: false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_package('marathon') }
      end
    end
  end
end
