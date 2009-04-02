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
    @instance.request.should be_a(CasServer::Rack::Request)
    @instance.response.should be_a(CasServer::Rack::Response)
    @instance.service_manager.should be_a(CasServer::Extension::ServiceManager::Base)
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
  
  describe 'service manager' do
    
    before :each do
      @service_manager = mock(:service_manager)
      @instance.stub!(:service_manager).and_return(@service_manager)
    end
    
    it 'is assigned in request env' do
      @service_manager.should_receive(:validate_service!)
      @instance.should_receive(:process!)
      @instance.call(@mock_env)
      @mock_env['cas_server.service_manager'].should be_a(CasServer::Extension::ServiceManager::Base)
    end
    
    it 'is validated if service param is mandatory' do
      @instance.should_receive(:service_param_mandatory?).and_return(true)
      @instance.should_receive(:process!)

      @service_manager.should_receive(:validate_service!)
      @instance.call(@mock_env)
    end

    it 'is validated if service url is present' do
      @instance.should_receive(:service_url?).and_return(true)
      @instance.should_receive(:process!)

      @service_manager.should_receive(:validate_service!)
      @instance.call(@mock_env)
    end

    it "is not validated if service url is not present and mandatory" do
      @instance.should_receive(:service_url?).and_return(false)
      @instance.should_receive(:process!)

      @service_manager.should_not_receive(:validate_service!)
      @instance.call(@mock_env)
    end
    
  end
end