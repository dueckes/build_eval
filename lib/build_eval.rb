require 'nokogiri'
require 'uri'
require 'net/http'
require 'net/https'
require 'travis/client/session'

require_relative 'build_eval/error'
require_relative 'build_eval/http'
require_relative 'build_eval/travis'
require_relative 'build_eval/result/status'
require_relative 'build_eval/result/build_result'
require_relative 'build_eval/result/server_result'
require_relative 'build_eval/result/composite_result'
require_relative 'build_eval/server/invalid_selector_error'
require_relative 'build_eval/server/decorator'
require_relative 'build_eval/server/cruise_control_response'
require_relative 'build_eval/server/team_city'
require_relative 'build_eval/server/travis'
require_relative 'build_eval/server/travis_pro'
require_relative 'build_eval/server/jenkins'
require_relative 'build_eval/monitor/base'
require_relative 'build_eval/monitor/server'
require_relative 'build_eval/monitor/composite'

module BuildEval

  class << self

    def server(args)
      type_args = args.clone
      server_type = type_args.delete(:type)
      BuildEval::Server::Decorator.new(server_class_for(server_type).new(type_args))
    end

    private

    def server_class_for(type)
      BuildEval::Server.const_get(type.to_s)
    rescue NameError
      raise "Server type '#{type}' is invalid"
    end

  end

end
