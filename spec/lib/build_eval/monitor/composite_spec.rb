describe BuildEval::Monitor::Composite do
  let(:monitors) { (1..2).map { double(BuildEval::Monitor::Base) } }

  let(:composite) { described_class.new(*monitors) }

  describe "#evaluate" do

    let(:results) { monitors.map { instance_double("BuildEval::Result") } }

    subject { composite.evaluate }

    before(:example) do
      monitors.zip(results) { |monitor, result| allow(monitor).to receive(:evaluate).and_return(result) }
    end

    it "delegates to the monitors" do
      monitors.each { |monitor| expect(monitor).to receive(:evaluate) }

      subject
    end

    it "creates a composite result containing the result of each monitor" do
      expect(BuildEval::Result::CompositeResult).to receive(:new).with(results)

      subject
    end

    it "returns the composite result" do
      composite_result = instance_double(BuildEval::Result::CompositeResult)
      allow(BuildEval::Result::CompositeResult).to receive(:new).and_return(composite_result)

      expect(subject).to eql(composite_result)
    end

  end

end
