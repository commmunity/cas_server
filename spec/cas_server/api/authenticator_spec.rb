require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Api::Authenticator do
  it "should raise InvalidAuthenticator in case of invalid Implementation" do
    CasServer::Configuration.should_receive(:authenticator).any_number_of_times.and_return(:unknown)
    lambda {
      CasServer::Api::Authenticator.authenticate('username', 'password')
    }.should raise_error(CasServer::InvalidAuthenticator)
  end
  
  it "should use authenticator with proper model" do
    CasServer::Configuration.should_receive(:authenticator).and_return(:mock)
    CasServer::Api::Authenticator::Mock.should_receive(:authenticate).and_return true
    CasServer::Api::Authenticator.authenticate('username', 'password').should be_true
  end
end
