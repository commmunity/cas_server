module CasServer
  module Extension
    module Authenticator
      def self.find(authenticator_model)
        authenticator_model = authenticator_model.to_sym
        authenticator_implementation = Base.implementations.detect {|k| k.model == authenticator_model}
        raise InvalidAuthenticator.new(CasServer::Configuration.authenticator) unless authenticator_implementation
        authenticator_implementation
      end
      
      def self.default
        authenticator_implementation = self.find(CasServer::Configuration.authenticator)
      end
    end #Authentication
  end #Extension
end #CasServer