# manage entity expiration, and storage cleanup
module CasServer
  module Entity
    module Expirable
      def self.included(base)
        base.extend(ClassMethods)
        super
      end
      
      def expired?
        Time.now.utc - self.created_at.utc > CasServer::Configuration.ticket_expiration
      end
      
      module ClassMethods
        # Cleanup the database from expired tickets
        # TODO paginate deletion to avoid db lock
        def cleanup_expired!
          delete_all :conditions => ["created_at < ?", Time.now.utc - 3 * CasServer::Configuration.ticket_expiration]
        end
      end
    end
  end
end