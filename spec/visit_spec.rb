require "#{File.dirname(__FILE__)}/spec_helper"

describe 'visit' do
  before(:each) do
    @visit = Visit.new(:ip_address => '66.7.245.612')
  end

  it 'should be valid' do
    @visit.should be_valid
  end
end
