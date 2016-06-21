module BuildEval
  module Server

    class TravisPro

      def initialize(args)
        @username = args[:username]
        ::Travis::Pro.github_auth(args[:github_token])
      end

      def build_result(name)
        repo_string = "#{@username}/#{name}"
        has_failed = ::Travis::Pro::Repository.find(repo_string).last_build.failed?
        BuildEval::Result::BuildResult.create(
          build_name:  repo_string,
          status_name: has_failed ? "Failure" : "Success"
        )
      end

      def to_s
        "Travis CI Pro #{@username}"
      end

    end
  end

end
