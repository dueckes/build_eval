describe BuildEval::Server::CruiseControlResponse do
  let(:raw_response) { double('RawResponse', body: response_body) }

  let(:cruise_control_response) { described_class.new(raw_response) }

  describe '#parse_result' do
    let(:build_name)          { 'some_build_name' }
    let(:response_build_name) { build_name }
    let(:project_selector)    { '//Project[2]' }

    subject { cruise_control_response.parse_result(project_selector) }

    context 'when the response is successful, containing projects' do
      let(:latest_build_status) { 'Success' }
      let(:response_body) do
        <<-RESPONSE
          <Projects>
            <Project name="another_build_name" activity="Sleeping" lastBuildStatus="Unknown" lastBuildLabel="2" lastBuildTime="2015-08-02T00:00:00.000+0000" webUrl="https://my.build.server/another_build_name" />
            <Project name="#{response_build_name}" activity="Sleeping" lastBuildStatus="#{latest_build_status}" lastBuildLabel="1" lastBuildTime="2015-08-01T00:00:00.000+0000" webUrl="https://my.build.server/#{build_name}" />
            <Project name="yet_another_build_name" activity="Sleeping" lastBuildStatus="Error" lastBuildLabel="3" lastBuildTime="2015-08-03T00:00:00.000+0000" webUrl="https://my.build.server/yet_another_build_name" />
          </Projects>
        RESPONSE
      end

      context 'and the selector matches a project' do
        context 'and the build name in the response is not a path' do
          it 'creates a build result with the build name from the response' do
            expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(build_name: build_name))

            subject
          end
        end

        context 'and the build name in the response is a path' do
          let(:response_build_name) { "some/path/to/#{build_name}" }

          it 'creates a build result with the build name from the response with the path omitted' do
            expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(build_name: build_name))

            subject
          end
        end

        it 'creates a build result containing the latest build status' do
          expect(BuildEval::Result::BuildResult).to(
            receive(:create).with(hash_including(status_name: latest_build_status))
          )

          subject
        end

        it 'returns the created result' do
          build_result = instance_double(BuildEval::Result::BuildResult)
          allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)

          expect(subject).to eql(build_result)
        end
      end

      context 'and the selector does not match a project' do
        let(:project_selector) { 'does_not_match' }
        let(:error)            { 'an error' }

        before(:example) { allow(BuildEval::Server::InvalidSelectorError).to receive(:new).and_return(error) }

        it 'creates an invalid selector error' do
          expect(BuildEval::Server::InvalidSelectorError).to(
            receive(:new).with(raw_response, project_selector).and_return(error)
          )

          begin
            subject
          rescue
            Exception
          end
        end

        it 'raises the error' do
          expect { subject }.to raise_error(error)
        end
      end
    end

    context 'when the response is in error' do
      let(:response_body) { { 'file' => 'not found' }.to_json }
      let(:error)         { 'an error' }

      before(:example) { allow(BuildEval::Server::InvalidSelectorError).to receive(:new).and_return(error) }

      it 'creates an invalid selector error' do
        expect(BuildEval::Server::InvalidSelectorError).to(
          receive(:new).with(raw_response, project_selector).and_return(error)
        )

        begin
          subject
        rescue
          Exception
        end
      end

      it 'raises an invalid selector error' do
        expect { subject }.to raise_error(error)
      end
    end
  end
end
