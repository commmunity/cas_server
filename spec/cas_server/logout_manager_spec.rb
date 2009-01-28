require File.dirname(__FILE__) + '/../spec_helper'

describe CasServer::LogoutManager do
  before do
    @params = {}
    @tgt = CasServer::Entity::TicketGrantingCookie.generate_for('username')
    @cookies = {:tgt => @tgt.value}
    @manager = CasServer::LogoutManager.new(@params, @cookies)
  end
  
  #2.3
  it "destroys a client's single sign-on CAS session" do
    lambda do
      @manager.process
    end.should change(CasServer::Entity::TicketGrantingCookie, :count)
  end
  
  #2.3
  it "destroys The ticket-granting cookie" do
    @response = @manager.process
    @response.cookies_to_set.should have_key(:tgt)
    @response.cookies_to_set[:tgt].should be_nil
  end
  
  describe "if url params is specified" do
    # 2.3.1
    it "SHOULD show the url link on the logout page with descriptive text" do
      @params[:url] = 'http://logout.com'
      @response = @manager.process
      @response.warnings.first.should == 'cas_server.warning.logout_with_url'
      @response.should be_render_template
      @response.template_to_render.should == :logout
    end
  end
  
  # 2.3.2
  it "MUST display a page stating that the user has been logged out" do
    @response = @manager.process
    @response.warnings.first.should == 'cas_server.warning.logout'
    @response.should be_render_template
    @response.template_to_render.should == :logout
  end
end