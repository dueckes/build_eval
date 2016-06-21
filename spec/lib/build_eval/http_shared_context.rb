shared_context "stubbed http interactions" do

  let(:http) { instance_double(BuildEval::Http) }

  before(:example) { allow(BuildEval::Http).to receive(:new).and_return(http) }

end
