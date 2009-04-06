module CasServer
  module Extension
    module Authenticator
      def self.find(authenticator_model)
        authenticator_model = authenticator_model.to_sym
        authenticator_implementation = Base.implementations.detect {|k| k.model == authenticator_model}
        raise InvalidAuthenticator.new(authenticator_model) unless authenticator_implementation
        authenticator_implementation
      end
    end #Authentication
  end #Extension
end #CasServer