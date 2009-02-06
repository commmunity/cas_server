require 'uri'
begin
  require 'rack'
rescue LoadError
  require 'rubygems'
  require 'rack'
end unless defined?(Rack)

begin
  require 'active_support'
rescue LoadError
  require 'rubygems'
  require 'active_support'
end unless defined?(ActiveSupport)

begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end unless defined?(ActiveRecord)

module CasServer
  CAS_SERVER_PATH = File.expand_path(File.join(File.dirname(__FILE__), "cas_server"))
  
  module Utils
    autoload :MandatoryParameters,  "#{CAS_SERVER_PATH}/utils/mandatory_parameters"
  end
  
  module Rack
    autoload :Request,              "#{CAS_SERVER_PATH}/rack/request"
    autoload :Response,             "#{CAS_SERVER_PATH}/rack/response"
    module Api
      autoload :Base,               "#{CAS_SERVER_PATH}/rack/api/base"
      autoload :Logout,             "#{CAS_SERVER_PATH}/rack/api/logout"
      autoload :ServiceValidate,    "#{CAS_SERVER_PATH}/rack/api/service_validate"
      autoload :CredentialAcceptor, "#{CAS_SERVER_PATH}/rack/api/credential_acceptor"
      autoload :CredentialRequestor,"#{CAS_SERVER_PATH}/rack/api/credential_requestor"
    end
    autoload :Router,               "#{CAS_SERVER_PATH}/rack/router"
    autoload :RouteCriteria,        "#{CAS_SERVER_PATH}/rack/route_criteria"
    autoload :Profiler,             "#{CAS_SERVER_PATH}/rack/profiler"
    autoload :ActiveRecord,         "#{CAS_SERVER_PATH}/rack/active_record"
  end
    
  autoload :Configuration,          "#{CAS_SERVER_PATH}/configuration"
  autoload :Manager,                "#{CAS_SERVER_PATH}/manager"
  autoload :Response,               "#{CAS_SERVER_PATH}/response"
  autoload :I18n,                   "#{CAS_SERVER_PATH}/i18n"
  autoload :MockLogger,             "#{CAS_SERVER_PATH}/logger"
  
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
end

require File.join(CasServer::CAS_SERVER_PATH, "error")
require File.join(CasServer::CAS_SERVER_PATH, "logger")

Dir.glob(File.join(CasServer::CAS_SERVER_PATH,'extension/authenticator', '*')).each do |f|
  require f
end

Dir.glob(File.join(CasServer::CAS_SERVER_PATH,'extension/service_manager', '*')).each do |f|
  require f
end