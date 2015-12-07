module BuildEval
  module Server

    class Travis

      def initialize(args)
        @username = args[:username]
      end

      def build_result(name)
        raw_response = BuildEval::Http.get("https://api.travis-ci.org/repositories/#{@username}/#{name}/cc.xml")
        BuildEval::Server::CruiseControlResponse.new(raw_response).parse_result("//Project")
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
