describe BuildEval::BuildResults do

  let(:results) { (1..3).map { instance_double(BuildEval::BuildResult) } }

  let(:build_results) { described_class.new(results) }

  describe "#status" do

    let(:statuses) { results.map { instance_double(BuildEval::Status) } }

    subject { build_results.status }

    before(:example) do
      results.zip(statuses).each { |result, status| allow(result).to receive(:status).and_return(status) }
    end

    it "determines the effective status of the build results" do
      expect(BuildEval::Status).to receive(:effective_status).with(statuses)

      subject
    end

    it "returns the effective status" do
      status = instance_double(BuildEval::Status)
      allow(BuildEval::Status).to receive(:effective_status).and_return(status)

      expect(subject).to be(status)
    end

  end

  describe "#unsuccessful" do

    subject { build_results.unsuccessful }

    before(:example) do
      results.each do |build_result|
        allow(build_result).to receive(:unsuccessful?).and_return(unsuccessful_results.include?(build_result))
      end
    end

    context "when some build results are unsuccessful" do

      let(:unsuccessful_results) { [ results[0], results[2] ] }

      it "returns the unsuccessful build results" do
        expect(subject).to eql(unsuccessful_results)
      end

    end

    context "when no build results are unsuccessful" do

      let(:unsuccessful_results) { [] }

      it "returns an empty array" do
        expect(subject).to eql([])
      end

    end

  end

  describe "#to_s" do

    let(:result_string_representations) { results.each_with_index.map { |_, i| "Result description ##{i}" } }

    subject { build_results.to_s }

    before(:example) do
      results.zip(result_string_representations).each do |build_result, string|
        allow(build_result).to receive(:to_s).and_return(string)
      end
    end

    it "contains the string representation of each result" do
      result_string_representations.each { |string| expect(subject).to include(string) }
    end

  end

end
