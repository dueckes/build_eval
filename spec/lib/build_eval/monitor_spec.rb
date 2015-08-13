describe BuildEval::Monitor do

  let(:server)      { double("BuildEval::CIServer") }
  let(:build_names) { (1..3).map { |i| "build##{i}" } }

  let(:monitor) { described_class.new(server: server, build_names: build_names) }

  describe "#evaluate" do

    let(:results) { build_names.map { instance_double(BuildEval::BuildResult) } }

    subject { monitor.evaluate }

    before(:example) { allow(server).to receive(:build_result).and_return(*results) }

    it "determines build results for builds of interest" do
      build_names.each { |build_name| expect(server).to receive(:build_result).with(build_name) }

      subject
    end

    it "composes a build results object containing the results" do
      expect(BuildEval::BuildResults).to receive(:new).with(results)

      subject
    end

    it "returns the build results object" do
      build_results = instance_double(BuildEval::BuildResults)
      expect(BuildEval::BuildResults).to receive(:new).and_return(build_results)

      expect(subject).to eql(build_results)
    end

  end

end
