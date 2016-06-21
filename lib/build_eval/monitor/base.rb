module BuildEval
  module Monitor

    class Base

      def +(other)
        BuildEval::Monitor::Composite.new(self, other)
      end

    end

  end
end
