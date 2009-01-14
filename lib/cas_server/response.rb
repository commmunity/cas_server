# Basicely Manager will return an instance of this object, this is supposed to be used by target framework
# to do the real work (redirection, cookies, headers, display pages, ...)
# This class store an Abstract representation of the data to be handle by the framework controller adapter
module CasServer
  class Response
    attr_reader :cookies_to_set
    attr_accessor :warnings
    attr_accessor :errors
    attr_reader :template_to_render
    
    def initialize
      @cookies_to_set = {}
      @warnings = []
      @errors = []
    end
    
    def render_template(template)
      @template_to_render = template
    end
    
    def render_template?
      @template_to_render.present?
    end
    
    def redirect_to(uri = nil)
      @redirect_to = uri if uri
      @redirect_to
    end
    
    def redirect?
      @redirect_to.present?
    end
    
    def set_cookies?
      !cookies_to_set.empty?
    end
    
    def set_cookie(name,value)
      @cookies_to_set[name] = value
    end
    
    def warning?
      !@warnings.empty?
    end
    
    def error?
      !@errors.empty?
    end
  end
end