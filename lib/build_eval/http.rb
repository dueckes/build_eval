module BuildEval
  class Http
    def initialize(config)
      @username        = config[:username]
      @password        = config[:password]
      @ssl_verify_mode = config[:ssl_verify_mode]
    end

    def get(uri_string)
      uri = URI.parse(uri_string)
      Net::HTTP.start(uri.host, uri.port, ssl_options(uri)) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth(@username, @password) if @username && @password
        http.request(request)
      end
    end

    private

    def ssl_options(uri)
      ssl_options = { use_ssl: uri.scheme == 'https' }
      ssl_options[:ssl_verify_mode] = @ssl_verify_mode if @ssl_verify_mode
      ssl_options
    end
  end
end
