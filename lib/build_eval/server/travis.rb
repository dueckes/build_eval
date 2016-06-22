module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
      end

      def build_result(name)
        build_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(build_name: build_path, status_name: last_status_name(build_path))
      end

      def to_s
        "Travis CI #{@username}"
      end

      private

      def last_status_name(build_path)
        ::Travis::Repository.find(build_path).recent_builds.find(&:finished?).passed? ? "Success" : "Failure"
      end

    end

  end
end
