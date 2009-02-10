#cleanup connection pool under multithreading
module CasServer
  module Rack
    class ActiveRecord
      def initialize(app)
        @app = app
      end
      
      def call(env)
        response = @app.call(env)
      ensure
        ::ActiveRecord::Base.clear_active_connections!
        response
      end
    end
  end
end