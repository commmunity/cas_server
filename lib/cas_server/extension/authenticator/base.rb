module CasServer
  module Extension
    module Authenticator
      class Base
        class << self
          # available authenticator implementation
          def implementations
            @@implementations ||= []
          end
        
          def inherited(subklass)
            implementations << subklass
            super
          end
        
          def model
            @model ||= self.name.demodulize.underscore.to_sym
          end
        end # << self
        
        def initialize(*args)
        end
        
        def authenticate!
          authenticate? || raise(AuthenticationFailed)
        end
        
        #should be a boolean
        def authenticate?
          raise NotImplementedError.new("#{self.class.name}#authenticate?")
        end
        
        def uuid
          raise NotImplementedError.new("#{self.class.name}#uuid")
        end
        
        #should be a hash
        def extra_attributes
          raise NotImplementedError.new("#{self.class.name}#extra_attributes")
        end
      end #Base
    end #Authenticator
  end #Extension
end #CasServer