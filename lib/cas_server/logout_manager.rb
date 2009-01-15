# 2.3. /logout
# /logout destroys a client's single sign-on CAS session. The ticket-granting cookie (Section 
# 3.6) is destroyed, and subsequent requests to /login will not obtain service tickets until 
# the user again presents primary credentials (and thereby establishes a new single sign-on 
# session).
module CasServer
  class LogoutManager < Manager
    accept :url
  
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
    
    def url
      params[:url]
    end
    
    def url?
      params[:url].present?
    end
  
    def default_template
      :logout
    end
  
    def process!
      @tgt.destroy if sso_enabled?
      set_cookie :tgt, nil
      if url?
        warnings << 'cas_server.warning.logout_with_url'
      else
        warnings << 'cas_server.warning.logout'
      end
    end
  end
end