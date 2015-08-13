module BuildEval
  module CIServer

    class Decorator

      def initialize(delegate)
        @delegate = delegate
      end

      def build_result(name)
        begin
          @delegate.build_result(name)
        rescue Exception
          BuildEval::BuildResult.unknown(name)
        end
      end

      def monitor(*build_names)
        BuildEval::Monitor.new(server: @delegate, build_names: build_names.flatten)
      end

    end

  end
end
