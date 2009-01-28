require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Extension::ServiceManager::Base do
  before do
    @rack_server = nil
  end
  
  it 'should raise a InvalidServiceURL if url is invalid' do
    lambda {
      CasServer::Extension::ServiceManager::Base.new('http://', @rack_server)
    }.should raise_error(CasServer::InvalidServiceURL)
    
    lambda {
      CasServer::Extension::ServiceManager::Base.new('ftp://www.google.fr', @rack_server)
    }.should raise_error(CasServer::InvalidServiceURL)
    
    lambda {
      CasServer::Extension::ServiceManager::Base.new('http://www.google.com', @rack_server)
    }.should_not raise_error
  end
  
  it 'accepts https URLs' do
    lambda {
      CasServer::Extension::ServiceManager::Base.new('https://www.google.com', @rack_server)
    }.should_not raise_error
  end
  
  it 'has a service url' do
    CasServer::Extension::ServiceManager::Base.new('http://www.google.com', @rack_server).service_url.should == URI.parse('http://www.google.com')
    CasServer::Extension::ServiceManager::Base.new(URI.parse('http://www.google.com'),@rack_server).service_url.should == URI.parse('http://www.google.com')
  end
  
  it "hasn't valid? implemented" do
    lambda {
      CasServer::Extension::ServiceManager::Base.new('http://www.google.com', @rack_server).valid?
    }.should raise_error(NotImplementedError, 'CasServer::Extension::ServiceManager::Base#valid?')
  end
  
  it 'can validate service url' do
    service_manager = CasServer::Extension::ServiceManager::Base.new('http://google.com', @rack_server)
    service_manager.should_receive(:valid?).and_return(true)
    service_manager.validate!.should be_true
  end
  
  it 'can invalidate service url' do
    service_manager = CasServer::Extension::ServiceManager::Base.new('http://google.com', @rack_server)
    service_manager.should_receive(:valid?).and_return(false)
    lambda {
      service_manager.validate!
    }.should raise_error(CasServer::InvalidServiceURL)
  end
end
