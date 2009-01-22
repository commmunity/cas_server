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
  
  it "builds domain parser" do
    domain_parser = CasServer::Api::DomainParser.build('http://google.com')
    domain_parser.should be_an_instance_of(CasServer::Api::DomainParser::Mock)
    domain_parser.service_url.should == URI.parse('http://google.com')
  end
end
