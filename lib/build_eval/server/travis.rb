module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
      end

      def build_result(name)
        repository_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(
          build_name:  repository_path,
          status_name: BuildEval::Travis.last_build_status(repository_path: repository_path)
        )
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
