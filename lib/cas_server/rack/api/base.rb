# This is the Rack interface that handle all the cas api
module CasServer
  module Rack
    module Api
      class Base
        include CasServer::Loggable
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
      
        attr_reader :request
        attr_reader :response
        attr_reader :service_manager
      
        delegate :params, :cookies, :to => :request
        delegate :set_cookie, :delete_cookie, :redirect?, :to => :response
      
        #array of errors store in env hash (so that they will be accessible to higher level, rails...)
        def errors
          @request.env['cas_server.errors'] ||= []
        end
        
        def success?
          errors.empty?
        end
        
        def error?
          !success?
        end
      
        #array of errors store in env hash (so that they will be accessible to higher level: rails...)
        def warnings
          @request.env['cas_server.warnings'] ||= []
        end
      
        def warning?
          !warnings.empty?
        end
        
        def service_url
          params['service']
        end
        
        def ticket_granting_cookie
          cookies['tgt']
        end

        def ticket_granting_ticket
          @tgt ||= CasServer::Entity::TicketGrantingCookie.from_cookie(ticket_granting_cookie)
        end
      
        def sso_enabled?
          ticket_granting_ticket
        end
      
        def exception_handler
          CasServer::Configuration.exception_handler
        end
      
        def initialize(options = {})
        end
      
        def call(env)
          #Parse the request
          @request = CasServer::Rack::Request.new(env)
          @response = Rack::Response.new
          @response.status = 404
          @response['Content-Type'] = 'text/plain'
        
          debug "Start processing of #{self.class.name} with params #{params.inspect}"
        
          #check against mandatory parameters
          validate_parameters!
          
          #Parse the service with configured service manager
          @service_manager = CasServer::Extension::ServiceManager.build(params['service'], self) 
          
          #Step 1: basic security, delegate access authorization to service manager
          service_manager.validate!
        
          #Step 2: specifics of the CAS action (check cookie, ...)
          process!
        
          #handle the response or delegate to higher level for rendering
          return @response.finish
        rescue CasServer::Error => error
          debug "Exception #{error.message} has been caught during #{self.class.name} execution"
          errors << error
          send exception_handler, error
        end
        
        def render_xml(content)
          @response['Content-Type'] = 'application/xml; charset=utf-8'
          @response.status = 200
          @response.write content
        end
        
        def redirect_to(uri, status_code = 302)
          @response.status = 302
          @response['Content-Type'] = 'text/plain'
          @response['Location'] = uri
        end
        
        def delegate_render?
          @response.not_found?
        end
        
        def process!
          raise NotImplementedError
        end
      
        protected
          def validate_parameters!
            self.class.demanded_parameters.each do |param| 
              raise MissingMandatoryParams.new(param) unless self.params.has_key?(param.to_s)
            end
          end
          
          def default_exception_handler(exception)
            #delegate (display login screen)
            @response.status = 404
            @response['Content-Type'] = 'text/plain'
            @response.body = []
            return @response.finish
          end
      end #Base
    end #Api
  end #Rack
end #CasServer 