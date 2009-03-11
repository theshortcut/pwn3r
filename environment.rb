require 'rubygems'
require 'dm-core'
require 'dm-constraints'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'pwn3r',
                 :author => 'Clayton Ferris',
                 :author_site => 'http://claytonferris.com',
                 :url_base => 'http://localhost:4567/'
               )

  DataMapper.setup(:default, "mysql://root@localhost/pwn3r")

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }
end
