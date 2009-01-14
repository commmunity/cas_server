#2.5. /serviceValidate [CAS 2.0]
# /serviceValidate checks the validity of a service ticket and returns an XML-fragment 
# response. /serviceValidate MUST also generate and issue proxy-granting tickets when 
# requested.
module CasServer
  class ServiceValidateManager < Manager
    demand :service, :ticket
    accept :pgtUrl, :renew
    
    def ticket
      params[:ticket]
    end
    
    def default_template
      :service_validate
    end
    
    def service_ticket
      @service_ticket
    end
    
    def process!
      @service_ticket = CasServer::Entity::ServiceTicket.validate_ticket!(ticket, service_url) 
    end
    
  end
end