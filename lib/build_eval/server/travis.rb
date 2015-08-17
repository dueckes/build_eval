module BuildEval
  module Server

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
        BuildEval::Result::BuildResult.create(build_name: name, status_name: build_element.attribute("lastBuildStatus").value)
      end

      def to_s
        "Travis CI #{@username}"
      end

    end

  end
end
