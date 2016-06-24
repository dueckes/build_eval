describe BuildEval::Travis::SessionFactory do

  describe "::create" do

    let(:github_token)   { nil }
    let(:travis_session) { instance_double(::Travis::Client::Session) }

    subject { create_session }

    before(:example) { allow(::Travis::Client::Session).to receive(:new).and_return(travis_session) }
    after(:example)  { described_class.clear_cache }

    shared_examples_for "a call creating a new session" do

      it "creates a Travis session with empty SSL settings to avoid using local security certificates" do
        expect(::Travis::Client::Session).to receive(:new).with(hash_including(ssl: {}))

        subject
      end

      it "returns the created session" do
        expect(subject).to eql(travis_session)
      end

    end

    context "when a session for the GitHub token has not been retrieved previously" do

      context "and a non-nil GitHub token is provided" do

        let(:github_token)  { "SOMEGITHUBAUTHTOKEN" }

        before(:example) { allow(travis_session).to receive(:github_auth) }

        it_behaves_like "a call creating a new session"

        it "creates a Travis session connecting to the Travis Pro site" do
          expect(::Travis::Client::Session).to receive(:new).with(hash_including(uri: ::Travis::Client::PRO_URI))

          subject
        end

        it "logs-in using the provided GitHub token via the session" do
          expect(travis_session).to receive(:github_auth).with(github_token)

          subject
        end

      end

      context "and a nil GitHub token is provided" do

        let(:github_token)  { nil }

        it_behaves_like "a call creating a new session"

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

    context "when a session for the GitHub token has been retrieved previously" do

      before(:example) do
        create_session

        allow(travis_session).to receive(:clear_cache)
      end

      it "does not create a new session" do
        expect(::Travis::Client::Session).to_not receive(:new)

        subject
      end

      it "clears the cache of the previously retrieved session to ensure no stale data is returned" do
        expect(travis_session).to receive(:clear_cache)

        subject
      end

      it "returns the previously retrieved session" do
        expect(subject).to eql(travis_session)
      end

    end

    def create_session
      described_class.create(github_token)
    end

  end

end
