require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Rack::Api::CredentialAcceptor do
  before(:each) do
    @service_url = 'http://toto.com'
    @params = {'username' => 'username', 'password' => 'password', 'lt' => 'lt-loginticket', 'service' => @service_url }
    @cookies = {}
    @env = Rack::MockRequest.env_for("http://example.com:8080/")
    @rack = CasServer::Rack::Api::CredentialAcceptor.new
    @rack.stub!(:cookies).and_return(@cookies)
    @rack.stub!(:params).and_return(@params)
  end
  
  describe "while acting as a credential acceptor for username/password authentication" do
    [:username, :password, :lt].each do |mandatory_param|
      # 2.2.2.
      it "MUST have #{mandatory_param} parameter" do
        @params.delete(mandatory_param.to_s)
        @rack.call(@env)
        @rack.should be_error
        @rack.errors.first.class.should == CasServer::MissingMandatoryParams
      end
    end
    
    # 2.2.1.
    it "SHOULD accept any other params" do
      @params['unknown'] = 'Unknown param'
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      @rack.call(@env)
      @rack.should be_success
    end
    
    # 3.5.1
    it "MUST validates against the login ticket" do
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      @rack.call(@env)
    end
  end
  
  describe "when warn parameter is set" do
    # 2.2.1
    it "MUST prompt client before being authenticated to another service"
  end
  
  describe "trust authentication" do
    # 2.2.3
    it "should not require any params (username/password/lt)"
  end
  
  describe "in case of successful login" do
    before do
      @params[:service] = @service_url
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      @authenticator_mock.should_receive(:authenticate?).and_return(true)
      CasServer::Extension::Authenticator.should_receive(:build).and_return(@authenticator_mock)
    end
       
    # 2.2.4
    it "MUST redirect the client to the URL specified by the service parameter with a GET request" do
      @rack.call(@env)
      @rack.should be_redirect
      @rack.response['Location'].should match(/#{@service_url}/)
    end
    
    # 2.2.4
    it "MUST add a valid service ticket to the service URL as a 'ticket' param" do
      @rack.call(@env)
      @rack.should be_redirect
      @rack.response['Location'].should match(/^#{@service_url}\?ticket=ST\-(\w)*$/)
    end
    
    describe "if service is not specified" do
      # 2.2.4
      it "MUST display a message notifying the client that it has successfully initiated a single sign-on session"
    end
    
    # not specified in 2.2.4 ?
    it "MUST initiate a single sign-on session" do
      tgt = CasServer::Entity::TicketGrantingCookie.generate_for(@authenticator_mock)
      tgt.should_receive(:to_cookie).and_return('tgt-toto')
      CasServer::Entity::TicketGrantingCookie.should_receive(:generate_for).and_return(tgt)
      @rack.should_receive(:set_cookie).with(:tgt, 'tgt-toto')
      @rack.call(@env)
    end
  end
  
  describe "in case of failed login" do
    before do
      @params[:service] = @service_url
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      @authenticator_mock.should_receive(:authenticate?).and_return(false)
      CasServer::Extension::Authenticator.should_receive(:build).and_return(@authenticator_mock)
      @rack.call(@env)
    end
    
    # 2.2.4
    it "return to /login as a credential requestor" do
      @rack.should be_delegate_render
    end
    
    # 2.2.4
    it "It is RECOMMENDED that the CAS server display an error message be displayed to the user describing why login failed" do
      @rack.errors.should_not be_empty
    end
  end
end