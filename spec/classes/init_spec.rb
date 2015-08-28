require 'spec_helper'
describe 'marathon' do

  context 'with defaults for all parameters' do
    it { should contain_class('marathon') }
  end
end
