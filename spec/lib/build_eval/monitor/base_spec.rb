describe BuildEval::Monitor::Base do

  class BuildEval::Monitor::TestableBase < BuildEval::Monitor::Base
  end

  let(:base_monitor) { BuildEval::Monitor::TestableBase.new }

  describe "#+" do

    let(:provided_monitor) { instance_double(BuildEval::Monitor::Base) }

    subject { base_monitor + provided_monitor }

    it "creates a composite monitor combining the monitor with the provided monitor" do
      expect(BuildEval::Monitor::Composite).to receive(:new).with(base_monitor, provided_monitor)

      subject
    end

    it "returns the composite monitor" do
      composite_monitor = instance_double(BuildEval::Monitor::Composite)
      allow(BuildEval::Monitor::Composite).to receive(:new).and_return(composite_monitor)

      expect(subject).to eql(composite_monitor)
    end

  end

end
