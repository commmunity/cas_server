require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Extension::Authenticator do
  it "should raise InvalidAuthenticator in case of invalid Implementation" do
    CasServer::Configuration.should_receive(:authenticator).any_number_of_times.and_return(:unknown)
    lambda {
      CasServer::Extension::Authenticator.default.new(Proc.new {}).authenticate!
    }.should raise_error(CasServer::InvalidAuthenticator)
  end
  
  it "should use authenticator with proper model" do
    CasServer::Configuration.should_receive(:authenticator).and_return(:mock)
    CasServer::Extension::Authenticator::Mock.should_receive(:new)
    CasServer::Extension::Authenticator.default.new(Proc.new {})
  end
  
  it "should load all sort of existing authenticator" do
    CasServer::Extension::Authenticator.find(:mock).should == CasServer::Extension::Authenticator::Mock
  end
  
  it "should raise when you try to find a non existent authenticator" do
    lambda {
      CasServer::Extension::Authenticator.find(:unknow)
    }.should raise_error(CasServer::InvalidAuthenticator)
  end
end
