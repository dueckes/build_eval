describe BuildEval::Travis do
  include_context "stubbed Travis API interactions"

  describe "::last_build_status" do

    let(:build_path)    { "some/build_path" }
    let(:optional_args) { {} }

    let(:recent_builds)                   do
      (1..3).map { |i| instance_double(::Travis::Client::Build, finished?: i > 1) }
    end
    let(:last_finished_build)             { recent_builds[1] }
    let(:last_finished_build_passed_flag) { true }
    let(:travis_repository)               do
      instance_double(::Travis::Client::Repository, recent_builds: recent_builds)
    end

    subject { described_class.last_build_status({ build_path: build_path }.merge(optional_args)) }

    before(:example) do
      allow(::Travis::Repository).to receive(:find).and_return(travis_repository)
      allow(last_finished_build).to receive(:passed?).and_return(last_finished_build_passed_flag)
    end

    context "when a GitHub token is provided" do

      let(:github_token)  { "SOMEGITHUBAUTHTOKEN" }
      let(:optional_args) { { github_token: github_token } }

      it "logs-in to the Travis Pro API with the provided GitHub token" do
        expect(::Travis::Pro).to receive(:github_auth).with(github_token)

        subject
      end

      it "uses the Travis Pro modules Repository" do
        expect(::Travis::Pro::Repository).to receive(:find)

        subject
      end

      context "when a Travis Client error occurs on log-in" do

        before(:example) do
          allow(::Travis::Pro).to receive(:github_auth).and_raise(::Travis::Client::Error.new("Forced error"))
        end

        it "returns 'Unknown'" do
          expect(subject).to eql("Unknown")
        end

      end

    end

    context "when no GitHub token is provided" do

      let(:optional_args) { {} }

      it "uses the Travis modules Repository" do
        expect(::Travis::Repository).to receive(:find)

        subject
      end

    end

    it "retrieves the repository for the provided build path" do
      expect(::Travis::Repository).to receive(:find).with(build_path)

      subject
    end

    it "retrieves the recent builds from the repository" do
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
