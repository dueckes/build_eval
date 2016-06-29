describe BuildEval::Travis::Session do

  describe "::open" do

    let(:github_token) { "SOMEGITHIBTOKEN" }
    let(:block)        { lambda { |_session| "Some block" } }

    let(:session) { instance_double(BuildEval::Travis::Session::Session) }

    subject { described_class.open(github_token, &block) }

    before(:example) do
      allow(BuildEval::Travis::Session::Pool).to receive(:get).and_return(session)
      allow(BuildEval::Travis::Session::Pool).to receive(:release)
    end

    it "obtains a session for the provided GitHib token from the pool" do
      expect(BuildEval::Travis::Session::Pool).to receive(:get).with(github_token)

      subject
    end

    it "yields the session to the provided block" do
      expect { |block| described_class.open(github_token, &block) }.to yield_with_args(session)

      subject
    end

    context "when an error is raised on yield" do

      let(:error) { RuntimeError.new("Forced error") }

      let(:block) { lambda { |_session| raise error } }

      it "returns the session to the pool" do
        expect(BuildEval::Travis::Session::Pool).to receive(:release).with(session)

        subject rescue nil
      end

      it "propogates the error" do
        expect { subject }.to raise_error(error)
      end

    end

    context "when an error is not raised on yield" do

      let(:block) { lambda { |_session| "Block result" } }

      it "returns the session to the pool" do
        expect(BuildEval::Travis::Session::Pool).to receive(:release).with(session)

        subject
      end

      it "returns the last expression from the block" do
        expect(subject).to eql("Block result")
      end

    end

  end

end
