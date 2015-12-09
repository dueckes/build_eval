describe BuildEval::Server::Travis do
  include_context "stubbed http interactions"

  let(:username)         { "some_username" }
  let(:constructor_args) { { username: username } }

  let(:travis_server) { described_class.new(constructor_args) }

  it_behaves_like "a continuous integration server" do

    let(:server) { travis_server }

  end

  describe "#build_result" do

    let(:build_name)              { "some_build_name" }
    let(:response)                { instance_double(Net::HTTPResponse) }
    let(:build_result)            { instance_double(BuildEval::Result::BuildResult) }
    let(:cruise_control_response) do
      instance_double(BuildEval::Server::CruiseControlResponse, parse_result: build_result)
    end

    subject { travis_server.build_result(build_name) }

    before(:example) do
      allow(http).to receive(:get).and_return(response)
      allow(BuildEval::Server::CruiseControlResponse).to receive(:new).and_return(cruise_control_response)
      allow(cruise_control_response).to receive(:parse_result).and_return(build_result)
    end

    it "issues a GET request for the build" do
      expect(http).to receive(:get).with("https://api.travis-ci.org/repositories/#{username}/#{build_name}/cc.xml")

      subject rescue Exception
    end

    it "creates a Cruise Control response containing the GET request response" do
      expect(BuildEval::Server::CruiseControlResponse).to receive(:new).with(response)

      subject
    end

    it "parses the Cruise Control response to return the project" do
      expect(cruise_control_response).to receive(:parse_result).with("//Project")

      subject
    end

    it "returns the parsed build result" do
      expect(subject).to eql(build_result)
    end

  end

  describe "#to_s" do

    subject { travis_server.to_s }

    it "returns a string indicating it uses the Travis CI service" do
      expect(subject).to include("Travis CI")
    end

    it "returns a string containing the username" do
      expect(subject).to include(username)
    end

  end

end
