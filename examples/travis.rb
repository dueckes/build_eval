module BuildEval
  module Examples

    class Travis

      def self.eval_builds
        monitor = BuildEval.server(
          type:     :Travis,
          username: "MYOB-Technology"
        ).monitor("build_eval", "http_stub", "http_stub_producer_example")
        puts monitor.evaluate.to_s
      end

    end

  end
end
