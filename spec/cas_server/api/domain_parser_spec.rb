require File.dirname(__FILE__) + '/../../spec_helper'

describe CasServer::Api::DomainParser do
  it "should raise InvalidDommainParser in case of invalid Implementation" do
    CasServer::Configuration.should_receive(:domain_parser).any_number_of_times.and_return(:unknown)
    lambda {
      CasServer::Api::DomainParser.current_implementation
    }.should raise_error(CasServer::InvalidDomainParser)
  end
  
  it "should use authenticator with proper model" do
    CasServer::Configuration.should_receive(:domain_parser).and_return(:mock)
    CasServer::Api::DomainParser.current_implementation.should be(CasServer::Api::DomainParser::Mock)
  end
end
