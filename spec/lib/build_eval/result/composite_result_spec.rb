describe BuildEval::Result::CompositeResult do
  let(:results) { (1..2).map { double('BuildEval::Result') } }

  let(:composite_result) { described_class.new(results) }

  describe '#status' do
    let(:statuses) { results.map { instance_double(BuildEval::Result::Status) } }

    subject { composite_result.status }

    before(:example) do
      results.zip(statuses).each { |result, status| allow(result).to receive(:status).and_return(status) }
    end

    before(:example) { allow(BuildEval::Result::Status).to receive(:effective_status) }

    it 'determines the status of the results' do
      results.each { |underlying_array| expect(underlying_array).to receive(:status) }

      subject
    end

    it 'determines the effective status of the result statuses' do
      expect(BuildEval::Result::Status).to receive(:effective_status).with(statuses)

      subject
    end

    it 'returns the effective status' do
      effective_status = instance_double(BuildEval::Result::Status)
      allow(BuildEval::Result::Status).to receive(:effective_status).and_return(effective_status)

      expect(subject).to eql(effective_status)
    end
  end

  describe '#unsuccessful' do
    let(:unsuccessful_builds_array) { results.map { (1..3).map { instance_double(BuildEval::Result::BuildResult) } } }

    subject { composite_result.unsuccessful }

    before(:example) do
      results.zip(unsuccessful_builds_array).each do |result, unsuccessful_builds|
        allow(result).to receive(:unsuccessful).and_return(unsuccessful_builds)
      end
    end

    it 'determines the unsuccessful builds from the results' do
      results.each { |result| expect(result).to receive(:unsuccessful) }

      subject
    end

    it 'returns all unsuccessful builds' do
      expect(subject).to eql(unsuccessful_builds_array.flatten)
    end
  end

  describe '#to_s' do
    let(:results_string_representations) { (1..results.length).map { |i| "Result #{i}" } }

    subject { composite_result.to_s }

    before(:example) do
      results.zip(results_string_representations).each do |result, string_representation|
        allow(result).to receive(:to_s).and_return(string_representation)
      end
    end

    it 'returns a string containing the string representation of each result' do
      results_string_representations.each do |string_representation|
        expect(subject).to include(string_representation)
      end
    end
  end
end
