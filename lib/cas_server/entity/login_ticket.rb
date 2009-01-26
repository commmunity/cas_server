# 3.5. login ticket 
# A login ticket is a string that is provided by /login as a credential requestor and passed to 
# /login as a credential acceptor for username/password authentication. Its purpose is to 
# prevent the replaying of credentials due to bugs in web browsers. 
module CasServer
  module Entity
    class LoginTicket < ActiveRecord::Base
      include CasServer::I18n
      include CasServer::Entity::Consumable
      include CasServer::Entity::Expirable
      include CasServer::Entity::TicketRandomization
      
      def ticket_prefix
        'LT-'
      end
      
      class << self
        # Extension to generate login ticket
        def generate_for
          create!
        end
        
        # check the validity of the login ticket
        # raise InvalidTicket, ConsumedTicket, ExpiredTicket
        def validate_ticket!(value)
          ticket = value && find_by_value(value)
          raise CasServer::InvalidTicket.new(self.new) if ticket.nil?
          raise CasServer::ExpiredTicket.new(ticket) if ticket.expired?
          raise CasServer::ConsumedTicket.new(ticket) if ticket.consumed?
          ticket.consume!
        end
      end
    end
  end
end
