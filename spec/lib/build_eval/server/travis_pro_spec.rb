describe BuildEval::Server::TravisPro do
  include_context "stubbed http interactions"

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

    let(:build_name)                      { "some_build_name" }
    let(:travis_repository)               { instance_double(::Travis::Client::Repository) }
    let(:recent_builds)                   do
      (1..3).map { |i| instance_double(::Travis::Client::Build, finished?: i > 1) }
    end
    let(:last_finished_build)             { recent_builds[1] }
    let(:last_finished_build_passed_flag) { true }
    let(:build_result)                    { instance_double(BuildEval::Result::BuildResult) }

    subject { travis_pro_server.build_result(build_name) }

    before(:example) do
      allow(::Travis::Pro).to receive(:github_auth)
      allow(::Travis::Pro::Repository).to receive(:find).and_return(travis_repository)
      allow(travis_repository).to receive(:recent_builds).and_return(recent_builds)
      allow(last_finished_build).to receive(:passed?).and_return(last_finished_build_passed_flag)
      allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)
    end

    it "logs-in to Travis Pro using the provided GitHub token" do
      expect(::Travis::Pro).to receive(:github_auth).with(github_token)

      subject
    end

    it "retrieves the relevant Travis Pro Repository" do
      expect(::Travis::Pro::Repository).to receive(:find).with("#{username}/#{build_name}")

      subject
    end

    it "retrieves the recent builds from the Travis Repository" do
      expect(travis_repository).to receive(:recent_builds)

      subject
    end

    it "determines if the last finished build has passed" do
      expect(last_finished_build).to receive(:passed?)

      subject
    end

    it "creates a build result whose build name is the path to the GitHub repository" do
      expect(BuildEval::Result::BuildResult).to(
        receive(:create).with(hash_including(build_name: "#{username}/#{build_name}"))
      )

      subject
    end

    context "when the last finished build passed" do

      let(:last_finished_build_passed_flag) { true }

      it "creates a successful build result" do
        expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(status_name: "Success"))

        subject
      end

    end

    context "when the last finished build failed" do

      let(:last_finished_build_passed_flag) { false }

      it "creates a failed build result" do
        expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(status_name: "Failure"))

        subject
      end

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
