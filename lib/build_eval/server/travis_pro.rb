module BuildEval
  module Server

    class TravisPro

      def initialize(args)
        @username     = args[:username]
        @github_token = args[:github_token]
      end

      def build_result(name)
        build_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(
          build_name:  build_path,
          status_name: BuildEval::Travis.last_build_status(github_token: @github_token, build_path: build_path)
        )
      end

      def to_s
        "Travis CI Pro #{@username}"
      end

    end

  end
end
