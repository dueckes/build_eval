describe BuildEval::Result::ServerResult do

  let(:server)        { double("BuildEval::Server") }
  let(:build_results) { (1..3).map { instance_double(BuildEval::Result::BuildResult) } }

  let(:server_result) { described_class.new(server, build_results) }

  describe "#status" do

    let(:statuses) { build_results.map { instance_double(BuildEval::Result::Status) } }

    subject { server_result.status }

    before(:example) do
      build_results.zip(statuses).each do |build_result, status|
        allow(build_result).to receive(:status).and_return(status)
      end
    end

    it "determines the effective status of the build results" do
      expect(BuildEval::Result::Status).to receive(:effective_status).with(statuses)

      subject
    end

    it "returns the effective status" do
      status = instance_double(BuildEval::Result::Status)
      allow(BuildEval::Result::Status).to receive(:effective_status).and_return(status)

      expect(subject).to be(status)
    end

  end

  describe "#unsuccessful" do

    subject { server_result.unsuccessful }

    before(:example) do
      build_results.each do |build_result|
        allow(build_result).to receive(:unsuccessful?).and_return(unsuccessful_results.include?(build_result))
      end
    end

    context "when some build results are unsuccessful" do

      let(:unsuccessful_results) { [ build_results[0], build_results[2] ] }

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

    let(:server_string_representation)  { "Server description" }
    let(:result_string_representations) { build_results.each_with_index.map { |_, i| "Build result ##{i}" } }

    subject { server_result.to_s }

    before(:example) { allow(server).to receive(:to_s).and_return(server_string_representation) }

    before(:example) do
      build_results.zip(result_string_representations).each do |build_result, string|
        allow(build_result).to receive(:to_s).and_return(string)
      end
    end

    it "contains the string representation of the server" do
      expect(subject).to include(server_string_representation)
    end

    it "contains the string representation of each result" do
      result_string_representations.each { |string| expect(subject).to include(string) }
    end

  end

end
