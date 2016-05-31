describe BuildEval::Error do
  let(:message) { 'some message' }

  let(:error) { described_class.new(message) }

  it 'is a standard error' do
    expect(error).to be_a(::StandardError)
  end

  describe '#messsage' do
    subject { error.message }

    it 'returns the provided message' do
      expect(subject).to eql(message)
    end
  end
end
