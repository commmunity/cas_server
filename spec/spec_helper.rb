ENV["RAILS_ENV"] = "test"
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'cas_server'))
CasServer::Configuration.logger = CasServer::SilentLogger.new

def load_schema
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    load(File.dirname(__FILE__) + "/../db/schema.rb") if File.exist?(File.dirname(__FILE__) + "/../db/schema.rb")
  end
end

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])
load_schema

require 'spec'
require 'rack/mock'

#Debugger
require File.expand_path(File.join(File.dirname(__FILE__), 'enable_debugger'))
ENV['DEBUG'] = '1' #always enabled, require ruby-debug
include EnableDebugger

#bad bad but usefull ^^
class Hash
  
  def cookies=(cookie_hash)
    delete("Set-Cookie")
    cookie_hash.each do |key, value|
      set_cookie(key, value)
    end
  end
  
  def set_cookie(key, value)
    case value
    when Hash
      domain  = "; domain="  + value[:domain]    if value[:domain]
      path    = "; path="    + value[:path]      if value[:path]
      # According to RFC 2109, we need dashes here.
      # N.B.: cgi.rb uses spaces...
      expires = "; expires=" + value[:expires].clone.gmtime.
        strftime("%a, %d-%b-%Y %H:%M:%S GMT")    if value[:expires]
      secure = "; secure"  if value[:secure]
      httponly = "; HttpOnly" if value[:httponly]
      value = value[:value]
    end
    value = [value]  unless Array === value
    cookie = Utils.escape(key) + "=" +
      value.map { |v| Utils.escape v }.join("&") +
      "#{domain}#{path}#{expires}#{secure}#{httponly}"

    case self["Set-Cookie"]
    when Array
      self["Set-Cookie"] << cookie
    when String
      self["Set-Cookie"] = [self["Set-Cookie"], cookie]
    when nil
      self["Set-Cookie"] = cookie
    end
  end
  
end