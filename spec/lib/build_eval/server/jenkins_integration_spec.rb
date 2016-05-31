describe BuildEval::Server::Jenkins, 'integrating with a response parser', integration: true do
  include_context 'stubbed http interactions'

  let(:uri) { 'https://some.jenkins.server' }

  let(:jenkins) { described_class.new(uri: uri) }

  describe '#build_result' do
    let(:build_name) { 'some_build_name' }
    let(:response)   { instance_double(Net::HTTPResponse, body: response_body) }

    subject { jenkins.build_result(build_name) }

    before(:example) { allow(http).to receive(:get).and_return(response) }

    context 'when the server responds successfully with build results' do
      let(:latest_build_status) { 'Failure' }
      let(:response_body) do
        <<-RESPONSE
         <Projects>
          <Project webUrl="#{uri}/job/#{build_name}/" name="#{build_name}" lastBuildLabel="190" lastBuildTime="2015-10-09T02:39:36Z" lastBuildStatus="#{latest_build_status}" activity="Sleeping"/>
          <Project webUrl="#{uri}/job/another_build_name/" name="another_build_name" lastBuildLabel="71" lastBuildTime="2015-10-12T17:07:00Z" lastBuildStatus="Success" activity="Sleeping"/>
          <Project webUrl="#{uri}/job/yet_another_build_name/" name="yet_another_build_name" lastBuildLabel="15" lastBuildTime="2015-10-13T01:40:32Z" lastBuildStatus="Success" activity="Sleeping"/>
         </Projects>
        RESPONSE
      end

      it 'creates a build result containing the build name' do
        expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(build_name: build_name))

        subject
      end

      it 'creates a build result containing the latest build status' do
        expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(status_name: latest_build_status))
        subject
      end

      it 'returns the created result' do
        build_result = instance_double(BuildEval::Result::BuildResult)
        allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)

        expect(subject).to eql(build_result)
      end
    end
  end
end
