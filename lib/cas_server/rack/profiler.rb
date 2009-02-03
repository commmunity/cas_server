require 'ruby-prof'

module CasServer
  module Rack
    class Profiler
      def initialize(app)
        @app = app
      end
      
      def call(env)
        res = nil
        # Profile the code
        result = RubyProf.profile do
          res = @app.call(env)
        end
        # Print a graph profile to text
        printer = RubyProf::GraphPrinter.new(result)
        printer.print(STDOUT, 0)
        res
      end
    end
  end
end