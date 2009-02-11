#This rack middleware add a level of translation between lighty working under 404 mode and rack
module CasServer
  module Rack
    class Lighttpd
      LIGHTY = /^lighttpd/
      
      def initialize(app)
        @app= app
      end
      
      def call(env)
        if env['SERVER_SOFTWARE'] =~ LIGHTY
          request = (env['REQUEST_URI']||'').split('?',2)
          env['PATH_INFO'] = request[0] || ''
          env['QUERY_STRING'] = request[1] || ''
          env['SCRIPT_NAME'] = ''
        end
        @app.call(env)
      end
    end #Lighty
  end #Rack
end #CasServer