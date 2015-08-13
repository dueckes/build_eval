describe BuildEval::Status do

  describe "::find" do

    subject { described_class.find(name) }

    context "when the name exactly matches a status constant name" do

      let(:name) { "UNKNOWN" }

      it "returns the constant" do
        expect(subject).to be(BuildEval::Status::UNKNOWN)
      end

    end

    context "when the name is completely different from a status constant name" do

      let(:name) { "does_not_match" }

      it "raises an error indicating the name is invalid" do
        expect { subject }.to raise_error("Build status '#{name}' is invalid")
      end

    end

  end

  describe "::effective_status" do

    subject { described_class.effective_status(statuses) }

    context "when a single status is provided" do

      let(:statuses) { [ BuildEval::Status::UNKNOWN ] }

      it "returns the status" do
        expect(subject).to eql(BuildEval::Status::UNKNOWN)
      end

    end

    context "when the statuses are ordered in descending severity" do

      let(:statuses) { [ BuildEval::Status::FAILURE, BuildEval::Status::UNKNOWN, BuildEval::Status::SUCCESS ] }

      it "returns the most severe status" do
        expect(subject).to eql(BuildEval::Status::FAILURE)
      end

    end

    context "when the statuses are ordered in ascending severity" do

      let(:statuses) { [ BuildEval::Status::SUCCESS, BuildEval::Status::UNKNOWN, BuildEval::Status::FAILURE ] }

      it "returns the most severe status" do
        expect(subject).to eql(BuildEval::Status::FAILURE)
      end

    end

  end

  describe "#unsuccessful?" do

    subject { status.unsuccessful? }

    context "when the status is SUCCESS" do

      let(:status) { BuildEval::Status::SUCCESS }

      it "returns false" do
        expect(subject).to be(false)
      end

    end

    {
      "FAILURE" => BuildEval::Status::FAILURE,
      "UNKNOWN" => BuildEval::Status::UNKNOWN
    }.each do |name, status|

      context "when the status is #{name}" do

        let(:status) { status }

        it "returns true" do
          expect(subject).to be(true)
        end

      end

    end

  end

  describe "#to_sym" do

    subject { status.to_sym }

    { SUCCESS: :success!, FAILURE: :failed!, UNKNOWN: :warning! }.each do |name, expected_symbol|

      context "when the status is #{name}" do

        let(:status) { BuildEval::Status.const_get(name) }

        it "returns success!" do
          expect(subject).to eql(expected_symbol)
        end

      end

    end

  end

  describe "#to_s" do

    subject { status.to_s }

    { SUCCESS: "succeeded", FAILURE: "failed", UNKNOWN: "unknown" }.each do |name, expected_string|

      context "when the status is #{name}" do

        let(:status) { BuildEval::Status.const_get(name) }

        it "returns success!" do
          expect(subject).to eql(expected_string)
        end

      end

    end

  end

end
