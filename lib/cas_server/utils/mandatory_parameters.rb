#This is a mixin to manage manadatory params
module CasServer
  module Utils
    module MandatoryParameters
      def self.included(base)
        base.class_eval do
          class_inheritable_reader :accepted_parameters
          write_inheritable_attribute :accepted_parameters, []
          class_inheritable_reader :demanded_parameters
          write_inheritable_attribute :demanded_parameters, []
        end
        base.extend ClassMethods
      end

      module ClassMethods
        # Specify accepted params for this REST Web Service
        def accept(*parameters)
          write_inheritable_attribute(:accepted_parameters, parameters) if parameters.present?
        end

        # Mandatory params for this REST Web Service
        def demand(*parameters)
          write_inheritable_attribute(:demanded_parameters, parameters) if parameters.present?
        end
      end
      
      def validate_parameters!
        self.class.demanded_parameters.each do |param| 
          raise MissingMandatoryParams.new(param) unless self.params.has_key?(param.to_s)
        end
      end
      
      def has_mandatory_params(param)
        self.class.demanded_parameters.include?(param.to_sym)
      end 
    end
  end
end