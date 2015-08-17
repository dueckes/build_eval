module BuildEval
  module Server

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
        BuildEval::Result::BuildResult.create(build_name: name, status_name: build_element.attribute("status").value)
      end

      def to_s
        "TeamCity server #{@base_uri}"
      end

    end

  end
end
