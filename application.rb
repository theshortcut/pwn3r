require 'rubygems'
require 'sinatra'
require 'environment'
require 'fileutils'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'

error do
  e = request.env['sinatra.error']
  puts e.to_s
  puts e.backtrace.join('\n')
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  haml :root
end

# authentication stuff
get '/logged_in' do
  if session[:user]
    "true"
  else
    "false"
  end
end

get '/login' do
  haml :login
end

post '/login' do
    if user = User.authenticate(params[:email], params[:password])
      session[:user] = user.id
      redirect_to_stored
    else
      redirect '/login'
    end
end

get '/logout' do
  session[:user] = nil
  @message = "in case it weren't obvious, you've logged out"
  redirect '/'
end

get '/signup' do
  haml :signup
end

post '/signup' do
  @user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user] = @user.id
    redirect '/'
  else
    session[:flash] = "failure!"
    redirect '/'
  end
end

delete '/user/:id' do
  user = User.first(params[:id])
  user.delete
  session[:flash] = "way to go, you deleted a user"
  redirect '/'
end

get '/dashboard' do
  login_required
  @links = Link.all(:user_id => session[:user].object_id)
  @docs = Doc.all(:user_id => session[:user].object_id)
  haml :dashboard
end

get '/link/new' do
  login_required
  haml :'link/new'
end

post '/link/new' do
  @link = Link.new(:url => params[:url], :user_id => session[:user].object_id)
  if @link.save
    redirect '/dashboard'
  else
    session[:flash] = "failure!"
  end
end

get '/doc/new' do
  haml :'doc/new'
end

post '/doc/new' do
  @file = params[:file][:tempfile]
  @doc = Doc.new(:filename => params[:file][:filename], :user_id => session[:user].object_id)
  if @doc.save
    FileUtils.mkdir_p "public/#{current_user.email}"
    File.open("public/#{current_user.email}/#{@doc.filename}",'w'){|f| f.write @file.read}
    redirect '/dashboard'
  else
    session[:flash] = "failure!"
  end
end

# sass
get '/main.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :main
end

# token stuff
get '/:token' do
  @link = Link.first(:token => params[:token])
  if @link.nil?
    @link = Doc.first(:token => params[:token])
  end
  if !@link.nil?
    @link.add_visit(request)
    if @link.class == Link
      redirect @link.url
    elsif @link.class == Doc
      owner = User.first(@link.user_id)
      # redirect "/#{owner.first.email}/#{@link.filename}"
      send_file "public/#{owner.first.email}/#{@link.filename}", :disposition => 'inline'
    end
  elsif @link.nil?
    redirect '/'
  end
end

private

def login_required
  if session[:user]
    return true
  else
    session[:return_to] = request.fullpath
    redirect '/login'
    return false 
  end
end

def current_user
  temp_user = User.first(session[:user].object_id)
  current_user = temp_user.first
end

def redirect_to_stored
  if return_to = session[:return_to]
    session[:return_to] = nil
    redirect return_to
  else
    redirect '/'
  end
end
