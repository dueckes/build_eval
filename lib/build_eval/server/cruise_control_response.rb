module BuildEval
  module Server
    class CruiseControlResponse
      def initialize(raw_response)
        @raw_response = raw_response
      end

      def parse_result(project_selector)
        build_element = Nokogiri::XML(@raw_response.body).xpath(project_selector).first
        raise BuildEval::Server::InvalidSelectorError.new(@raw_response, project_selector) unless build_element
        BuildEval::Result::BuildResult.create(
          build_name:  build_element.attribute('name').value.match(/[^\/]+$/)[0],
          status_name: build_element.attribute('lastBuildStatus').value
        )
      end
    end
  end
end
