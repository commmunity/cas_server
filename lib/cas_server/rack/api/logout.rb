module CasServer
  module Rack
    module Api
      class Logout < Base
        accept :url
        
        def url?
          params['url'].present?
        end
        
        def process!
          ticket_granting_ticket.destroy! if sso_enabled?
          #TODO single sign out
          delete_cookie 'tgt'
          if url
            warnings << 'cas_server.warning.logout_with_url'
          else
            warnings << 'cas_server.warning.logout'
          end
          #TODO in case of sso you have to be able to redirect to service (or just redirect to service)
        end
      end
    end
  end
end