require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Extension::Authenticator do
  it "should load all sort of existing authenticator" do
    CasServer::Extension::Authenticator.find(:mock).should == CasServer::Extension::Authenticator::Mock
  end
  
  it "should raise when you try to find a non existent authenticator" do
    lambda {
      CasServer::Extension::Authenticator.find(:unknow)
    }.should raise_error(CasServer::InvalidAuthenticator)
  end
end
