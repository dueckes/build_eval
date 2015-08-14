module BuildEval
  module CIServer

    class Travis

      def initialize(args)
        @username = args[:username]
      end

      def build_result(name)
        response = BuildEval::Http.get(
          "https://api.travis-ci.org/repositories/#{@username}/#{name}/cc.xml"
        )
        build_element = Nokogiri::XML(response.body).xpath("//Project").first
        raise "Unexpected build response: #{response.message}" unless build_element
        BuildEval::BuildResult.create(build_name: name, status_name: build_element.attribute("lastBuildStatus").value)
      end

    end

  end
end
