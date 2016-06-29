module BuildEval
  module Server

    class Decorator

      def initialize(delegate)
        @delegate = delegate
      end

      def build_result(build_name, branch_name)
        @delegate.build_result(build_name, branch_name)
      rescue StandardError
        BuildEval::Result::BuildResult.indeterminate(build_name: build_name, branch_name: branch_name)
      end

      def monitor(*build_configurations)
        BuildEval::Monitor::Server.new(server: @delegate, build_configurations: build_configurations.flatten)
      end

    end

  end
end
