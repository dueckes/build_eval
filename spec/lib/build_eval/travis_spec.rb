describe BuildEval::Travis do

  describe "::last_build_status" do

    let(:repository_path) { "some/repository_path" }
    let(:optional_args)   { {} }

    let(:recent_builds)                   do
      (1..3).map { |i| instance_double(::Travis::Client::Build, finished?: i > 1) }
    end
    let(:last_finished_build)             { recent_builds[1] }
    let(:last_finished_build_passed_flag) { true }
    let(:travis_repository)               do
      instance_double(::Travis::Client::Repository, recent_builds: recent_builds)
    end
    let(:travis_session)                  { instance_double(::Travis::Client::Session, repo: travis_repository) }

    subject { described_class.last_build_status({ repository_path: repository_path }.merge(optional_args)) }

    before(:example) do
      allow(BuildEval::Travis::SessionFactory).to receive(:create).and_return(travis_session)
      allow(last_finished_build).to receive(:passed?).and_return(last_finished_build_passed_flag)
    end

    context "when a Github authentication token is provided" do

      let(:github_token)  { "SOMEGITHUBAUTHTOKEN" }
      let(:optional_args) { { github_token: github_token } }

      it "creates a Travis session using the token" do
        expect(BuildEval::Travis::SessionFactory).to receive(:create).with(github_token)

        subject
      end

    end

    context "when a Github authentication token is not provided" do

      let(:optional_args) { {} }

      it "creates a Travis session for a nil token" do
        expect(BuildEval::Travis::SessionFactory).to receive(:create).with(nil)

        subject
      end

    end


    it "retrieves the Travis repository for the provided repository path from the session" do
      expect(travis_session).to receive(:repo).with(repository_path)

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

    context "when an error occurs obtaining a session" do

      before(:example) do
        allow(BuildEval::Travis::SessionFactory).to(
          receive(:create).and_raise(::Travis::Client::Error.new("Forced error"))
        )
      end

      it "returns 'Unknown'" do
        expect(subject).to eql("Unknown")
      end

    end

    context "when an error occurs retrieving the recent builds" do

      before(:example) do
        allow(travis_repository).to receive(:recent_builds).and_raise(::Travis::Client::Error.new("Forced error"))
      end

      it "returns 'Unknown'" do
        expect(subject).to eql("Unknown")
      end

    end

  end

end
