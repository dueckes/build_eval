module BuildEval
  module Result

    class ServerResult

      def initialize(server, build_results)
        @server        = server
        @build_results = build_results
      end

      def status
        BuildEval::Result::Status.effective_status(@build_results.map(&:status))
      end

      def unsuccessful
        @build_results.find_all(&:unsuccessful?)
      end

      def to_s
        "#{@server}: #{@build_results.map(&:to_s).join(", ")}"
      end

    end

  end
end
