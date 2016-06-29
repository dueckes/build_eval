describe BuildEval::Travis::Session::Factory do

  describe "::create" do

    let(:github_token)   { nil }
    let(:travis_session) { instance_double(::Travis::Client::Session) }

    subject { described_class.create(github_token) }

    before(:example) { allow(::Travis::Client::Session).to receive(:new).and_return(travis_session) }

    shared_examples_for "a factory method creating a new session" do

      it "creates a Travis session with empty SSL settings to avoid using local security certificates" do
        expect(::Travis::Client::Session).to receive(:new).with(hash_including(ssl: {}))

        subject
      end

      it "creates a BuildEval session with the Travis session" do
        expect(BuildEval::Travis::Session::Session).to receive(:new).with(travis_session, anything)

        subject
      end

      it "creates a BuildEval session with the GitHub token" do
        expect(BuildEval::Travis::Session::Session).to receive(:new).with(anything, github_token)

        subject
      end

      it "returns the BuildEval session" do
        build_eval_session = instance_double(BuildEval::Travis::Session::Session)
        allow(BuildEval::Travis::Session::Session).to receive(:new).and_return(build_eval_session)

        expect(subject).to equal(build_eval_session)
      end

    end

    context "when a non-nil GitHub token is provided" do

      let(:github_token)  { "SOMEGITHUBAUTHTOKEN" }

      before(:example) { allow(travis_session).to receive(:github_auth) }

      it_behaves_like "a factory method creating a new session"

      it "creates a Travis session connecting to the Travis Pro site" do
        expect(::Travis::Client::Session).to receive(:new).with(hash_including(uri: ::Travis::Client::PRO_URI))

        subject
      end

      it "logs-in using the provided GitHub token via the session" do
        expect(travis_session).to receive(:github_auth).with(github_token)

        subject
      end

    end

    context "when a nil GitHub token is provided" do

      let(:github_token)  { nil }

      it_behaves_like "a factory method creating a new session"

      it "creates a Travis session connecting to the Travis Org site" do
        expect(::Travis::Client::Session).to receive(:new).with(hash_including(uri: ::Travis::Client::ORG_URI))

        subject
      end

      it "does not log-in" do
        expect(travis_session).to_not receive(:github_auth)

        subject
      end

    end

  end

end
