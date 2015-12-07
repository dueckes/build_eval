describe BuildEval::Server::Jenkins do

  let(:uri)     { "https://some.jenkins.server" }
  let(:jenkins) { described_class.new(uri: uri) }

  describe "#build_result" do

    let(:build_name)              { "some_build_name" }
    let(:response)                { instance_double(Net::HTTPResponse) }
    let(:build_result)            { instance_double(BuildEval::Result::BuildResult) }
    let(:cruise_control_response) do
      instance_double(BuildEval::Server::CruiseControlResponse, parse_result: build_result)
    end

    subject { jenkins.build_result(build_name) }

    before(:example) do
      allow(BuildEval::Http).to receive(:get).and_return(response)
      allow(BuildEval::Server::CruiseControlResponse).to receive(:new).and_return(cruise_control_response)
      allow(cruise_control_response).to receive(:parse_result).and_return(build_result)
    end

    it "issues a GET request for the build" do
      expected_uri = "#{uri}/cc.xml"
      expect(BuildEval::Http).to receive(:get).with(expected_uri)

      subject
    end

    it "creates a Cruise Control response containing the GET request response" do
      expect(BuildEval::Server::CruiseControlResponse).to receive(:new).with(response)

      subject
    end

    it "parses the Cruise Control response to return the project with a matching build name" do
      expect(cruise_control_response).to receive(:parse_result).with(a_string_including(build_name))

      subject
    end

    it "returns the parsed build result" do
      expect(subject).to eql(build_result)
    end

  end

  describe "#to_s" do

    subject { jenkins.to_s }

    it "returns a string indicating it is a Jenkins server" do
      expect(subject).to include("Jenkins server")
    end

    it "returns a string containing the username" do
      expect(subject).to include(uri)
    end

  end

end
