Dir.glob(File.join(File.dirname(__FILE__),'authenticator', '*')).each do |f|
  require f
end

module CasServer
  module Extension
    module Authenticator
      def self.build(*args)
        current_implementation.new(*args)
      end
      
      def self.current_implementation
        authenticator_implementation = Base.implementations.detect {|k| k.model == CasServer::Configuration.authenticator}
        raise InvalidAuthenticator.new(CasServer::Configuration.authenticator) unless authenticator_implementation
        authenticator_implementation
      end
    end #Authentication
  end #Extension
end #CasServer