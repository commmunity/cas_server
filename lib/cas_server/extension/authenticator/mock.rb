# This is a dummy authenticator that always agree with authentication
class CasServer::Extension::Authenticator::Mock < CasServer::Extension::Authenticator::Base  
  def username
    params['username']
  end
  
  def password
    params['password']
  end
  
  def authenticate?
    true
  end
  
  def uuid
    "#{username}"
  end
  
  def extra_attributes
    {:uuid => "#{username}", :firstname => "#{username} firstname", :email => "#{username}@mock.com", :lastname => "#{username} lastname"}
  end
end