# This class will act as an abtract controller handling context data (cookies, params) and interacting
# with cas entities
# It will do all the plumbing work of the CAS 2.0 specification, returning a CasServer::Response instance 
# storing the context data to be modified (like cookies, redirection to be done, warning/error messages, ...)
module CasServer
  class Manager
    class_inheritable_reader :accepted_parameters
    write_inheritable_attribute :accepted_parameters, []
    class_inheritable_reader :demanded_parameters
    write_inheritable_attribute :demanded_parameters, []
    
    class << self
      # Specify accepted params for this REST Web Service
      def accept(*parameters)
        write_inheritable_attribute(:accepted_parameters, parameters) if parameters.present?
      end

      # Mandatory params for this REST Web Service
      def demand(*parameters)
        write_inheritable_attribute(:demanded_parameters, parameters) if parameters.present?
      end
    end
  
    # controller.params => Hash of params
    attr_reader :params
    
    # controller.request.cookies => Hash of key/value
    attr_reader :cookies
    
    attr_reader :response
  
    # initialize instance variables and check params validity
    # raise MissingMandatoryParams in case of mandatory params not set
    def initialize(params, cookies)
      @params = params
      @cookies = cookies
      @response = Response.new
    end
  
    def service_url
      params[:service]
    end
  
    def service?
      params[:service]
    end
  
    delegate :render_template, :redirect_to, :errors, :warnings, :set_cookie, :to => :response
  
    # Process the logic, validation, ... all the dirty specification work
    def process!
      raise NotImplementedError
    end
  
    # to be implemented, it is the template to be displayed in case of error
    def default_template
      raise NotImplementedError
    end
  
    def process
      validate_parameters!
      process!
      render_template default_template if !response.redirect? && !response.render_template?
      return response
    rescue CasServer::Error => error
      errors << error
      render_template default_template
      return response  
    end
  
    protected
      def validate_parameters!
        self.class.demanded_parameters.each do |param| 
          raise MissingMandatoryParams.new(param) unless self.params.has_key?(param)
        end
      end
  end
end