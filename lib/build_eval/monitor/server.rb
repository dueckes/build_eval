module BuildEval
  module Monitor

    class Server < BuildEval::Monitor::Base

      def initialize(args)
        @server               = args[:server]
        @build_configurations = args[:build_configurations]
      end

      def evaluate
        build_results = @build_configurations.map do |build_configuration|
          build_name, branch_name = build_configuration.split(":")
          @server.build_result(build_name, branch_name)
        end
        BuildEval::Result::ServerResult.new(@server, build_results)
      end

    end

  end
end
