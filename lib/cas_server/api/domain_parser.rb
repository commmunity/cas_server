Dir.glob(File.join(File.dirname(__FILE__),'domain_parser', '*')).each do |f|
  require f
end

module CasServer
  
  module Api
    
    module DomainParser
      
      def self.current_implementation
        implementation = Base.implementations.find { |k| k.model == CasServer::Configuration.domain_parser }
        raise InvalidDomainParser.new(CasServer::Configuration.domain_parser) unless implementation
        implementation
      end
      
    end
    
  end
  
end