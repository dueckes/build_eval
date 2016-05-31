module BuildEval
  module Monitor
    class Server < BuildEval::Monitor::Base
      def initialize(args)
        @server      = args[:server]
        @build_names = args[:build_names]
      end

      def evaluate
        build_results = @build_names.map { |build_name| @server.build_result(build_name) }
        BuildEval::Result::ServerResult.new(@server, build_results)
      end
    end
  end
end
