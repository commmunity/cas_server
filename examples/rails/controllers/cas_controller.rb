class CasController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # 2.1. /login as credential requestor
  def credential_requestor
    @manager = CasServer::LoginCredentialRequestorManager.new(params, cookies)
    @manager.process
    process_result!
  end
  
  # 2.2. /login as credential acceptor
  def credential_acceptor
    @manager = CasServer::LoginCredentialAcceptorManager.new(params, cookies)
    @manager.process
    process_result!
  end

  # 2.3. /logout
  def logout
    @manager = CasServer::LogoutManager.new(params, cookies)
    @manager.process
    process_result!
  end
  
  # 2.4. /ServiceValidate
  def serviceValidate
    force_response_format Mime::XML
    @manager = CasServer::ServiceValidateManager.new(params, cookies)
    @manager.process
    process_result!
  end

  def proxyValidate
    serviceValidate
  end

  private
    def force_response_format(mime_type)
      response.content_type = mime_type
      response.template.template_format = mime_type.to_sym
    end
  
    def process_result!
      #set cookies
      if @manager.response.set_cookies?
        @manager.response.cookies_to_set.keys.each do |key|
          if @manager.response.cookies_to_set[key]
            cookies[key] = @manager.response.cookies_to_set[key]
          else
            cookies.delete(key)
          end
        end
      end
      
      if @manager.response.redirect?
        redirect_to @manager.response.redirect_to
      elsif @manager.response.render_template?
        render :template => "cas/#{@manager.response.template_to_render}", :locals => {:manager => @manager}
      else
        raise RuntimeError.new('cas_controller.error.internal_error')
      end  
    end
end