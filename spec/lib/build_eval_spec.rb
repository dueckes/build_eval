describe BuildEval do
  describe '::server' do
    class BuildEval::Server::TestableServer
      def initialize(_args)
        # Intentionally blank
      end
    end

    let(:server_type)      { :TestableServer }
    let(:server_arguments) { { key1: 'value1', key2: 'value2', key3: 'value3' } }
    let(:args)             { { type: server_type }.merge(server_arguments) }

    subject { described_class.server(args) }

    it 'constructs an instance of the server with the provided type' do
      expect(BuildEval::Server::TestableServer).to receive(:new)

      subject
    end

    it 'constructs the instance with additional arguments' do
      expect(BuildEval::Server::TestableServer).to receive(:new).with(server_arguments)

      subject
    end

    it 'decorates the server with standard server behaviour' do
      server = instance_double(BuildEval::Server::TestableServer)
      allow(BuildEval::Server::TestableServer).to receive(:new).and_return(server)
      expect(BuildEval::Server::Decorator).to receive(:new).with(server)

      subject
    end

    it 'returns the decorated server' do
      server_decorator = instance_double(BuildEval::Server::Decorator)
      allow(BuildEval::Server::Decorator).to receive(:new).and_return(server_decorator)

      expect(subject).to eql(server_decorator)
    end

    context 'when a server of the provided type is not found' do
      let(:server_type) { :invalid_type }

      it 'raises an error indicating the server type is invalid' do
        expect { subject }.to raise_error("Server type '#{server_type}' is invalid")
      end
    end
  end
end
