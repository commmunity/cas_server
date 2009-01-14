Dir.glob(File.join(File.dirname(__FILE__),'authenticator', '*')).each do |f|
  require f
end

module CasServer
  module Api
    module Authenticator
      def self.authenticate(username, password)
        current_implementation.authenticate(username, password)
      end
      
      def self.authenticate!(*args)
        authenticate(*args) || raise(AuthenticationFailed)
      end
      
      def self.current_implementation
        authenticator_implementation = Base.implementations.detect {|k| k.model == CasServer::Configuration.authenticator}
        raise InvalidAuthenticator.new(CasServer::Configuration.authenticator) unless authenticator_implementation
        authenticator_implementation
      end
    end #Authentication
  end #Api
end #CasServer