module CasServer
  module Configuration
    mattr_accessor :ticket_expiration
    @@ticket_expiration = 3.minutes
    
    mattr_accessor :authenticator
    @@authenticator = :mock
  end
end