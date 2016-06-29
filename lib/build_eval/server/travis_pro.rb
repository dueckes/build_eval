module BuildEval
  module Server

    class TravisPro

      def initialize(args)
        @username     = args[:username]
        @github_token = args[:github_token]
        @branch       = args[:branch]
      end

      def build_result(build_name, branch_name)
        repository_path = "#{@username}/#{build_name}"
        BuildEval::Result::BuildResult.create(
          build_name:  repository_path,
          branch_name: branch_name,
          status_name: BuildEval::Travis.last_build_status(github_token:    @github_token,
                                                           repository_path: repository_path,
                                                           branch:          branch_name)
        )
      end

      def to_s
        "Travis CI Pro #{@username}"
      end

    end

  end
end
