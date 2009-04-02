require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Extension::ServiceManager::Base do
  before :each do
    @rack_server = mock(:rack_server)
  end
  
  def build_manager(url = 'http://www.service.com', rack_server = @rack_server)
    CasServer::Extension::ServiceManager::Base.new(url, rack_server)
  end
  
  it 'raise a InvalidServiceURL if url is invalid' do
    lambda {
      build_manager('http://')
    }.should raise_error(CasServer::InvalidServiceURL)
    
    lambda {
      build_manager('ftp://service.com')
    }.should raise_error(CasServer::InvalidServiceURL)
  end
  
  it 'accepts valid URL' do
    lambda {
      build_manager
    }.should_not raise_error
  end
  
  it 'accepts valid https URLs' do
    lambda {
      build_manager('https://service.com')
    }.should_not raise_error
  end
  
  it 'accepts empty service' do
    lambda {
      build_manager('')
      build_manager(nil)
    }.should_not raise_error
  end
  
  it 'has a service url' do
    build_manager.service_url.should == URI.parse('http://www.service.com')
    build_manager(URI.parse('http://www.service.com')).service_url.should == URI.parse('http://www.service.com')
  end
  
  it "hasn't valid_service? implemented" do
    lambda {
      build_manager.valid_service?
    }.should raise_error(NotImplementedError, 'CasServer::Extension::ServiceManager::Base#valid_service?')
  end
  
  it 'can validate service url' do
    manager = build_manager
    manager.should_receive(:valid_service?).and_return(true)
    manager.validate_service!.should be_true
  end
  
  it 'can invalidate service url' do
    manager = build_manager
    manager.should_receive(:valid_service?).and_return(false)
    lambda {
      manager.validate_service!
    }.should raise_error(CasServer::InvalidServiceURL)
  end
  
  it 'can unauthorize a user' do
    manager = build_manager
    manager.should_receive(:authorized?).and_return(false)
    lambda {
      manager.check_authorization!(42)
    }.should raise_error(CasServer::AuthorizationRequired)
  end

  it "hasn't authorized? implemented" do
    lambda {
      build_manager.authorized?(42)
    }.should raise_error(NotImplementedError, 'CasServer::Extension::ServiceManager::Base#authorized?')
  end
  
end
