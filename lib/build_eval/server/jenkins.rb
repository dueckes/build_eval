module BuildEval
  module Server

    class Jenkins

      def initialize(args = {})
        @base_uri = args[:uri]
      end

      def build_result(name)
        response = BuildEval::Http.get("#{@base_uri}/cc.xml")
        build_element = Nokogiri::XML(response.body).xpath("//Project[@name=\"#{name}\"]").first
        raise "Unexpected build response: #{response.message}" unless build_element
        BuildEval::Result::BuildResult.create(build_name: name, status_name: build_element.attribute("lastBuildStatus").value)
      end

      def to_s
        "Jenkins CI #{@base_uri}"
      end

    end

  end
end
