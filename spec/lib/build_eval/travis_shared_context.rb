shared_context "stubbed Travis API interactions" do

  let(:travis_namespace) { instance_double(::Travis::Client::Namespace) }

  before(:each) { allow(::Travis::Client::Namespace).to receive(:new).and_return(travis_namespace) }

end
