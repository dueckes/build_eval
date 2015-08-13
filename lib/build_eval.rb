require 'nokogiri'

require_relative 'build_eval/status'
require_relative 'build_eval/build_result'
require_relative 'build_eval/build_results'
require_relative 'build_eval/ci_server/decorator'
require_relative 'build_eval/ci_server/team_city'
require_relative 'build_eval/monitor'

module BuildEval

  class << self

    def server(args)
      type_args = args.clone
      server_type = type_args.delete(:type)
      BuildEval::CIServer::Decorator.new(server_class_for(server_type).new(type_args))
    end

    private

    def server_class_for(type)
      begin
        BuildEval::CIServer.const_get(type.to_s)
      rescue NameError
        raise "Server type '#{type}' is invalid"
      end

    end

  end

end
