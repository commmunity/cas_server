require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Rack::Api::Base do
  before do
    @instance = CasServer::Rack::Api::Base.new
    @service  = 'http://test.service.com' 
    @mock_env = Rack::MockRequest.env_for("http://example.com:8080/?service=#{@service}")
  end
  
  it "should call process! when rack app is executed with request, response and service_manager available" do
    @instance.should_receive(:process!)
    @instance.call(@mock_env)
    @instance.request.should be_instance_of(CasServer::Rack::Request)
    @instance.response.should be_instance_of(CasServer::Rack::Response)
    @instance.service_manager.should be_kind_of(CasServer::Extension::ServiceManager::Base)
  end
  
  it "should catch exception with exception_handler" do
    @exception = CasServer::Error.new('mock error')
    @instance.should_receive(:process!).and_raise(@exception)
    @instance.should_receive(:default_exception_handler).with(@exception)
    @instance.call(@mock_env)
  end
  
  it "should have configurable exception handler" do
    @exception = CasServer::Error.new('mock error')
    @instance.should_receive(:process!).and_raise(@exception)
    CasServer::Configuration.should_receive(:exception_handler).and_return(:whatever_method_to_handle_exception)
    @instance.should_receive(:whatever_method_to_handle_exception).with(@exception)
    @instance.should_not_receive(:default_exception_handler)
    @instance.call(@mock_env)
  end
  
  it "should valid service url as a first step" do
    @mock_env = Rack::MockRequest.env_for("http://example.com:8080/?service=sqdqsdqsdqsd")
    @instance.should_not_receive(:process!)
    @instance.should_receive(:default_exception_handler)
    @instance.call(@mock_env)
  end
  
  it "should valid parameters in the first step" do
    @instance.should_not_receive(:process!)
    @instance.should_receive(:validate_parameters!).and_raise(CasServer::Error)
    @instance.call(@mock_env)
  end
end