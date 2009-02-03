# 2.2. /login as credential acceptor
# When a set of accepted credentials are passed to /login, /login acts as a credential 
# acceptor
module CasServer
  module Rack
    module Api
      class CredentialAcceptor < Base
        demand :username, :password, :lt
        accept :service, :warn
        
        def lt
          params['lt']
        end

        def username
          params['username']
        end

        def password
          params['password']
        end
        
        def process!
          #validate against LoginTicket
          CasServer::Entity::LoginTicket.validate_ticket!(lt)
          
          debug 'Try to authenticate with authenticator'
          #LoginTicket valid, check authentication
          @authenticator = CasServer::Extension::Authenticator.build(username, password)
          @authenticator.authenticate!
          
          debug "Authentication successful Generate SSO ticket granting cookie for uuid:#{@authenticator.uuid} with extra_attributes: #{@authenticator.extra_attributes.inspect}"
          #Authentication successful, create ticket granting ticket cookie and set it
          ticket_granting_ticket = CasServer::Entity::TicketGrantingCookie.generate_for(@authenticator)
          set_cookie :tgt, ticket_granting_ticket.to_cookie

          if service_url
            #create service ticket
            service_ticket = CasServer::Entity::ServiceTicket.generate_for(ticket_granting_ticket, service_url)
            return(redirect_to service_ticket.service_url_with_service_ticket)  
          else
            warnings << 'cas_server.warning.no_service_uri'
          end
        end
      end #CredentialAcceptor
    end #Api
  end #Rack
end #CasServer