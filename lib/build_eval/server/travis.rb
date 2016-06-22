module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
      end

      def build_result(name)
        repo_string = "#{@username}/#{name}"
        has_failed = ::Travis::Repository.find(repo_string).recent_builds.first.failed?
        BuildEval::Result::BuildResult.create(
          build_name:  repo_string,
          status_name: has_failed ? "Failure" : "Success"
        )
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
