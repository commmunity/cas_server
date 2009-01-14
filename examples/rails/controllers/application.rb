# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery :secret => 'ca3dde1ee386103543c711df1ad79366eb9208be'
  filter_parameter_logging :password
end
