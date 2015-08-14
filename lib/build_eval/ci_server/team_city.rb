module BuildEval
  module CIServer

    class TeamCity

      def initialize(args)
        @base_uri = args[:uri]
        @username = args[:username]
        @password = args[:password]
      end

      def build_result(name)
        response = BuildEval::Http.get(
          "#{@base_uri}/httpAuth/app/rest/buildTypes/id:#{name}/builds", username: @username, password: @password
        )
        build_element = Nokogiri::XML(response.body).xpath("//build").first
        raise "Unexpected build response: #{response.message}" unless build_element
        BuildEval::BuildResult.create(build_name: name, status_name: build_element.attribute("status").value)
      end

    end

  end
end
