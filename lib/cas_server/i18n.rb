#helper class to make ease i18n
#Toto::Tata::ComplexeClass.new.i18n_identifier => 'complexe_class'
module CasServer
  module I18n
    def self.included(base)
      base.extend(ClassMethods)
      super
    end
  
    def i18n_identifier
      self.class.i18n_identifier
    end
  
    module ClassMethods
      def i18n_identifier
        @i18n_identifier ||= self.name.demodulize.underscore
      end
    end
  end
end