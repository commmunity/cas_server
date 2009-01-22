require File.dirname(__FILE__) + '/../../../spec_helper'

describe CasServer::Api::DomainParser::Base do
  
  it 'should raise a InvalidServiceURL if url is invalid' do
    lambda {
      CasServer::Api::DomainParser::Base.new('http://')
    }.should raise_error(CasServer::InvalidServiceURL)
    
    lambda {
      CasServer::Api::DomainParser::Base.new('ftp://www.google.fr')
    }.should raise_error(CasServer::InvalidServiceURL)
    
    lambda {
      CasServer::Api::DomainParser::Base.new('http://www.google.com')
    }.should_not raise_error
  end
  
  it 'accepts https URLs' do
    lambda {
      CasServer::Api::DomainParser::Base.new('https://www.google.com')
    }.should_not raise_error
  end
  
  it 'has a service url' do
    CasServer::Api::DomainParser::Base.new('http://www.google.com').service_url.should == URI.parse('http://www.google.com')
    CasServer::Api::DomainParser::Base.new(URI.parse('http://www.google.com')).service_url.should == URI.parse('http://www.google.com')
  end
  
  it "hasn't valid? implemented" do
    lambda {
      CasServer::Api::DomainParser::Base.new('http://www.google.com').valid?
    }.should raise_error(NotImplementedError, 'CasServer::Api::DomainParser::Base#valid?')
  end
  
  it 'can validate service url' do
    domain_parser = CasServer::Api::DomainParser::Base.new('http://google.com')
    domain_parser.should_receive(:valid?).and_return(true)
    domain_parser.validate!.should be_true
  end
  
  it 'can invalidate service url' do
    domain_parser = CasServer::Api::DomainParser::Base.new('http://google.com')
    domain_parser.should_receive(:valid?).and_return(false)
    lambda {
      domain_parser.validate!
    }.should raise_error(CasServer::InvalidServiceURL)
  end
  
end
