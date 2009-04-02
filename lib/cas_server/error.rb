# Exception to be generated by the Cas Server. This is supposed to have built-in I18n and provide an easy way to
# customize error/warning messages
module CasServer
  # Generic CasServer Error exception, parent of all Cas specific Exception
  class Error < ::StandardError
    include CasServer::I18n
    
    # to be used in xml response as an error identifier
    def error_identifier
      i18n_identifier.upcase
    end
    
    def initialize(msg = nil)
      super(msg || "cas_server.error.#{i18n_identifier}")
    end
  end

  # Mandatory params not in the request
  class MissingMandatoryParams < Error
    attr_reader :param
    def error_identifier
      'INVALID_REQUEST'
    end
    def initialize(param, msg = nil)
      @param = param
      super(msg)
    end
  end

  # Invalid combination of params
  class InvalidRequest < Error
  end
  
  # Configuration issue with selected authenticator
  class InvalidAuthenticator < Error
    attr_reader :authenticator
    def initialize(authenticator, msg= nil)
      @authenticator = authenticator
      super(msg)
    end
  end
  
  # Configuration issue with selected domain parser
  class InvalidServiceManager < Error
    attr_reader :service_manager
    def initialize(service_manager, msg = nil)
      @service_manager = service_manager
      super(msg || "Invalid domain parser: #{service_manager.inspect}")
    end
  end
  
  # Failed authentication attempt
  class AuthenticationFailed < Error
  end
  
  # Authorization required in service manager
  class AuthorizationRequired < Error
  end
  
  # No ticket with that value found
  class InvalidTicket < Error
    attr_reader :ticket
    
    def initialize(ticket, msg = nil)
      @ticket = ticket
      super(msg || "cas_server.error.ticket.#{@ticket.i18n_identifier}.#{i18n_identifier}")
    end
  end
  
  class InvalidServiceURL < Error
    attr_reader :url
    
    def initialize(url, msg = nil)
      @url = url
      super(msg || "cas_server.error.service_url.#{i18n_identifier}")
    end
  end
  
  # Service Ticket found but does not correspond to the service
  class InvalidService < InvalidTicket
  end
  
  # Ticket found but expired
  class ExpiredTicket < InvalidTicket
  end
  
  # Ticket found but already consumed
  class ConsumedTicket < InvalidTicket
  end
end