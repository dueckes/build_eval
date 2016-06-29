describe BuildEval::Travis::Session::Pool do

  let(:github_token) { "SOMEGITHUBAUTHTOKEN" }

  let(:session) { instance_double(BuildEval::Travis::Session::Session, github_token: github_token, clear_cache: nil) }

  before(:example) { allow(BuildEval::Travis::Session::Factory).to receive(:create).and_return(session) }
  after(:example)  { described_class.clear }

  describe "::get" do

    subject { get_session }

    context "when a session for the GitHub token has not been retrieved previously" do

      it "creates a session for the token" do
        expect(BuildEval::Travis::Session::Factory).to receive(:create).with(github_token)

        subject
      end

      it "returns the session" do
        expect(subject).to eql(session)
      end

    end

    context "when a session for the GitHub token has been retrieved and released" do

      before(:example) do
        get_session
        release_session
      end

      it "does not create a new session" do
        expect(BuildEval::Travis::Session::Factory).to_not receive(:create)

        subject
      end

      it "returns the previously created session" do
        expect(subject).to eql(session)
      end

    end

    context "when a session for the GitHub token has been retrieved but not released" do

      let(:new_session) { instance_double(BuildEval::Travis::Session::Session) }

      before(:example) { get_session }

      it "creates a session for the token" do
        expect(BuildEval::Travis::Session::Factory).to receive(:create).with(github_token)

        subject
      end

      it "returns the newly created session" do
        allow(BuildEval::Travis::Session::Factory).to receive(:create).and_return(new_session)

        expect(subject).to eql(new_session)
      end

    end

  end

  describe "::release" do

    subject { release_session }

    it "clears the sessions cache" do
      expect(session).to receive(:clear_cache)

      subject
    end

  end

  def release_session
    described_class.release(session)
  end

  def get_session
    described_class.get(github_token)
  end

end
