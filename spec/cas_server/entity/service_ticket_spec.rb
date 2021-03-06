require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_ticket_spec')

describe CasServer::Entity::ServiceTicket do
  before do
    @ticket_granting_ticket = CasServer::Entity::TicketGrantingCookie.generate_for(@authenticator_mock)
    @service_manager = mock(:service_manager, :check_authorization! => true, :service_url => 'http://service.com')
    @valid_args = [@ticket_granting_ticket, @service_manager]
    @ticket = CasServer::Entity::ServiceTicket.generate_for(*@valid_args)
  end
  
  it_should_behave_like "CAS ticket"
  
  describe 'Not in the specification' do
    it 'MUST maintain a relation with the ticket granting cookie that created him' do
      @ticket.ticket_granting_cookie.should == @ticket_granting_ticket
    end
    
    it "may access extra_attributes available in ticket_granting_ticket" do
      @service_manager.should_receive(:extra_attributes_for).and_return({})
      @ticket_granting_ticket.reload
      st = @ticket_granting_ticket.service_tickets.create!(:username => 'username', :service => 'http://service.com')
      st.extra_attributes(@service_manager).should == @authenticator_mock.extra_attributes
    end
    
    it 'merges service manager extra attributes' do
      @service_manager.should_receive(:extra_attributes_for).twice.and_return({:bar, 'foo'})
      @ticket_granting_ticket.reload
      st = @ticket_granting_ticket.service_tickets.create!(:username => 'username', :service => 'http://service.com')
      st.extra_attributes(@service_manager).should include(@authenticator_mock.extra_attributes)
      st.extra_attributes(@service_manager).should include(:bar => 'foo')
    end
    
    it 'should failed if no ticket granting cookie is related' do
      lambda do
        CasServer::Entity::ServiceTicket.create!(:username => 'username', :service => 'http://service.com')
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
    
    it 'check authorization on service manager with ticket granting ticket username' do
      @service_manager.should_receive(:check_authorization!).with(@ticket_granting_ticket.username)
      CasServer::Entity::ServiceTicket.generate_for(*@valid_args)
    end
    
    it 'is valid if service url is https against http' do
      @service_manager.should_receive(:service_url).and_return('https://service.com')
      lambda do
        CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
      end.should_not raise_error(CasServer::InvalidService)
    end
    
    it 'is not valid if service url scheme is different' do
      @service_manager.should_receive(:service_url).and_return('ftp://service.com')
      lambda do
        CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
      end.should raise_error(CasServer::InvalidService)
    end
  end
  
  #3.1.1
  it "MUST only be valid for a given service" do
    @service_manager.should_receive(:service_url).and_return('http://service.com2')
    lambda do
      CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
    end.should raise_error(CasServer::InvalidService)
  end
  
  #3.1.1
  it "SHOULD NOT use service identifier in the service ticket" do
    @ticket.value.should_not match(/http:\/\/service.com/)
  end
  
  #3.1.1
  it "MUST only be valid for one ticket validation attempt" do
    @service_manager.should_receive(:service_url).twice.and_return(@ticket.service)
    CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
    lambda do
      CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
    end.should raise_error(CasServer::ConsumedTicket)
  end
  
  #3.1.1
  it "SHOULD expire unvalidated service tickets in a reasonable period of time after they are issued" do
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
        CasServer::Entity::ServiceTicket.validate_ticket!(@ticket.value, @service_manager)
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
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?toto=', :value => '2').service_url_with_service_ticket.should == 'http://service.com?toto=&ticket=2'
    end
    
    it "must work with params" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?toto=1', :value => '2').service_url_with_service_ticket.should == 'http://service.com?toto=1&ticket=2'
    end
    
    it "must work with existing ticket" do
      CasServer::Entity::ServiceTicket.new(:service => 'http://service.com?ticket=1&toto=2', :value => '2').service_url_with_service_ticket.should == 'http://service.com?toto=2&ticket=2'
    end
  end
end
