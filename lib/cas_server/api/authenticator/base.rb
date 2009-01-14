module CasServer
  module Api
    module Authenticator
      class Base
        # available authenticator implementation
        def self.implementations
          @@implementations ||= []
        end
        
        def self.inherited(subklass)
          implementations << subklass
          super
        end
        
        def self.model
          @model ||= self.name.demodulize.underscore.to_sym
        end
      end #Base
    end #Authenticator
  end #Api
end #CasServer