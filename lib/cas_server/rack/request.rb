#utility methods extracted from cloudkit
module CasServer
  module Rack
    class Request < ::Rack::Request
      # Return true if method, path, and required_params match.
      def match?(method, path, required_params=[])
        (method == '*' || request_method == method) &&
          path_info.match(path) &&# just enough to work for now
          param_match?(required_params)
      end

      # Return true of the array of required params match the request params. If
      # a hash in passed in for a param, its value is also used in the match.
      def param_match?(required_params)
        required_params.all? do |required_param|
          case required_param
          when Hash
            key = required_param.keys.first
            return false unless params.has_key? key
            return false unless params[key] == required_param[key]
          when String
            return false unless params.has_key? required_param
          else
            false
          end
          true
        end
      end
    end #Request
  end #Rack
end #CasServer