require File.dirname(__FILE__) + '/../../spec_helper'
require File.expand_path(File.dirname(__FILE__) + '/shared_ticket_spec')

describe CasServer::Entity::TicketGrantingCookie do
  before do
    @valid_args = ['username']
    @ticket = CasServer::Entity::TicketGrantingCookie.generate_for(*@valid_args)
  end
  
  it_should_behave_like "CAS ticket"
  
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
