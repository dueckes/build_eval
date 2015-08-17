module BuildEval
  module Monitor

    class Composite < BuildEval::Monitor::Base

      def initialize(*monitors)
        @monitors = monitors
      end

      def evaluate
        BuildEval::Result::CompositeResult.new(@monitors.map(&:evaluate))
      end

    end

  end
end
