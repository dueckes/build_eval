describe BuildEval::Server::TravisPro do
  include_context "stubbed Travis API interactions"

  let(:username)     { "some_username" }
  let(:github_token) { "ABCD1234" }
  let(:constructor_args) do
    {
      username:     username,
      github_token: github_token
    }
  end

  let(:travis_pro_server) { described_class.new(constructor_args) }

  describe "#build_result" do

    let(:build_name)        { "some_build_name" }
    let(:last_build_status) { "Unknown" }
    let(:build_result)      { instance_double(BuildEval::Result::BuildResult) }

    subject { travis_pro_server.build_result(build_name) }

    before(:example) do
      allow(BuildEval::Travis).to receive(:last_build_status).and_return(last_build_status)
      allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)
    end

    it "retrieves the last build status from Travis using the provided GitHub token" do
      expect(BuildEval::Travis).to(
        receive(:last_build_status).with(hash_including(github_token: github_token))
      )

      subject
    end

    it "retrieves the last build status from Travis for the users build" do
      expect(BuildEval::Travis).to(
        receive(:last_build_status).with(hash_including(build_path: "#{username}/#{build_name}"))
      )

      subject
    end

    it "creates a build result whose build name is the path to users build" do
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

    subject { travis_pro_server.to_s }

    it "returns a string indicating it uses the Travis Pro service" do
      expect(subject).to include("Travis CI Pro")
    end

    it "returns a string containing the username" do
      expect(subject).to include(username)
    end

  end

end
