module BuildEval
  module Result

    class BuildResult

      class << self

        def create(args)
          new(
            build_name:  args[:build_name],
            branch_name: args[:branch_name],
            status:      BuildEval::Result::Status.find(args[:status_name])
          )
        end

        def indeterminate(args)
          new(
            build_name:  args[:build_name],
            branch_name: args[:branch_name],
            status:      BuildEval::Result::Status::INDETERMINATE
          )
        end

      end

      attr_reader :status

      private

      def initialize(args)
        @build_name  = args[:build_name]
        @branch_name = args[:branch_name]
        @status      = args[:status]
      end

      public

      def unsuccessful?
        @status.unsuccessful?
      end

      def to_s
        "#{@build_name}#{@branch_name ? ":#{@branch_name}" : ""} -> #{@status}"
      end

    end

  end
end
