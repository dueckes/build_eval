describe BuildEval::Http do

  shared_examples_for "a http method returning a response" do

    let(:response_status) { [ "200", "OK" ] }
    let(:response_body)   { "Some Response Body" }

    it "returns a response containing the response body" do
      expect(subject.body).to eql(response_body)
    end

    it "returns a response containing the response status" do
      expect(subject.code).to eql("200")
    end

    it "returns a response containing the response message" do
      expect(subject.message).to eql("OK")
    end

  end

  describe "::get" do

    let(:scheme)     { "http" }
    let(:host)       { "a.host" }
    let(:path)       { "some/path" }
    let(:uri_string) { "#{scheme}://#{host}/#{path}" }

    subject { described_class.get(uri_string) }

    context "when the uri is valid" do

      let(:expected_request_uri) { uri_string }

      before(:example) do
        FakeWeb.register_uri(:get, expected_request_uri, status: response_status, body: response_body)
      end

      context "and the uri contains a http scheme" do

        let(:scheme) { "http" }

        it_behaves_like "a http method returning a response"

      end

      context "and the uri contains a https scheme" do

        let(:scheme) { "https" }

        it_behaves_like "a http method returning a response"

      end

      context "and basic authentication is provided" do

        let(:username) { "some_username" }
        let(:password) { "some_password" }

        let(:expected_request_uri) { "#{scheme}://#{username}:#{password}@#{host}/#{path}" }

        subject { described_class.get(uri_string, basic_authentication: { username: username, password: password }) }

        it_behaves_like "a http method returning a response"

      end

    end

    context "when the uri is invalid" do

      before(:example) { FakeWeb.clean_registry }

      it "raises an error" do
        expect { subject }.to raise_error(SocketError)
      end

    end

  end

end
