module BuildEval
  module Server

    class TeamCity

      def initialize(args)
        @http     = BuildEval::Http.new(args)
        @base_uri = args[:uri]
      end

      def build_result(build_name, _branch_name)
        response = @http.get("#{@base_uri}/httpAuth/app/rest/buildTypes/id:#{build_name}/builds")
        build_element = Nokogiri::XML(response.body).xpath("//build").first
        raise "Unexpected build response: #{response.message}" unless build_element
        BuildEval::Result::BuildResult.create(build_name:  build_name,
                                              status_name: build_element.attribute("status").value)
      end

      def to_s
        "TeamCity server #{@base_uri}"
      end

    end

  end
end
