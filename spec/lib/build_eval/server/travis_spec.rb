describe BuildEval::Server::Travis do
  include_context "stubbed http interactions"

  let(:username)         { "some_username" }
  let(:constructor_args) { { username: username } }

  let(:travis_server) { described_class.new(constructor_args) }

  describe "#build_result" do

    let(:build_name)        { "some_build_name" }
    let(:travis_repository) { instance_double(Travis::Client::Repository) }
    let(:travis_build)      { instance_double(Travis::Client::Build) }
    let(:build_result)      { instance_double(BuildEval::Result::BuildResult) }

    subject { travis_server.build_result(build_name) }

    before(:example) do
      allow(Travis::Repository).to receive(:find).and_return(travis_repository)
      allow(travis_repository).to receive(:last_build).and_return(travis_build)
      allow(travis_build).to receive(:failed?).and_return(false)
      allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)
    end

    it "retrieves the relevant Travis repository" do
      expect(Travis::Repository).to receive(:find).with("#{username}/#{build_name}").and_return(travis_repository)

      subject
    end

    it "retrieves the last build on the Travis repository" do
      expect(travis_repository).to receive(:last_build).and_return(travis_build)

      subject
    end

    it "retrieves the build status from the build" do
      expect(travis_build).to receive(:failed?).and_return(false)

      subject
    end

    it "creates a build result" do
      expect(BuildEval::Result::BuildResult).to receive(:create).with(
        build_name:  "#{username}/#{build_name}",
        status_name: "Success"
      ).and_return(build_result)

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
