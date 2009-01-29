#dummy logger file
module CasServer
  module Loggable
    def logging_id
      self.class.name
    end
    
    def debug(msg)
      log.debug "[Cas][#{logging_id}] #{msg}"
    end
    
    def log
      CasServer::Configuration.logger
    end
  end
  
  class MockLogger    
    def method_missing(level, message)
      puts "[#{level}]#{message}"
    end
  end
  
  class SilentLogger
    def method_missing(level, message)
    end
  end
end