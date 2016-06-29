describe BuildEval::Travis do

  describe "::last_build_status" do

    let(:repository_path) { "some/repository_path" }
    let(:branch)          { nil }
    let(:optional_args)   { {} }
    let(:args)            { { repository_path: repository_path, branch: branch }.merge(optional_args) }

    let(:build_color)       { "red" }
    let(:build)             { instance_double(::Travis::Client::Build, color: build_color) }
    let(:travis_repository) { instance_double(::Travis::Client::Repository, last_build: build) }
    let(:travis_session)    { instance_double(::Travis::Client::Session, repo: travis_repository) }

    subject { described_class.last_build_status(args) }

    before(:example) { allow(BuildEval::Travis::Session).to receive(:open).and_yield(travis_session) }

    shared_examples_for "a Travis build whose status is determined" do

      {
        "green"  => "Success",
        "yellow" => "Building",
        "red"    => "Failure"
      }.each do |color, status|

        context "when the builds color is #{color}" do

          let(:build_color) { color }

          it "returns '#{status}'" do
            expect(subject).to eql(status)
          end

        end

      end

    end

    context "when a Github authentication token is provided" do

      let(:github_token)  { "SOMEGITHUBAUTHTOKEN" }
      let(:optional_args) { { github_token: github_token } }

      it "opens a Travis session using the token" do
        expect(BuildEval::Travis::Session).to receive(:open).with(github_token)

        subject
      end

    end

    context "when a Github authentication token is not provided" do

      let(:optional_args) { {} }

      it "opens a Travis session for a nil token" do
        expect(BuildEval::Travis::Session).to receive(:open).with(nil)

        subject
      end

    end

    context "when an error occurs opening a session" do

      before(:example) do
        allow(BuildEval::Travis::Session).to(
          receive(:open).and_raise(::Travis::Client::Error.new("Forced error"))
        )
      end

      it "returns 'Unknown'" do
        expect(subject).to eql("Unknown")
      end

    end

    it "retrieves the Travis repository for the provided repository path from the session" do
      expect(travis_session).to receive(:repo).with(repository_path)

      subject
    end

    context "when a branch is provided" do

      let(:branch) { "some_branch" }

      before(:example) { allow(travis_repository).to receive(:branch).and_return(build) }

      it_behaves_like "a Travis build whose status is determined"

      it "retrieves the last build for the branch" do
        expect(travis_repository).to receive(:branch).with(branch)

        subject
      end

      context "when an error occurs retrieving the last build" do

        before(:example) do
          allow(travis_repository).to receive(:branch).and_raise(::Travis::Client::Error.new("Forced error"))
        end

        it "returns 'Unknown'" do
          expect(subject).to eql("Unknown")
        end

      end

    end

    context "when a branch is not provided" do

      let(:branch) { nil }

      it_behaves_like "a Travis build whose status is determined"

      it "retrieves the last build repository" do
        expect(travis_repository).to receive(:last_build)

        subject
      end

      context "when an error occurs retrieving the last build" do

        before(:example) do
          allow(travis_repository).to receive(:last_build).and_raise(::Travis::Client::Error.new("Forced error"))
        end

        it "returns 'Unknown'" do
          expect(subject).to eql("Unknown")
        end

      end

    end

  end

end
