module EnableDebugger
  def self.included(base)
    base.class_eval do
      if %w(on y yes yeah true 1).include?(ENV['DEBUG'].to_s.downcase)
        begin
          require_library_or_gem 'ruby-debug'
          Debugger.start
          Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
        rescue LoadError
          puts "You need to install ruby-debug to run the server in debugging mode. With gems, use 'gem install ruby-debug'"
          exit
        end
      end
    end
  end
end