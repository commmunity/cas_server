require 'lib/cas_server'
cas_server = CasServer::Rack::Router.new
use CasServer::Rack::ActiveRecord
run cas_server
