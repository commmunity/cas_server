require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_ticket_spec')

describe CasServer::Entity::ServiceTicket do
  before do
    @ticket_granting_ticket = CasServer::Entity::TicketGrantingCookie.generate_for('username')
    @valid_args = [@ticket_granting_ticket, 'SERVICE']
    @ticket = CasServer::Entity::ServiceTicket.generate_for(*@valid_args)
  end
  
  it_should_behave_like "CAS ticket"
  
  describe 'Not in the specification' do
    it 'MUST maintain a relation with the ticket granting cookie that created him' do
      @ticket.ticket_granting_cookie.should == @ticket_granting_ticket
    end
    
    it 'should failed if no ticket granting cookie is related' do
      lambda do
        CasServer::Entity::ServiceTicket.create!(:username => 'username', :service => 'SERVICE')
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  #3.1.1
  it "MUST only be valid for a given service" do
    lambda do
      CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value,'SERVICE2')
    end.should raise_error(CasServer::InvalidService)
  end
  
  #3.1.1
  it "SHOULD NOT use service identifier in the service ticket" do
    @ticket.value.should_not match(/SERVICE/)
  end
  
  #3.1.1
  it "MUST only be valid for one ticket validation attempt" do
    CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value,@ticket.service)
    lambda do
      CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value,@ticket.service)
    end.should raise_error(CasServer::ConsumedTicket)
  end
  
  #3.1.1
  it "SHOULD expire unvalidated service tickets in a reasonable period of time after 
  they are issued" do
    CasServer::Configuration.ticket_expiration.should > 10.seconds
  end
  
  #3.1.1
  it "is RECOMMANDED the expiration period should be no longer than 5 minutes" do
    CasServer::Configuration.ticket_expiration.should < 5.minutes
  end
  
  describe "in case of expired ticket" do
    #3.1.1
    it "MUST respond with a validation failure response" do
      @ticket.update_attribute :created_at, 20.minutes.ago
      lambda do
        CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value,@ticket.service)
      end.should raise_error(CasServer::ExpiredTicket)
    end
  
    #3.1.1
    it "is RECOMMANDED include a descriptive message explaining why validation failed" do
      CasServer::ExpiredTicket.new(@ticket).message.should == 'cas_server.error.ticket.service_ticket.expired_ticket'
    end
  end
  
  #3.1.1
  it "MUST begin with the characters, 'ST-'" do
    @ticket.value.should match(/^ST-/)
  end
  
  # 2.2.4
  describe "Adding ticket params to service url" do
    
    it "must work with empty query string" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com', :value => '1').service_url_with_service_ticket.should == 'http://service.com?ticket=1'
    end
    
    it "must work with empty params" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?toto=', :value => '2').service_url_with_service_ticket.should == 'http://service.com?ticket=2&toto='
    end
    
    it "must work with params" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?toto=1', :value => '2').service_url_with_service_ticket.should == 'http://service.com?ticket=2&toto=1'
    end
    
    it "must work with existing ticket" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?ticket=1&toto=2', :value => '2').service_url_with_service_ticket.should == 'http://service.com?ticket=2&toto=2'
    end
  end
end
