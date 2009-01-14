require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Error do
  it "should i18ned message for Error" do
    CasServer::MissingMandatoryParams.new(:service).message.should == 'cas_server.error.missing_mandatory_params'
  end
  
  it "should i18ned message for InvalidTicket" do
    CasServer::ExpiredTicket.new(CasServer::Entity::LoginTicket.new).message.should == 'cas_server.error.ticket.login_ticket.expired_ticket'
  end
end
