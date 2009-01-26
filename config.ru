require 'lib/cas_server'
cas_server = CasServer::Rack::Router.new
run cas_server
