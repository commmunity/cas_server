#dummy logger file
module CasServer
  module Loggable
    def log
      CasServer::Configuration.logger
    end
  end
  
  class MockLogger    
    def method_missing(level, message)
      puts "[#{level}] #{message}"
    end
  end
  
  class SilentLogger
    def method_missing(level, message)
    end
  end
end