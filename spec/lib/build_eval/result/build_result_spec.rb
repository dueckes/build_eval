describe BuildEval::Result::BuildResult do

  describe "::create" do

    let(:build_name)  { "Some build name" }
    let(:status_name) { "SUCCESS" }

    subject { described_class.create(build_name: build_name, status_name: status_name) }

    it "returns a result with the provided build name" do
      expect(subject.build_name).to eql(build_name)

    end

    it "determines the status with the provided status name" do
      expect(BuildEval::Result::Status).to receive(:find).with(status_name)

      subject
    end

    it "returns a result with the determined status" do
      status = BuildEval::Result::Status::UNKNOWN
      allow(BuildEval::Result::Status).to receive(:find).and_return(status)

      expect(subject.status).to eql(status)
    end

  end

  describe "::indeterminate" do

    let(:build_name) { "Some build name" }

    subject { described_class.indeterminate(build_name) }

    it "returns a result with the provided build name" do
      expect(subject.build_name).to eql(build_name)
    end

    it "returns a result with an indeterminate status" do
      expect(subject.status).to eql(BuildEval::Result::Status::INDETERMINATE)
    end

  end

  describe "#unsuccessful?" do

    let(:status)       { instance_double(BuildEval::Result::Status) }
    let(:build_result) { described_class.create(build_name: "some build", status_name: "some status") }

    subject { build_result.unsuccessful? }

    before(:example) { allow(BuildEval::Result::Status).to receive(:find).and_return(status) }

    it "delegates to the underlying status" do
      allow(status).to receive(:unsuccessful?).and_return(true)

      expect(subject).to be(true)
    end

  end

  describe "#to_s" do

    let(:build_name)                   { "Some build name" }
    let(:status_string_representation) { "SUCCESS" }
    let(:status)                       { instance_double(BuildEval::Result::Status, to_s: status_string_representation) }

    let(:build_result) { described_class.create(build_name: build_name, status_name: "some status") }

    subject { build_result.to_s }

    before(:example) { allow(BuildEval::Result::Status).to receive(:find).and_return(status) }

    it "contains the name of the build" do
      expect(subject).to include(build_name)
    end

    it "contains the string representation of the status" do
      expect(subject).to include(status_string_representation)
    end

  end

end
