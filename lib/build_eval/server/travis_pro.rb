module BuildEval
  module Server

    class TravisPro

      def initialize(args)
        @username     = args[:username]
        @github_token = args[:github_token]
        @travis       = BuildEval::Travis.new(::Travis::Pro)
      end

      def build_result(name)
        build_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(build_name: build_path, status_name: last_status_name(build_path))
      end

      def to_s
        "Travis CI Pro #{@username}"
      end

      private

      def last_status_name(build_path)
        @travis.login(@github_token)
        @travis.last_build_status_for(build_path)
      end

    end

  end
end
