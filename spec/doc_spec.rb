require "#{File.dirname(__FILE__)}/spec_helper"

describe 'doc' do
  before(:each) do
    @doc = Doc.new()
  end

  it 'should be valid' do
    @doc.should be_valid
  end

  it 'should associate with a user' do
    @user = User.new(:email => 'test@test.com', :password => 'test', :password_confirmation => 'test')
    @doc.user = @user
    @doc.user.should be_instance_of(User)
  end
  
  it 'should have token (length of 4)' do
    @doc.save
    @doc.token.length.should == 4
  end

end
