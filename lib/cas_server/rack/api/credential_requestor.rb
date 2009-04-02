# 2.1. /login as credential requestor
# The /login URI operates with two behaviors: as a credential requestor, and as a 
# credential acceptor. It responds to credentials by acting as a credential acceptor and 
# otherwise acts as a credential requestor.
module CasServer
  module Rack
    module Api
      class CredentialRequestor < Base
        accept  :service, :renew, :gateway

        def gateway?
          params['gateway']
        end

        def renew?
          params['renew']
        end

        def process!
          if sso_enabled? && !renew?
            if service_url?
              #generate service ticket and redirect
              service_ticket = CasServer::Entity::ServiceTicket.generate_for(ticket_granting_ticket, service_manager)
              return(redirect_to service_ticket.service_url_with_service_ticket)
            else
              #display message saying your logged, should not really occurred
              warnings << 'cas_server.warning.logged_without_service'
              return
            end
          elsif gateway? && !renew?
            raise CasServer::InvalidRequest if !service_url
            return(redirect_to service_url)
          else
            # before_credential_requestor callback
            return handle_callback_response(current_authenticator, :before_credential_requestor) if current_authenticator.has_callback?(:before_credential_requestor)
            #return default 404 response to pass rendering to upstream server
          end
        end
      end #CredentialRequestor
    end #Api
  end #Rack
end #CasServer