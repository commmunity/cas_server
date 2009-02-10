module CasServer
  module Rack
    #Router of the different cas api, it is not mandatory to use this one, you can roll you own router if you prefer
    class Router
      include CasServer::Loggable
      
      CAS_NAMESPACE = /^\/cas/
      NOT_FOUND = [404, {'Content-Type' => 'text/plain', 'Content-Length' => '9'},['Not Found']]
      
      # extracted from cloudkit
      def r(method, path, params=[])
        CasServer::Rack::RouteCriteria.new(method, path, params)
      end
      
      #app launcher
      def run(app)
        debug "#{app.name} launched"
        app.new.call(@env)
      end
      
      
      def call(env)
        debug "Entering CasRouter with path_info #{env['PATH_INFO']}"
        return NOT_FOUND unless env['PATH_INFO'] =~ CAS_NAMESPACE
        @env = env
        
        debug 'Request seems to be a cas request, start routing'
        request = Request.new(env)
        
        case request
        when r(:get, '/cas/login', ['type' => 'acceptor'])
          run Api::CredentialAcceptor
        when r(:get, '/cas/login')
          run Api::CredentialRequestor
        when r(:post, '/cas/login')
          run Api::CredentialAcceptor
        when r(:*, '/cas/serviceValidate')
          run Api::ServiceValidate
        when r(:*, '/cas/logout')
          run Api::Logout
        else
          debug 'Nothing match'
          NOT_FOUND
        end
      end
    end #Application
  end #Rack
end #CasServer