module BuildEval
  module Result

    class CompositeResult

      def initialize(results)
        @results = results
      end

      def status
        BuildEval::Result::Status.effective_status(@results.map(&:status))
      end

      def unsuccessful
        @results.map(&:unsuccessful).flatten
      end

      def to_s
        @results.map(&:to_s).join("\n")
      end

    end

  end
end
