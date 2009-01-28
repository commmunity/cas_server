Dir.glob(File.join(File.dirname(__FILE__),'service_manager', '*')).each do |f|
  require f
end

module CasServer
  module Extension
    module ServiceManager
      def self.build(service_url, rack_server)
        current_implementation.new(service_url, rack_server)
      end
      
      def self.current_implementation
        implementation = Base.implementations.find { |k| k.model == CasServer::Configuration.service_manager }
        raise InvalidServiceManager.new(CasServer::Configuration.service_manager) unless implementation
        implementation
      end
    end #ServiceManager
  end #Extension
end #CasServer