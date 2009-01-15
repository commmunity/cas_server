require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CasServer::LoginCredentialRequestorManager do
  before(:each) do
    @params = {}
    @cookies = {}
    @service_url = 'http://service.com'
  end

  it "should accept any given params" do
    @params[:unknown] = 'Unknown param'
    
    lambda {
      CasServer::LoginCredentialRequestorManager.new(@params, @cookies)
    }.should_not raise_error
  end
  
  it "must not demand any params" do
    @params = {}
    
    lambda {
      CasServer::LoginCredentialRequestorManager.new(@params, @cookies)
    }.should_not raise_error
  end
  
  describe "when service is set" do
    before do
      @params[:service] = @service_url
    end
    
    #2.1
    it "may issue a service ticket if an valid ticket granting ticket cookie is available" do
      lambda {
        mock_sso_enabled!
        process_response!
      }.should change(CasServer::Entity::ServiceTicket, :count)
    end
    
    #2. ? missing in CAS spec
    it "must redirect to service url if sso is enabled and add service ticket to it" do
      mock_sso_enabled!
      response = process_response!
      response.redirect_to.should == "#{@service_url}?ticket=#{CasServer::Entity::ServiceTicket.last.value}"
    end
  end
  
  #2.1.1
  it "should request a credentials if a service is not specified and a single sign-on session does not yet exist" do
    @params = {}
    response = process_response
    response.should be_render_template
    response.template_to_render.should == :credential_requestor
  end
  
  #2.1.1
  it "should notify user if a sso session exist and no service is specified"
  
  describe "when renew parameter is set" do
    before do
      @params = {:renew => true, :service => @service_url}
    end
    
    #2.1.1
    it "must bypass sso and request credentials" do
      mock_sso_enabled!
      response = process_response
      response.should be_render_template
    end

    #2.1.1
    it "should ignore gateway params" do
      @params = {:renew => true, :gateway => true}
      response = process_response
      response.should_not be_redirect
    end
  end
  
  describe "when gateway parameter is set" do
    before do
      @params = {:gateway => true, :service => @service_url}
      @cookies = {}
    end
    
    #2.1.1
    it "must not ask for credentials" do
      response = process_response
      response.should be_redirect
      response.should_not be_render_template
    end
  
    #2.1.1
    it "should redirect to service with a service ticket if sso is set" do
      mock_sso_enabled!
      response = process_response
      response.redirect_to.should == "#{@service_url}?ticket=#{CasServer::Entity::ServiceTicket.last.value}"
    end
  
    #2.1.1
    it "should redirect to service with a service ticket if non interactive session can be established"
    
    #2.1.1
    it "must redirect to service if no sso is set and no non interactive session can be established" do
      response = process_response
      response.redirect_to.should == @service_url
    end
    
    #2.1.1
    it "should return not work if no service params is provided" do
      @params.delete(:service)
      lambda {
        process_response!
      }.should raise_error(CasServer::InvalidRequest)
    end
  end
  
  it "must support 2.1.3"
  
  it "will not support trust identification specified in 2.1.4"
  
  def mock_sso_enabled!
 CasServer::Entity::TicketGrantingCookie.stub!(:from_cookie).and_return(CasServer::Entity::TicketGrantingCookie.generate_for(:username => 'username'))
  end
  
  def process_response
    CasServer::LoginCredentialRequestorManager.new(@params, @cookies).process  
  end
  
  def process_response!
    @manager = CasServer::LoginCredentialRequestorManager.new(@params, @cookies)
    @manager.process!
    return @manager.response
  end
end
