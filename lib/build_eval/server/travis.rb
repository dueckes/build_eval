module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
        @branch   = args[:branch]
      end

      def build_result(build_name, branch_name)
        repository_path = "#{@username}/#{build_name}"
        BuildEval::Result::BuildResult.create(
          build_name:  repository_path,
          branch_name: branch_name,
          status_name: BuildEval::Travis.last_build_status(repository_path: repository_path, branch: branch_name)
        )
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
