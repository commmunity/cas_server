require File.dirname(__FILE__) + '/../spec_helper'

describe CasServer::ServiceValidateManager do
  before do
    @service_url = 'http://toto.com'
    @ts = CasServer::Entity::ServiceTicket.generate_for('username',@service_url)
    @params = {:service => @service_url, :ticket => @ts.value}
    @cookies = {}
    @manager = CasServer::ServiceValidateManager.new(@params,@cookies)
  end
  
  #2.5
  it "checks the validity of a service ticket and returns an XML-fragment response" do
    CasServer::Entity::ServiceTicket.should_receive(:validate_ticket!).with(@ts.value,@service_url)
    @manager.process
  end
  
  #2.5
  it "MUST also generate and issue proxy-granting tickets when requested"
  
  #2.5
  it "is recommanded that the error explain that validation failed when a proxy ticket was passed"

  #2.5.1
  it "should display an error in case of invalid params" do
    @params.delete(:service)
    @manager.process
    @manager.should be_error
    @manager.errors.first.class.should == CasServer::MissingMandatoryParams
  end
  
  describe 'when parameters new is set' do
    #2.5.2
    it "MUST not validate service ticket that has been created vi sso"
  
    #2.5.3
     it "may use INVALID_TICKET 'code' when service ticket has been created via sso"
  end
  
  #2.5.3
  it "may use INVALID_REQUEST 'code' in case missing mandatory params" do
    @params.delete(:service)
    @manager.process
    @manager.should be_error
    @manager.errors.first.error_identifier.should == 'INVALID_REQUEST'
  end
  
  #2.5.3
  it "may use INVALID_TICKET 'code' when ticket provided was not valid" do
    @params[:ticket] = 'bad'
    @manager.process
    @manager.should be_error
    @manager.errors.first.error_identifier.should == 'INVALID_TICKET'
  end
  
  #2.5.3
  it "may use INVALID_SERVICE 'code' when the ticket provided was valid, but the service specified was not" do
    @params[:service] = 'http://tata.com'
    @manager.process
    @manager.should be_error
    @manager.errors.first.error_identifier.should == 'INVALID_SERVICE'
  end
  
  #2.5.3
  it "MUST invalidate the ticket and disallow future validation of that same ticket in case of INVALID_SERVICE" do
    @params[:service] = 'http://tata.com'
    @manager.process
    @manager.should be_error
    lambda {
      @ts.class.validate_ticket!(@ts.value,@ts.service)
    }.should raise_error(CasServer::InvalidTicket)
  end
end