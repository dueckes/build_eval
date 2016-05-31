module BuildEval
  module Monitor
    class Base
      def +(monitor)
        BuildEval::Monitor::Composite.new(self, monitor)
      end
    end
  end
end
