#2.5. /serviceValidate [CAS 2.0]
# /serviceValidate checks the validity of a service ticket and returns an XML-fragment 
# response. /serviceValidate MUST also generate and issue proxy-granting tickets when 
# requested.
module CasServer
  module Rack
    module Api
      class ServiceValidate < Base
        demand :service, :ticket
        accept :pgtUrl, :renew
        
        attr_reader :service_ticket
        
        def ticket
          params['ticket']
        end
    
        def process!
          @service_ticket = CasServer::Entity::ServiceTicket.validate_ticket!(ticket, service_manager)
          @extra_attributes = @service_ticket.extra_attributes(service_manager)
          render_xml <<SUCCESS_RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
  <cas:authenticationSuccess>
    <cas:user>#{@service_ticket.username.to_xs}</cas:user>
    #{@extra_attributes.to_xml(:skip_instruct => true, :root => 'sc:profile').gsub(/<sc:profile>/, '<sc:profile xmlns:sc="http://slashcommunity.com/api/v1/profile">')}
  </cas:authenticationSuccess>
</cas:serviceResponse>
SUCCESS_RESPONSE
        end
        
        def exception_handler
          :service_validate_exception_handler
        end
        
        def service_validate_exception_handler(exception)
          render_xml <<FAILED_RESPONSE
<?xml version="1.0" encoding="UTF-8"?>
<cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
  <cas:authenticationFailure code="#{exception.error_identifier.to_xs}">#{exception.message.to_xs}</cas:authenticationFailure>
</cas:serviceResponse>
FAILED_RESPONSE
          return @response.finish
        end
      end #ServiceValidate
    end #Api
  end #Rack
end #CasServer