require File.dirname(__FILE__) + '/../spec_helper'

describe CasServer::LoginCredentialAcceptorManager do
  before(:each) do
    @params = {:username => 'username', :password => 'password', :lt => 'lt-loginticket' }
    @cookies = {}
    @service_url = 'http://service.com'
    @manager = CasServer::LoginCredentialAcceptorManager.new(@params, @cookies)
  end
  
  describe "while acting as a credential acceptor for username/password authentication" do
    [:username, :password, :lt].each do |mandatory_param|
      # 2.2.2.
      it "MUST have #{mandatory_param} parameter" do
        @params.delete(mandatory_param)
        @manager.process
        @manager.should be_error
        @manager.errors.first.class.should == CasServer::MissingMandatoryParams
      end
    end
    
    # 2.2.1.
    it "SHOULD accept any other params" do
      @params[:unknown] = 'Unknown param'
      @manager.should be_success
    end
    
    # 3.5.1
    it "MUST validates against the login ticket" do
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      @manager.process
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
      CasServer::Extension::Authenticator.should_receive(:authenticate).and_return(true)
    end
       
    # 2.2.4
    it "MUST redirect the client to the URL specified by the service parameter with a GET request" do
      @response = @manager.process
      @response.should be_redirect
      @response.redirect_to.should match(/#{@service_url}/)
    end
    
    # 2.2.4
    it "MUST add a valid service ticket to the service URL as a 'ticket' param" do
      @response = @manager.process
      @response.redirect_to.should match(/^#{@service_url}\?ticket=ST\-(\w)*$/)
    end
    
    describe "if service is not specified" do
      # 2.2.4
      it "MUST display a message notifying the client that it has successfully initiated a single sign-on session"
    end
    
    # not specified in 2.2.4 ?
    it "MUST initiate a single sign-on session" do
      tgt = CasServer::Entity::TicketGrantingCookie.generate_for('username')
      tgt.should_receive(:to_cookie).and_return('tgt-toto')
      CasServer::Entity::TicketGrantingCookie.should_receive(:generate_for).and_return(tgt)
      @manager.response.should_receive(:set_cookie).with(:tgt, 'tgt-toto')
      @manager.process
    end
  end
  
  describe "in case of failed login" do
    before do
      @params[:service] = @service_url
      CasServer::Entity::LoginTicket.should_receive(:validate_ticket!)
      CasServer::Extension::Authenticator.should_receive(:authenticate).and_return(false)
      @response = @manager.process
    end
    
    # 2.2.4
    it "return to /login as a credential requestor" do
      @response.should_not be_redirect
      @response.should be_render_template
    end
    
    # 2.2.4
    it "It is RECOMMENDED that the CAS server display an error message be displayed to the user describing why login failed" do
      @response.errors.should_not be_empty
      @response.should be_render_template
    end
  end
end
