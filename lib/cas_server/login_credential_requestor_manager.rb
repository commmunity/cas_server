# 2.1. /login as credential requestor
# The /login URI operates with two behaviors: as a credential requestor, and as a 
# credential acceptor. It responds to credentials by acting as a credential acceptor and 
# otherwise acts as a credential requestor.
module CasServer
  class LoginCredentialRequestorManager < Manager
    accept  :service, :renew, :gateway
    
    def gateway?
      params[:gateway]
    end
  
    def renew?
      params[:renew]
    end
    
    # get the ticket granting cookie value if any
    def ticket_granting_cookie
      cookies[:tgt]
    end
    
    def ticket_granting_ticket
      @tgt ||= CasServer::Entity::TicketGrantingCookie.from_cookie(ticket_granting_cookie)
    end
    
    def sso_enabled?
      ticket_granting_ticket
    end
    
    def default_template
      :credential_requestor
    end
    
    def process!
      if sso_enabled? && !renew?
        if service?
          #generate service ticket and redirect
          service_ticket = CasServer::Entity::ServiceTicket.generate_for(ticket_granting_ticket.username, service_url)
          return(redirect_to service_ticket.service_url_with_service_ticket)
        else
          #display message saying your logged, should not really occurred
          return
        end
      elsif gateway? && !renew?
        raise CasServer::InvalidRequest if !service?
        return(redirect_to service_url)
      else
        # display credential requestor
        return
      end
    end #end process
  end
end