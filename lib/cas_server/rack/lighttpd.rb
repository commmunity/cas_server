#This rack middleware add a level of translation between lighty working under 404 mode and rack
module CasServer
  module Rack
    class Lighttpd
      def initialize(app)
        @app= app
      end
      
      def call(env)
        env['PATH_INFO'] = env['REQUEST_URI']
        env['SCRIPT_NAME'] = ''
        @app.call(env)
      end
    end #Lighty
  end #Rack
end #CasServer