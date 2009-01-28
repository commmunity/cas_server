require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Extension::ServiceManager do
  before do
    @rack_server = nil
  end
  
  it "should raise InvalidDommainParser in case of invalid Implementation" do
    CasServer::Configuration.should_receive(:service_manager).any_number_of_times.and_return(:unknown)
    lambda {
      CasServer::Extension::ServiceManager.current_implementation
    }.should raise_error(CasServer::InvalidServiceManager)
  end
  
  it "should use authenticator with proper model" do
    CasServer::Configuration.should_receive(:service_manager).and_return(:mock)
    CasServer::Extension::ServiceManager.current_implementation.should be(CasServer::Extension::ServiceManager::Mock)
  end
  
  it "provide a factory of domain parser" do
    service_manager = CasServer::Extension::ServiceManager.build('http://google.com', @rack_server)
    service_manager.should be_an_instance_of(CasServer::Extension::ServiceManager::Mock)
    service_manager.service_url.should == URI.parse('http://google.com')
  end
end
