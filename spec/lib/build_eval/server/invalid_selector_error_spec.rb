describe BuildEval::Server::InvalidSelectorError do
  let(:response_message) { 'Some response message' }
  let(:response)         { double('HttpResponse', message: response_message) }
  let(:selector)         { 'some/selector' }

  let(:error) { described_class.new(response, selector) }

  describe '#message' do
    subject { error.message }

    it 'indicates the selector was not matched' do
      expect(subject).to match(/response did not match selector/i)
    end

    it 'contains a message describing the response' do
      expect(subject).to include(response_message)
    end

    it 'contains the selector that was invalid' do
      expect(subject).to include(selector)
    end
  end
end
