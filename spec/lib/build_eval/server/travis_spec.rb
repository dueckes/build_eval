describe BuildEval::Server::Travis do
  include_context "stubbed Travis API interactions"

  let(:username)         { "some_username" }
  let(:constructor_args) { { username: username } }

  let(:travis_server) { described_class.new(constructor_args) }

  describe "#build_result" do

    let(:build_name)        { "some_build_name" }
    let(:last_build_status) { "Failure" }
    let(:travis)            { instance_double(BuildEval::Travis, last_build_status_for: last_build_status) }
    let(:build_result)      { instance_double(BuildEval::Result::BuildResult) }

    subject { travis_server.build_result(build_name) }

    before(:example) do
      allow(BuildEval::Travis).to receive(:new).and_return(travis)
      allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)
    end

    it "creates a Travis API wrapping the Standard module" do
      expect(BuildEval::Travis).to receive(:new).with(::Travis)

      subject
    end

    it "retrieves the last build status for the GitHub repository" do
      expect(travis).to receive(:last_build_status_for).with("#{username}/#{build_name}")

      subject
    end

    it "creates a build result whose build name is the path to the GitHub repository" do
      expect(BuildEval::Result::BuildResult).to(
        receive(:create).with(hash_including(build_name: "#{username}/#{build_name}"))
      )

      subject
    end

    it "creates a build result whose status is the status the last build status" do
      expect(BuildEval::Result::BuildResult).to(
        receive(:create).with(hash_including(status_name: last_build_status))
      )

      subject
    end

    it "returns the build result" do
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
