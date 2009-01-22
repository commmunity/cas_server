# This is a dummy that always is valid
class CasServer::Api::DomainParser::Mock < CasServer::Api::DomainParser::Base
  def valid?
    true
  end
end