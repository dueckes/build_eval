describe BuildEval::Server::TeamCity do
  include_context "stubbed http interactions"

  let(:uri)              { "https://some.teamcity.server" }
  let(:username)         { "some_username" }
  let(:password)         { "some_password" }
  let(:constructor_args) { { uri: uri, username: username, password: password } }

  let(:team_city_server) { described_class.new(constructor_args) }

  it_behaves_like "a continuous integration server" do

    let(:server) { team_city_server }

  end

  describe "#build_result" do

    let(:build_name)    { "some_build_name" }
    let(:response_body) do
      <<-RESPONSE
        <builds count="3" href="/httpAuth/app/rest/buildTypes/#{build_name}/builds/" nextHref="/httpAuth/app/rest/buildTypes/#{build_name}/builds/?count=3&start=3">
          <build id="87735" buildTypeId="#{build_name}" number="2062" status="SUCCESS" state="finished" href="/httpAuth/app/rest/builds/id:87735" webUrl="#{uri}/viewLog.html?buildId=87735&buildTypeId=#{build_name}"/>
        </builds>
      RESPONSE
    end
    let(:response)      { instance_double(Net::HTTPResponse, body: response_body) }

    subject { team_city_server.build_result(build_name) }

    before(:example) { allow(http).to receive(:get).and_return(response) }

    it "issues a GET request for the build" do
      expect(http).to receive(:get).with("#{uri}/httpAuth/app/rest/buildTypes/id:#{build_name}/builds")

      subject
    end

  end

  describe "#to_s" do

    subject { team_city_server.to_s }

    it "returns a string indicating it is a TeamCity server" do
      expect(subject).to include("TeamCity")
    end

    it "returns a string containing the uri to the server" do
      expect(subject).to include(uri)
    end

  end

end
