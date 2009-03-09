require "#{File.dirname(__FILE__)}/spec_helper"
include Sinatra::Test

describe 'main application' do
  it 'should show the default index page' do
    get '/'
    response.should be_ok
    response.body.should match(/About this Site/)
  end
end
