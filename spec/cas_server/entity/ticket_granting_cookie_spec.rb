require File.dirname(__FILE__) + '/../../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/shared_ticket_spec')

describe CasServer::Entity::TicketGrantingCookie do
  before do
    @valid_args = [@authenticator_mock]
    @service_manager = mock(:service_manager, :check_authorization! => true, :service_url => 'http://service.com')
    @ticket = CasServer::Entity::TicketGrantingCookie.generate_for(*@valid_args)
  end
  
  it_should_behave_like "CAS ticket"
  
  describe 'Not in the specification' do
    it 'MUST maintain a list of Service Ticket this session has emited' do
      service_ticket = CasServer::Entity::ServiceTicket.generate_for(@ticket, @service_manager)
      @ticket.reload
      @ticket.service_tickets.first.should == service_ticket
    end
    
    it "MUST store extra_attributes if provided by authenticator" do
      @ticket.reload
      @ticket.extra_attributes.should == @authenticator_mock.extra_attributes
    end
    
    it 'should failed if no ticket granting cookie is related' do
      lambda do
        CasServer::Entity::ServiceTicket.create!(:username => 'username', :service => 'SERVICE')
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end
  
  describe "when cookie is set in client browser" do
    # 3.6.1.
    it "MUST be set to expire at the end of the client's browser session." do
      @ticket.to_cookie[:expires].should be_nil
    end
    
    # 3.6.1.
    it "MUST have it's cookie path to be as restrictive as possible." do
      @ticket.to_cookie[:path].should == '/cas'
    end
    
    # Not in spec
    it "MUST be a secure cookie if ssl is enabled" do
      CasServer::Configuration.ssl_enabled = true
      @ticket.to_cookie[:secure].should be_true
    end
    
    # Not in spec
    it "MUST NOT be a secure cookie if ssl is disabled" do
      CasServer::Configuration.ssl_enabled = false
      @ticket.to_cookie[:secure].should be_nil
    end
    
  end
  
  # 3.6.1.
  it "SHOULD begin with the characters, 'TGC-'." do
    @ticket.value.should match(/^TGC-/)
  end
end
