module CasServer
  module Configuration
    mattr_accessor :ticket_expiration
    @@ticket_expiration = 3.minutes
    
    mattr_accessor :authenticator
    @@authenticator = :mock
    
    mattr_accessor :service_manager
    @@service_manager = :mock
    
    mattr_accessor :ssl_enabled
    @@ssl_enabled = false
  end
end