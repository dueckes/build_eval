module BuildEval

  class Http

    def self.get(uri_string, basic_auth=nil)
      uri = URI.parse(uri_string)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(basic_auth[:username], basic_auth[:password]) if basic_auth
        http.request(request)
      end
    end

  end

end
