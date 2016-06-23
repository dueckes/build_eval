module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
        @travis   = BuildEval::Travis.new(::Travis)
      end

      def build_result(name)
        build_path = "#{@username}/#{name}"
        BuildEval::Result::BuildResult.create(
          build_name:  build_path,
          status_name: @travis.last_build_status_for(build_path)
        )
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
