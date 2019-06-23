require 'spec_helper'
describe 'basic' do
  context 'with default values for all parameters' do
    it { is_expected.to contain_class('basic') }
  end
end
