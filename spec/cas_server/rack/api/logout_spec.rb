require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Rack::Api::Logout do
  before do
    @env = Rack::MockRequest.env_for("http://example.com:8080/")
    @params = {}
    @tgt = CasServer::Entity::TicketGrantingCookie.generate_for(@authenticator_mock)
    @cookies = {'tgt' => @tgt.value}
    @rack = CasServer::Rack::Api::Logout.new
    @rack.stub!(:cookies).and_return(@cookies)
    @rack.stub!(:params).and_return(@params)
  end
  
  describe "Not in Cas protocol" do
    it "Should not validate the ServiceManager as service is not expected" do
      @sm = mock('service_manager')
      CasServer::Extension::ServiceManager.stub!(:build).and_return(@sm)
      @sm.should_not_receive(:validate!)
      @rack.call(@env)
    end
    
    describe "When destination params is provided" do
      it "should redirect to destination if it is a proper url" do
        @params['destination'] = 'http://example.com'
        @rack.call(@env)
        @rack.should be_redirect
        @rack.response['Location'].should match(/example.com/)
      end
      
      it "should not do anything if destination is not a proper url" do
        @params['destination'] = "javascript:alert('toto')"
        @rack.should be_delegate_render
      end
    end
  end
  
  #2.3
  it "destroys a client's single sign-on CAS session" do
    lambda do
      @rack.call(@env)
    end.should change(CasServer::Entity::TicketGrantingCookie, :count)
  end
  
  #2.3
  it "destroys The ticket-granting cookie" do
    @rack.should_receive(:delete_cookie).with('tgt')
    @rack.call(@env)
  end
  
  describe "if url params is specified" do
    # 2.3.1
    it "SHOULD show the url link on the logout page with descriptive text" do
      @params['url'] = 'http://logout.com'
      @rack.call(@env)
      @rack.warnings.first.should == 'cas_server.warning.logout_with_url'
      @rack.should be_delegate_render
    end
  end
  
  # 2.3.2
  it "MUST display a page stating that the user has been logged out" do
    @rack.call(@env)
    @rack.warnings.first.should == 'cas_server.warning.logout'
    @rack.should be_delegate_render
  end
end