require 'rubygems'
require 'rack'
require 'rack/request'
require 'rack/response'

module CasServer
  CAS_SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), "cas_server"))
  
  module Rack
    autoload :Request,              "#{CAS_SERVER_PATH}/rack/request"
    autoload :Response,             "#{CAS_SERVER_PATH}/rack/response"
    module Api
      autoload :Base,               "#{CAS_SERVER_PATH}/rack/api/base"
    end
    autoload :Router,               "#{CAS_SERVER_PATH}/rack/router"
  end
    
  autoload :Configuration,          "#{CAS_SERVER_PATH}/configuration"
  autoload :Manager,                "#{CAS_SERVER_PATH}/manager"
  autoload :Response,               "#{CAS_SERVER_PATH}/response"
  autoload :I18n,                   "#{CAS_SERVER_PATH}/i18n"
  
  module Extension
    autoload :Authenticator,        "#{CAS_SERVER_PATH}/extension/authenticator"
    module Authenticator
      autoload :Base,               "#{CAS_SERVER_PATH}/extension/authenticator/base"
    end
    autoload :ServiceManager,       "#{CAS_SERVER_PATH}/extension/service_manager"
    module ServiceManager
      autoload :Base,               "#{CAS_SERVER_PATH}/extension/service_manager/base"
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

