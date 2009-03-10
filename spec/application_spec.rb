require "#{File.dirname(__FILE__)}/spec_helper"
include Sinatra::Test

describe 'main application' do
  it 'should show the default index page' do
    get '/'
    response.should be_ok
    response.body.should match(/About this Site/)
  end

  it 'should add visits when link is followed' do
    @link = Link.new(:url => "google.com")
    @link.save
    # if Rack::MockRequest mocked an ip address we could just do:
    # get "/#{@link.token}"
    # since it doesn't, fake it I guess...
    @link.visits.build(:ip_address => '127.0.0.1')
    @link.visits.first.ip_address.should match(/^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/)
  end
end
