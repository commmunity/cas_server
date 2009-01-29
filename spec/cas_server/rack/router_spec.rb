require File.dirname(__FILE__) + '/../../spec_helper'
# Not directly linked to CasProtocol also add our own logic
describe CasServer::Rack::Router do
  before do
    @router = CasServer::Rack::Router.new
    @mock_request = Rack::MockRequest.new(@router)
    @mock_app = lambda {|env| [200, {}]}
  end
  
  it "MUST launch CredentialRequestor on GET /cas/login" do
    @router.should_receive(:run).with(CasServer::Rack::Api::CredentialRequestor)
    get '/cas/login'
  end
  
  it "MUST launch CredentialAcceptor on POST /cas/login" do
    @router.should_receive(:run).with(CasServer::Rack::Api::CredentialAcceptor)
    post '/cas/login'
  end
  
  it "MUST launch ServiceValidate on GET/POST /cas/serviceValidate" do
    @router.should_receive(:run).with(CasServer::Rack::Api::ServiceValidate).twice
    get '/cas/serviceValidate'
    post '/cas/serviceValidate'
  end
  
  it "MUST launch Logout on GET/POST /cas/logout" do
    @router.should_receive(:run).with(CasServer::Rack::Api::Logout).twice
    get '/cas/logout'
    post '/cas/logout'
  end
  
  it "MUST return a 404 immediatly when not /cas" do
    CasServer::Rack::Request.should_not_receive :new
    get('/toto/logout').status.should == 404
    get('/truc').status.should == 404
  end
  
  it "MUST return a 404 immediatly when not a routed" do
    @router.should_not_receive :run
    get('/cas/log').status.should == 404
    get('/cas/tutu').status.should == 404
  end
  
  def get(path)
    @mock_request.get(path)
  end
  
  def post(path)
    @mock_request.post(path)
  end
end