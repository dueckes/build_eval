module BuildEval
  module Server

    class Decorator

      def initialize(delegate)
        @delegate = delegate
      end

      def build_result(name)
        @delegate.build_result(name)
      rescue StandardError
        BuildEval::Result::BuildResult.indeterminate(name)
      end

      def monitor(*build_names)
        BuildEval::Monitor::Server.new(server: @delegate, build_names: build_names.flatten)
      end

    end

  end
end
