describe BuildEval::Monitor::Server do
  let(:server)      { double('BuildEval::Server') }
  let(:build_names) { (1..3).map { |i| "build##{i}" } }

  let(:server_monitor) { described_class.new(server: server, build_names: build_names) }

  describe '#evaluate' do
    let(:results) { build_names.map { instance_double(BuildEval::Result::BuildResult) } }

    subject { server_monitor.evaluate }

    before(:example) { allow(server).to receive(:build_result).and_return(*results) }

    it 'determines build results for builds of interest' do
      build_names.each { |build_name| expect(server).to receive(:build_result).with(build_name) }

      subject
    end

    it 'composes a server result for the server' do
      expect(BuildEval::Result::ServerResult).to receive(:new).with(server, anything)

      subject
    end

    it 'composes a server result containing the results' do
      expect(BuildEval::Result::ServerResult).to receive(:new).with(anything, results)

      subject
    end

    it 'returns the server result' do
      server_result = instance_double(BuildEval::Result::ServerResult)
      expect(BuildEval::Result::ServerResult).to receive(:new).and_return(server_result)

      expect(subject).to eql(server_result)
    end
  end
end
