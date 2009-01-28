# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
#make active_record work

begin
  require 'active_record'
rescue LoadError
  require 'rubygems'
  require 'active_record'
end

def load_schema
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    load(File.dirname(__FILE__) + "/../db/schema.rb") if File.exist?(File.dirname(__FILE__) + "/../db/schema.rb")
  end
end

ActiveRecord::Base.silence do
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
  ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'mysql'])
  load_schema
end

require 'spec'
require 'rack/mock'

#Debugger
require File.expand_path(File.join(File.dirname(__FILE__), 'enable_debugger'))
ENV['DEBUG'] = '1' #always enabled, require ruby-debug
include EnableDebugger

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'cas_server'))