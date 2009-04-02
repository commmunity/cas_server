# This is a dummy that always is valid
class CasServer::Extension::ServiceManager::Mock < CasServer::Extension::ServiceManager::Base
  def authorized?(username)
    true
  end
  
  def valid_service?
    true
  end
end