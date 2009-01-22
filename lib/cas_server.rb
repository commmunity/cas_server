module CasServer
  CAS_SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), "cas_server"))
  
  autoload :Configuration,          "#{CAS_SERVER_PATH}/configuration"
  autoload :Manager,                "#{CAS_SERVER_PATH}/manager"
  autoload :Response,               "#{CAS_SERVER_PATH}/response"
  autoload :I18n,                   "#{CAS_SERVER_PATH}/i18n"
  
  module Api
    autoload :Authenticator,        "#{CAS_SERVER_PATH}/api/authenticator"
    module Authenticator
      autoload :Base,               "#{CAS_SERVER_PATH}/api/authenticator/base"
    end
    autoload :DomainParser,         "#{CAS_SERVER_PATH}/api/domain_parser"
    module DomainParser
      autoload :Base,               "#{CAS_SERVER_PATH}/api/domain_parser/base"
    end
  end
  
  module Entity
    autoload :ServiceTicket,        "#{CAS_SERVER_PATH}/entity/service_ticket"
    autoload :LoginTicket,          "#{CAS_SERVER_PATH}/entity/login_ticket"
    autoload :TicketGrantingCookie, "#{CAS_SERVER_PATH}/entity/ticket_granting_cookie"
    autoload :Consumable,           "#{CAS_SERVER_PATH}/entity/consumable"
    autoload :Expirable,            "#{CAS_SERVER_PATH}/entity/expirable"
    autoload :TicketRandomization,  "#{CAS_SERVER_PATH}/entity/ticket_randomization"
  end
  
  autoload  :LoginCredentialRequestorManager, "#{CAS_SERVER_PATH}/login_credential_requestor_manager"
  autoload  :LoginCredentialAcceptorManager,  "#{CAS_SERVER_PATH}/login_credential_acceptor_manager"
  autoload  :ServiceValidateManager,          "#{CAS_SERVER_PATH}/service_validate_manager"
  autoload  :LogoutManager,                   "#{CAS_SERVER_PATH}/logout_manager"
end

require File.join(CasServer::CAS_SERVER_PATH, "error")

