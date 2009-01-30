require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Rack::Api::CredentialRequestor do
  before(:each) do
    @service_url = 'http://toto.com'
    @params = {'service' => @service_url}
    @cookies = {}
    @env = Rack::MockRequest.env_for("http://example.com:8080/")
    @rack = CasServer::Rack::Api::CredentialRequestor.new
    @rack.stub!(:cookies).and_return(@cookies)
    @rack.stub!(:params).and_return(@params)
  end

  it "should accept any given params" do
    @params['unknown'] = 'Unknown param'
    lambda {
      @rack.call(@env)
    }.should_not raise_error
  end
  
  it "must not demand any params" do
    lambda {
      @rack.call(@env)
    }.should_not raise_error
  end
  
  describe "when service is set" do
    before do
      @params['service'] = @service_url
    end
    
    #2.1
    it "may issue a service ticket if an valid ticket granting ticket cookie is available" do
      lambda {
        mock_sso_enabled!
        @rack.call(@env)
      }.should change(CasServer::Entity::ServiceTicket, :count)
    end
    
    #2. ? missing in CAS spec
    it "must redirect to service url if sso is enabled and add service ticket to it" do
      mock_sso_enabled!
      @rack.call(@env)
      @rack.should be_redirect
      @rack.response
      @rack.response['Location'].should == "#{@service_url}?ticket=#{CasServer::Entity::ServiceTicket.last.value}" 
    end
  end
  
  #2.1.1
  it "should request a credentials if a service is not specified and a single sign-on session does not yet exist" do
    @params = {}
    @rack.call(@env)
    @rack.should be_delegate_render
  end
  
  #2.1.1
  it "should notify user if a sso session exist and no service is specified"
  
  describe "when renew parameter is set" do
    before do
      @params.merge!('renew' => 1)
    end
    
    #2.1.1
    it "must bypass sso and request credentials" do
      mock_sso_enabled!
      @rack.call(@env)
      @rack.should be_delegate_render
    end

    #2.1.1
    it "should ignore gateway params" do
      @params.merge!({'renew' => 1, 'gateway' => 1})
      @rack.call(@env)
      @rack.should_not be_redirect
      @rack.should be_delegate_render
    end
  end
  
  describe "when gateway parameter is set" do
    before do
      @params.merge!('gateway' => '1')
      @cookies = {}
    end
    
    #2.1.1
    it "must not ask for credentials" do
      @rack.call(@env)
      @rack.should be_redirect
    end
  
    #2.1.1
    it "should redirect to service with a service ticket if sso is set" do
      mock_sso_enabled!
      @rack.call(@env)
      @rack.response['Location'].should == "#{@service_url}?ticket=#{CasServer::Entity::ServiceTicket.last.value}"
    end
  
    #2.1.1
    it "should redirect to service with a service ticket if non interactive session can be established"
    
    #2.1.1
    it "must redirect to service if no sso is set and no non interactive session can be established" do
      @rack.call(@env)
      @rack.response['Location'].should == @service_url
    end
    
    #2.1.1
    it "should return not work if no service params is provided" do
      @params.delete('service')
      @rack.call(@env)
      @rack.should be_error
      #Currently the test is biaised because the missing service param is catch by the ServiceManager
      #@rack.errors.first.class.should == CasServer::InvalidRequest
    end
  end
  
  it "must support 2.1.3"
  
  it "will not support trust identification specified in 2.1.4"
  
  def mock_sso_enabled!
 CasServer::Entity::TicketGrantingCookie.stub!(:from_cookie).and_return(CasServer::Entity::TicketGrantingCookie.generate_for(@authenticator_mock))
  end
end