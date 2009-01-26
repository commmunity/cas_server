# This is a dummy that always is valid
class CasServer::Extension::ServiceManager::Mock < CasServer::Extension::ServiceManager::Base
  def valid?
    true
  end
end