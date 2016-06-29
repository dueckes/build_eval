describe BuildEval::Travis::Session::Session do

  let(:travis_session) { ::Travis::Client::Session.new(uri: "some/uri", ssl: {}) }
  let(:github_token)   { "SOMEGITHUBAUTHTOKEN" }

  let(:session) { described_class.new(travis_session, github_token) }

  describe "#github_token" do

    subject { session.github_token }

    it "returns the provided token" do
      expect(subject).to eql(github_token)
    end

  end

  it "delegates all other methods to the provided Travis session" do
    expect(travis_session).to receive(:clear_cache)

    session.clear_cache
  end

end
