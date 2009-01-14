# 2.2. /login as credential acceptor
# When a set of accepted credentials are passed to /login, /login acts as a credential 
# acceptor
module CasServer
  class LoginCredentialAcceptorManager < Manager 
    demand :username, :password, :lt
    accept :service, :warn
    
    def lt
      params[:lt]
    end
    
    def username
      params[:username]
    end
    
    def password
      params[:password]
    end
    
    def default_template
      :credential_requestor
    end
    
    def process!
      #validate against LoginTicket
      CasServer::Entity::LoginTicket.validate_ticket!(lt)
      
      #LoginTicket valid, check authentication
      CasServer::Api::Authenticator.authenticate!(username, password)
      
      #Authentication successfull, create ticket granting ticket cookie and set it
      ticket_granting_ticket = CasServer::Entity::TicketGrantingCookie.generate_for(username)
      set_cookie :tgt, ticket_granting_ticket.to_cookie
      
      if service?
        #create service ticket
        service_ticket = CasServer::Entity::ServiceTicket.generate_for(username, service_url)
        return(redirect_to service_ticket.service_url_with_service_ticket)  
      else
        warnings << 'cas_server.warning.no_service_uri'
      end
    end
  end
end