module CasServer
  module Extension
    module Authenticator
      class Facebook < CasServer::Extension::Authenticator::Base

        def fb_session
          @fb_session ||= Facebooker::Session.create
        end
        
        def authenticate?
          debug "Try to authenticate with auth_token #{params['auth_token']}"
          fb_session.auth_token = params['auth_token']
          fb_session.secure!
          true
        rescue StandardError => exception
          debug "Facebooker raise with exception #{exception.message}"
          false
        end
        
        def before_credential_requestor
          #redirect to http://www.facebook.com/login.php?api_key=#{$FB_API_KEY}&v=1.0&next=service%2D<service_url>
          redirect_to fb_session.login_url(:next => "&service=#{params['service']}")
        end
        
        def uuid
          "#{@fb_session.send(:uid)}/facebook"
        end
        
        def firstname
          @fb_session.user.first_name
        end
        
        def lastname
          @fb_session.user.last_name
        end
        
        def avatar_url
          @fb_session.user.pic_square
        end
        
        def extra_attributes
          { :uuid => uuid,
            :firstname => firstname, 
            :lastname => lastname,
            :avatar_url => avatar_url
          }
        end
      end #FacebookSso
    end #Authenticator
  end #Extension
end #CasServer