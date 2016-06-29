module BuildEval
  module Server

    class Jenkins

      def initialize(args)
        @http     = BuildEval::Http.new(args)
        @base_uri = args[:uri]
      end

      def build_result(build_name, _branch_name)
        raw_response = @http.get("#{@base_uri}/cc.xml")
        BuildEval::Server::CruiseControlResponse.new(raw_response).parse_result("//Project[@name=\"#{build_name}\"]")
      end

      def to_s
        "Jenkins server #{@base_uri}"
      end

    end

  end
end
