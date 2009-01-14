# This is a dummy authenticator that always agree with authentication
class CasServer::Api::Authenticator::Mock < CasServer::Api::Authenticator::Base
  def self.authenticate(username, password)
    true
  end
end