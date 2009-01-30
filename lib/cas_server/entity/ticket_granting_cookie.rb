# 3.6. ticket-granting cookie 
# A ticket-granting cookie is an HTTP cookie[5] set by CAS upon the establishment of a 
# single sign-on session. This cookie maintains login state for the client, and while it is 
# valid, the client can present it to CAS in lieu of primary credentials. Services can opt out 
# of single sign-on through the "renew" parameter described in Sections 2.1.1, 2.4.1, and 
# 2.5.1.
module CasServer
  module Entity
    class TicketGrantingCookie < ActiveRecord::Base
      #include CasServer::Entity::Expirable
      include CasServer::I18n
      include CasServer::Entity::TicketRandomization
      
      has_many :service_tickets, :class_name => "CasServer::Entity::ServiceTicket"
      serialize :extra_attributes
      
      def ticket_prefix
        'TGC-'
      end
      
      def to_cookie
        cookie = {:value => value, :path => '/cas', :http_only => false}
        cookie[:secure]=true if CasServer::Configuration.ssl_enabled
        cookie
      end
      
      class << self
        # Extension to generate ticket granting ticket
        def generate_for(authenticator)
          create!(:username => authenticator.uuid, :extra_attributes => (authenticator.extra_attributes||{})) if authenticator
        end
        
        #TODO add some expiration AND/OR consumption mecanism
        def from_cookie(value)
          ticket = value && find_by_value(value)
          ticket
        end
      end
    end
  end
end