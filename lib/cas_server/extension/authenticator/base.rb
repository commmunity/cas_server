# Authenticators are implementation class that will enable or disable authentication given a specific
# authentication logic
#
# Exceptions:
# Any overiddable method can raise exceptions, those exceptions must inherit from CasServer::Error and will
# be catch to display an error message explaining the reason for this failure
# Exceptions have to be used when unexpection parameters or situation occured as they will lead to error
# message for end-user.
# See CasServer::Error for more details about I18n and structure of exception
# 
# Authentication:
#
# Basic use of an authenticator is to overidde the authenticate? method
# This method should return true or false depending of the success or failure of the authentication
# 
# Callbacks:
#
# There are severals callback that can be used to fit the authenticator to your needs.
# All the callbacks work the same way, they are supposed to return true or the response
# 
# true means that the current process flow go on as usual
#
# Otherwise it means that you take control over the current process flow, to redirect the user in most case but you
# have access to the current Rack::Response and can modify it as you wish or can generate your own or even 
# delegate it to a Rack app. Any 404 response will be forwarded to the upstream server, if you want to pass it 
# information use the env.
# Make sure that you've returned propred Rack response otherwise the Rack::Response will # be a 404 and forwarded
# to the upstream server (Rails for instance)
#
# Some helpers are available to make it easier: redirect_to url will return a redirect response e.g.
#
# Callbacks supported:
# * before_credential_requestor (executed if login screen is supposed to be displayed, i.e no sso nor gateway mode)
module CasServer
  module Extension
    module Authenticator
      class Base
        include CasServer::Loggable
        include CasServer::Utils::MandatoryParameters
        
        class << self
          # available authenticator implementation
          def implementations
            @@implementations ||= []
          end
        
          def inherited(subklass)
            implementations << subklass
            super
          end
        
          def model
            @model ||= self.name.demodulize.underscore.to_sym
          end
        end # << self
        
        attr_reader :rack_api
        
        def initialize(rack_api)
          @rack_api = rack_api
        end
        
        def authenticate!
          validate_parameters!
          authenticate? || raise(AuthenticationFailed)
        end
        
        #should be a boolean
        def authenticate?
          raise NotImplementedError.new("#{self.class.name}#authenticate?")
        end
        
        def uuid
          raise NotImplementedError.new("#{self.class.name}#uuid")
        end
        
        #should be a hash
        def extra_attributes
          raise NotImplementedError.new("#{self.class.name}#extra_attributes")
        end
        
        def has_callback?(callback)
          respond_to?(callback.to_sym)
        end
        
      protected
        delegate :redirect_to, :base_url, :params, :cookies, :service_manager, :to => :rack_api  
      end #Base
    end #Authenticator
  end #Extension
end #CasServer