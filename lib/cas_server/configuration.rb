module CasServer
  module Configuration
    mattr_accessor :ticket_expiration
    @@ticket_expiration = 3.minutes
    
    mattr_accessor :authenticator
    @@authenticator = :mock
    
    mattr_accessor :domain_parser
    @@domain_parser = :mock
    
    mattr_accessor :ssl_enabled
    @@ssl_enabled = false
  end
end