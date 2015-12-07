describe BuildEval::Server::Travis do

  let(:username) { "some_username" }

  let(:travis) { described_class.new(username: username) }

  describe "#build_result" do

    let(:build_name)              { "some_build_name" }
    let(:response)                { instance_double(Net::HTTPResponse) }
    let(:build_result)            { instance_double(BuildEval::Result::BuildResult) }
    let(:cruise_control_response) do
      instance_double(BuildEval::Server::CruiseControlResponse, parse_result: build_result)
    end

    subject { travis.build_result(build_name) }

    before(:example) do
      allow(BuildEval::Http).to receive(:get).and_return(response)
      allow(BuildEval::Server::CruiseControlResponse).to receive(:new).and_return(cruise_control_response)
      allow(cruise_control_response).to receive(:parse_result).and_return(build_result)
    end

    it "issues a get request for the build" do
      expected_uri = "https://api.travis-ci.org/repositories/#{username}/#{build_name}/cc.xml"
      expect(BuildEval::Http).to receive(:get).with(expected_uri)

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

    subject { travis.to_s }

    it "returns a string indicating it uses the Travis CI service" do
      expect(subject).to include("Travis CI")
    end

    it "returns a string containing the username" do
      expect(subject).to include(username)
    end

  end

end
