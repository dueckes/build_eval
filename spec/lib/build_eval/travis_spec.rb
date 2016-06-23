describe BuildEval::Travis do
  include_context "stubbed Travis API interactions"

  let(:travis_module) { ::Travis }

  let(:travis) { described_class.new(travis_module) }

  describe "#login" do

    let(:github_token) { "SOMEGITHUBTOKEN" }

    subject { travis.login(github_token) }

    it "logs-in to Travis using the GitHub Auth token provided" do
      expect(travis_module).to receive(:github_auth).with(github_token)

      subject
    end

  end

  describe "#last_build_status_for" do

    let(:build_path) { "some/build_path" }

    let(:recent_builds)                   do
      (1..3).map { |i| instance_double(::Travis::Client::Build, finished?: i > 1) }
    end
    let(:last_finished_build)             { recent_builds[1] }
    let(:last_finished_build_passed_flag) { true }
    let(:travis_repository)               do
      instance_double(::Travis::Client::Repository, recent_builds: recent_builds)
    end

    subject { travis.last_build_status_for(build_path) }

    before(:example) do
      allow(travis_module::Repository).to receive(:find).and_return(travis_repository)
      allow(last_finished_build).to receive(:passed?).and_return(last_finished_build_passed_flag)
    end

    it "retrieves the Travis Repository for the provided build path" do
      expect(travis_module::Repository).to receive(:find).with(build_path)

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

    context "when the last finished build passed" do

      let(:last_finished_build_passed_flag) { true }

      it "returns 'Success'" do
        expect(subject).to eql("Success")
      end

    end

    context "when the last finished build failed" do

      let(:last_finished_build_passed_flag) { false }

      it "returns 'Failure'" do
        expect(subject).to eql("Failure")
      end

    end

    context "when an Travis Client error occurs" do

      before(:example) do
        allow(travis_repository).to receive(:recent_builds).and_raise(::Travis::Client::Error.new("Forced error"))
      end

      it "returns 'Unknown'" do
        expect(subject).to eql("Unknown")
      end

    end

  end

end
