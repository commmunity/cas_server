#this is the authenticator you can extend if you want to do a pure Cas Protocol authenticator
class CasServer::Extension::Authenticator::Cas < CasServer::Extension::Authenticator::Base
  demand :username, :password, :lt
  
  def username
    params['username']
  end
  
  def password
    params['password']
  end
  
  def lt
    params['lt']
  end
  
  def authenticate?
    #validate against LoginTicket
    CasServer::Entity::LoginTicket.validate_ticket!(lt)   
    password == 'password'
  end
  
  def uuid
    "#{username}"
  end
  
  def extra_attributes
    {:uuid => "#{username}", :firstname => "#{username} firstname", :email => "#{username}@mock.com", :lastname => "#{username} lastname"}
  end
end