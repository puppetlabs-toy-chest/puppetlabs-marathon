require 'spec_helper'

describe 'marathon_options' do
  context 'interface' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError) }
    it { is_expected.to run.with_params('1').and_raise_error(Puppet::ParseError) }
  end

  context 'simple values' do
    it { is_expected.to run.with_params({}).and_return({}) }
    it { is_expected.to run.with_params('a' => '1').and_return('a' => { 'value' => '1' }) }
    it { is_expected.to run.with_params(a: '1').and_return(a: { 'value' => '1' }) }
    it { is_expected.to run.with_params('a' => true).and_return('a' => { 'value' => '' }) }
    it { is_expected.to run.with_params('a' => false).and_return('disable_a' => { 'value' => '' }) }
  end

  context 'merge values' do
    it { is_expected.to run.with_params({ 'a' => '1' }, 'b' => '2').and_return('a' => { 'value' => '1' }, 'b' => { 'value' => '2' }) }
    it { is_expected.to run.with_params({ 'a' => '1' }, 'a' => '2').and_return('a' => { 'value' => '2' }) }
    it { is_expected.to run.with_params({ 'a' => true }, 'a' => false).and_return('disable_a' => { 'value' => '' }) }
    it { is_expected.to run.with_params({ 'a' => false }, 'a' => true).and_return('a' => { 'value' => '' }) }
  end
end
