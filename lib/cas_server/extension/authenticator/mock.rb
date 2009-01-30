# This is a dummy authenticator that always agree with authentication
class CasServer::Extension::Authenticator::Mock < CasServer::Extension::Authenticator::Base
  def initialize(username, password)
    @username = username
  end
  
  def authenticate?
    true
  end
  
  def uuid
    "#{@username}"
  end
  
  def extra_attributes
    {:uuid => "#{@username}", :firstname => "#{@username} firstname", :email => "#{@username}@mock.com", :lastname => "#{@username} lastname"}
  end
end