describe BuildEval::Server::Travis, "integrating with the response parser", integration: true do

  let(:username) { "some_username" }

  let(:travis) { described_class.new(username: username) }

  describe "#build_result" do

    let(:build_name) { "some_build_name" }
    let(:response)   { instance_double(Net::HTTPResponse, body: response_body) }

    subject { travis.build_result(build_name) }

    before(:example) { allow(BuildEval::Http).to receive(:get).and_return(response) }

    context "when the server responds successfully with build results" do

      let(:latest_build_status) { "Success" }
      let(:response_body)       do
        <<-RESPONSE
          <Projects>
            <Project name="#{username}/#{build_name}" activity="Sleeping" lastBuildStatus="#{latest_build_status}" lastBuildLabel="2" lastBuildTime="2015-08-13T08:31:27.000+0000" webUrl="https://travis-ci.org/#{username}/#{build_name}" />
          </Projects>
        RESPONSE
      end

      it "creates a build result containing the build name" do
        expect(BuildEval::Result::BuildResult).to receive(:create).with(hash_including(build_name: build_name))

        subject
      end

      it "creates a build result containing the latest build status" do
        expect(BuildEval::Result::BuildResult).to(
          receive(:create).with(hash_including(status_name: latest_build_status))
        )

        subject
      end

      it "returns the created result" do
        build_result = instance_double(BuildEval::Result::BuildResult)
        allow(BuildEval::Result::BuildResult).to receive(:create).and_return(build_result)

        expect(subject).to eql(build_result)
      end

    end

  end

end
