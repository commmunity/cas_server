# define consumable interface, that intend to be used when a ticket is used and should not be used again
module CasServer
  module Entity
    module Consumable
      def consumed?
        !consumed_at.nil?
      end
      
      def consume!
        self.consumed_at = Time.now.utc
        self.save!
        self
      end
    end
  end
end