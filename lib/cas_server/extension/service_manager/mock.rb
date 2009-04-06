# This is a dummy that always is valid
class CasServer::Extension::ServiceManager::Mock < CasServer::Extension::ServiceManager::Base
  def authorized?(username)
    true
  end
  
  def default_authenticator
    :mock
  end
  
  def valid_service?
    true
  end
end