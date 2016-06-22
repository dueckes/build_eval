module BuildEval
  module Server

    class TravisPro

      def initialize(args)
        @username     = args[:username]
        @github_token = args[:github_token]
      end

      def build_result(name)
        repository_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(
          build_name:  repository_path,
          status_name: last_build_failed?(repository_path) ? "Failure" : "Success"
        )
      end

      def to_s
        "Travis CI Pro #{@username}"
      end

      private

      def last_build_failed?(repository_path)
        ::Travis::Pro.github_auth(@github_token)
        ::Travis::Pro::Repository.find(repository_path).recent_builds.first.failed?
      end

    end

  end
end
