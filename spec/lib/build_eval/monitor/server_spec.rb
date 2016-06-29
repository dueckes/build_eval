describe BuildEval::Monitor::Server do

  let(:server)               { double("BuildEval::Server") }
  let(:build_configurations) { %w{ build#1 build#2:branch#1 build#2:branch#2 build#3 } }

  let(:server_monitor) { described_class.new(server: server, build_configurations: build_configurations) }

  describe "#evaluate" do

    let(:results) { build_configurations.map { instance_double(BuildEval::Result::BuildResult) } }

    subject { server_monitor.evaluate }

    before(:example) { allow(server).to receive(:build_result).and_return(*results) }

    it "determines build results for builds with branches" do
      [ [ "build#2", "branch#1" ], ["build#2", "branch#2" ] ].each do |build_name, branch_name|
        expect(server).to receive(:build_result).with(build_name, branch_name)
      end

      subject
    end

    it "determines build results for builds without branches" do
      %w{ build#1 build#3 }.each { |build_name| expect(server).to receive(:build_result).with(build_name, nil) }

      subject
    end

    it "composes a server result for the server" do
      expect(BuildEval::Result::ServerResult).to receive(:new).with(server, anything)

      subject
    end

    it "composes a server result containing the results" do
      expect(BuildEval::Result::ServerResult).to receive(:new).with(anything, results)

      subject
    end

    it "returns the server result" do
      server_result = instance_double(BuildEval::Result::ServerResult)
      expect(BuildEval::Result::ServerResult).to receive(:new).and_return(server_result)

      expect(subject).to eql(server_result)
    end

  end

end
