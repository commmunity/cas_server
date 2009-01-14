require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :spec

desc "Run specs"
task :spec  => :'specs:spec'
task :specs => :'specs:spec'

namespace :specs do
  def spec_path
    path = ENV['SPECS_PATH'] || "spec"
    puts "Using #{path.inspect} path. (See SPECS_PATH environment variable.)"
    path
  end
  
  desc "Run specs"
  task :spec do
    system("spec #{spec_path} -c")
  end
end

desc 'Generate documentation for the cas_server plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'CasServer'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
