module CasServer
  module Entity
    module TicketRandomization
      def self.included(base)
        base.class_eval do
          before_validation_on_create :generate_ticket_value!
        end
        super
      end
      
      def ticket_prefix
        raise NotImplementedError.new('You MUST redefine the class ticket prefix')
      end
      
      def generate_ticket_value!
        self.value = "#{self.ticket_prefix}#{random_string}"
      end
      
      # Only return a small subset of what the CAS protocol accept e.g. [A-F0-9] instead of [a-zA-Z0-9?-]
      def random_string(length = 120)
        ActiveSupport::SecureRandom.hex(length)
      end
      module_function :random_string
    end
  end
end