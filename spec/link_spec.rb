require "#{File.dirname(__FILE__)}/spec_helper"

describe 'link' do
  before(:each) do
    @link = Link.new(:url => 'http://google.com')
  end

  it 'should be valid' do
    @link.should be_valid
  end

  it 'should require a url' do
    @link = Link.new
    @link.save.should be_false
    @link.errors[:url].should include("Url must not be blank")
  end
  
  it 'should associate with a user' do
    @user = User.new(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test')
    @link.user = @user
    @link.user.should be_instance_of(User)
  end
  
  it 'should sanitize url' do
    @link = Link.new(:url => 'google.com')
    @link.save
    @link.url.should == 'http://google.com'
  end
  
  it 'should have token (length of 4)' do
    @link.save
    @link.token.length.should == 4
  end
end
