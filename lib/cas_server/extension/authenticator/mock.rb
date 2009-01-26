# This is a dummy authenticator that always agree with authentication
class CasServer::Extension::Authenticator::Mock < CasServer::Extension::Authenticator::Base
  def self.authenticate(username, password)
    true
  end
end