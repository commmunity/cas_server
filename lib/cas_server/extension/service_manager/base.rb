module CasServer
  module Extension
    module ServiceManager
      class Base
        class << self       
          def implementations
            @@implementations ||= []
          end

          def inherited(subklass)
            implementations << subklass
            super
          end

          def model
            @model ||= name.demodulize.underscore.to_sym
          end
        end
        
        attr_reader :service
        attr_reader :server
        
        delegate :current_authenticator, :to => :server
        
        def initialize(service, rack_server)
          @server = rack_server
          @service = nil
          if service.present?
            @service = URI.parse(service.to_s) rescue nil 
            raise CasServer::InvalidServiceURL.new(service) if !@service || !@service.is_a?(URI::HTTP)
          end
        end
        
        def service_url
          @service
        end
        
        # This method has to be overridden
        def valid?
          raise NotImplementedError.new("#{self.class.name}#valid?")
        end
        
        def validate!
          raise CasServer::InvalidServiceURL.new(service) unless valid?
          true
        end  
      end #Base
    end #ServiceManager
  end #Extension
end #CasServer