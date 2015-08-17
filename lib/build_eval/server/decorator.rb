module BuildEval
  module Server

    class Decorator

      def initialize(delegate)
        @delegate = delegate
      end

      def build_result(name)
        begin
          @delegate.build_result(name)
        rescue Exception
          BuildEval::Result::BuildResult.unknown(name)
        end
      end

      def monitor(*build_names)
        BuildEval::Monitor::Server.new(server: @delegate, build_names: build_names.flatten)
      end

    end

  end
end
