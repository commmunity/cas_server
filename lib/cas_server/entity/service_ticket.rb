require 'uri'
# 3.1. service ticket
# A service ticket is an opaque string that is used by the client as a credential to obtain 
# access to a service. The service ticket is obtained from CAS upon a client's presentation 
# of credentials and a service identifier to /login as described in Section 2.2.
module CasServer
  module Entity
    class ServiceTicket < ActiveRecord::Base
      belongs_to :ticket_granting_cookie, :class_name => "CasServer::Entity::TicketGrantingCookie"
      validates_presence_of :ticket_granting_cookie_id
      
      include CasServer::I18n
      include CasServer::Entity::Consumable
      include CasServer::Entity::Expirable
      include CasServer::Entity::TicketRandomization
      
      def ticket_prefix
        'ST-'
      end
      
      def service_url_with_service_ticket
        return nil if service.blank?

        begin
          raw_uri = URI.parse(service)
          query_string = raw_uri.query || ''
          params = query_string.split('&').inject({}) do |h, chunk| 
            key, value = chunk.split('=', 2)
            h[key] = value
            h
          end
          params['ticket'] = value
          raw_uri.query= params.to_query
          raw_uri.to_s
        rescue URI::InvalidURIError
          nil
        end
      end
      
      class << self
        # Extension to generate service ticket
        def generate_for(ticket_granting_cookie, service)
          ticket_granting_cookie.service_tickets.create!(:username => ticket_granting_cookie.username, :service => service)
        end
        
        def validate_ticket!(value, service)
          ticket = value && find_by_value(value)
          raise CasServer::InvalidTicket.new(self.new) if ticket.nil?
          if ticket.service != service
            ticket.destroy
            raise CasServer::InvalidService.new(ticket)
          end 
          raise CasServer::ExpiredTicket.new(ticket) if ticket.expired?
          raise CasServer::ConsumedTicket.new(ticket) if ticket.consumed?
          ticket.consume!
        end
      end
    end
  end
end
