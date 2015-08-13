module BuildEval
  module CIServer

    class TeamCity

      def initialize(args)
        @base_uri = args[:uri]
        @username = args[:username]
        @password = args[:password]
      end

      def build_result(name)
        response = issue_request(name)
        build_element = Nokogiri::XML(response.body).xpath("//build").first
        raise "Unexpected build response: #{response.message}" unless build_element
        BuildEval::BuildResult.create(build_name: name, status_name: build_element.attribute("status").value)
      end

      private

      def issue_request(name)
        uri = URI.parse("#{@base_uri}/httpAuth/app/rest/buildTypes/id:#{name}/builds")
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          request = Net::HTTP::Get.new(uri.request_uri)
          request.basic_auth(@username, @password)
          http.request(request)
        end
      end

    end

  end
end
