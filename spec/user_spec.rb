require "#{File.dirname(__FILE__)}/spec_helper"

describe 'user' do
  before(:each) do
    @user = User.new(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test')
  end

  it 'should be valid' do
    @user.should be_valid
  end

  it 'should require an email' do
    @user = User.new
    @user.save.should be_false
    @user.errors[:email].should include("Email must not be blank")
  end
  
  it 'should associate with links' do
    @link = Link.new(:url => 'http://google.com')
    @user.links.push(@link)
    @user.links[0].should be_instance_of(Link)
  end
end
