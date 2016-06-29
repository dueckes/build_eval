describe BuildEval::Server::Decorator do

  let(:server) { double("BuildEval::Server::Server") }

  let(:decorator) { described_class.new(server) }

  describe "#build_result" do

    let(:build_name)  { "some build name" }
    let(:branch_name) { "some branch name" }

    subject { decorator.build_result(build_name, branch_name) }

    it "delegates to the decorated server" do
      expect(server).to receive(:build_result).with(build_name, branch_name)

      subject
    end

    context "when the decorated server returns a result" do

      let(:build_result) { instance_double(BuildEval::Result::BuildResult) }

      before(:example) { allow(server).to receive(:build_result).and_return(build_result) }

      it "returns the result" do
        expect(subject).to eql(build_result)
      end

    end

    context "when the decorated server raises an error" do

      before(:example) { allow(server).to receive(:build_result).and_raise("Forced error") }

      it "creates an indeterminate result" do
        expect(BuildEval::Result::BuildResult).to(
          receive(:indeterminate).with(build_name: build_name, branch_name: branch_name)
        )

        subject
      end

      it "returns the indeterminate result" do
        indeterminate_result = instance_double(BuildEval::Result::BuildResult)
        allow(BuildEval::Result::BuildResult).to receive(:indeterminate).and_return(indeterminate_result)

        expect(subject).to eql(indeterminate_result)
      end

    end

  end

  describe "#monitor" do

    let(:build_configurations) { (1..3).map { |i| "monitor##{i}" } }

    subject { decorator.monitor(*build_configurations) }

    it "creates a server monitor for the decorated server" do
      expect(BuildEval::Monitor::Server).to receive(:new).with(hash_including(server: server))

      subject
    end

    it "returns the server monitor" do
      monitor = instance_double(BuildEval::Monitor::Server)
      allow(BuildEval::Monitor::Server).to receive(:new).and_return(monitor)

      expect(subject).to eql(monitor)
    end

    context "when an array of build configurations is provided" do

      subject { decorator.monitor(build_configurations) }

      it "creates a server monitor for the provided build configurations" do
        expect(BuildEval::Monitor::Server).to(
          receive(:new).with(hash_including(build_configurations: build_configurations))
        )

        subject
      end

    end

    context "when variable argument list build configurations is provided" do

      subject { decorator.monitor(*build_configurations) }

      it "creates a server monitor for the provided build configurations" do
        expect(BuildEval::Monitor::Server).to(
          receive(:new).with(hash_including(build_configurations: build_configurations))
        )

        subject
      end

    end

  end

end
