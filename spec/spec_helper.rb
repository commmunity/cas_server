ENV["RAILS_ENV"] = "test"
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'cas_server'))

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