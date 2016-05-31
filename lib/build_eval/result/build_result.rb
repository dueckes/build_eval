module BuildEval
  module Result
    class BuildResult
      class << self
        def create(args)
          new(build_name: args[:build_name], status: BuildEval::Result::Status.find(args[:status_name]))
        end

        def indeterminate(build_name)
          new(build_name: build_name, status: BuildEval::Result::Status::INDETERMINATE)
        end
      end

      attr_reader :build_name
      attr_reader :status

      private

      def initialize(args)
        @build_name = args[:build_name]
        @status     = args[:status]
      end

      public

      def unsuccessful?
        @status.unsuccessful?
      end

      def to_s
        "#{@build_name}: #{@status}"
      end
    end
  end
end
