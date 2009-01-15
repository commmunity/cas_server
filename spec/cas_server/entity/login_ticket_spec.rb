require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/shared_ticket_spec')

describe CasServer::Entity::LoginTicket do
  before do
    @valid_args = []
    @ticket = CasServer::Entity::LoginTicket.generate_for(*@valid_args)
  end
  
  it_should_behave_like "CAS ticket"
  
  # 3.5.1
  it "MUST only be valid for one authentication attempt" do
    CasServer::Entity::LoginTicket.validate_ticket!(@ticket.value)
    lambda do
      CasServer::Entity::LoginTicket.validate_ticket!(@ticket.value)
    end.should raise_error(CasServer::ConsumedTicket)
  end
  
  describe "when consumed" do
    # 3.5.1
    it "must be invalidated" do
      @ticket.should_not be_consumed
      @ticket.consume!
      @ticket.reload.should be_consumed
    end
  end
  
  # 3.5.1
  it "SHOULD begin with the characters, 'LT-'." do
    @ticket.value.should match(/LT-/)
  end
end
