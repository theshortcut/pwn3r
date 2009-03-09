require 'rubygems'
require 'sinatra'
require 'environment'

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

get '/home' do
  login_required
  haml :home
end

# sass
get '/main.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :main
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
  User.first(session[:user])
end

def redirect_to_stored
  if return_to = session[:return_to]
    session[:return_to] = nil
    redirect return_to
  else
    redirect '/'
  end
end