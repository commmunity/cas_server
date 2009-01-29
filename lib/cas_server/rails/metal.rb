#adapter to rails metal
module CasServer
  module Rails
    class Metal < ::Rails::Rack::Metal
      def call(env)
        CasServer::Rack::Router.new.call(env)
      end
    end
  end
end