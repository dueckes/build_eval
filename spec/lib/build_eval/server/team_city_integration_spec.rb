describe BuildEval::Server::TeamCity, "integrating with a response parser", integration: true do
  include_context "stubbed http interactions"

  let(:uri) { "https://some.teamcity.server" }

  let(:team_city_server) { described_class.new(uri: uri) }

  describe "#build_result" do

    let(:build_name)       { "some_build_name" }
    let(:response_message) { nil }
    let(:response_body)    { nil }
    let(:response)         { instance_double(Net::HTTPResponse, message: response_message, body: response_body) }

    subject { team_city_server.build_result(build_name) }

    before(:example) { allow(http).to receive(:get).and_return(response) }

    context "when the server responds with build results" do

      let(:latest_build_status) { "FAILED" }
      let(:response_message)    { "OK" }
      let(:response_body) do
        <<-RESPONSE
          <builds count="3" href="/httpAuth/app/rest/buildTypes/#{build_name}/builds/" nextHref="/httpAuth/app/rest/buildTypes/#{build_name}/builds/?count=3&start=3">
            <build id="87735" buildTypeId="#{build_name}" number="2062" status="#{latest_build_status}" state="finished" href="/httpAuth/app/rest/builds/id:87735" webUrl="#{uri}/viewLog.html?buildId=87735&buildTypeId=#{build_name}"/>
            <build id="87723" buildTypeId="#{build_name}" number="2061" status="SUCCESS" state="finished" href="/httpAuth/app/rest/builds/id:87723" webUrl="#{uri}/viewLog.html?buildId=87723&buildTypeId=#{build_name}"/>
            <build id="87658" buildTypeId="#{build_name}" number="2060" status="SUCCESS" state="finished" href="/httpAuth/app/rest/builds/id:87658" webUrl="#{uri}/viewLog.html?buildId=87658&buildTypeId=#{build_name}"/>
          </builds>
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

    context "when the server authentication request fails" do

      let(:response_message) { "Unauthorized" }
      let(:response_body)    { "Incorrect username or password" }

      it "raises an error" do
        expect { subject }.to raise_error(/Unauthorized/)
      end

    end

    context "when the build is not found" do

      let(:response_message) { "Not Found" }
      let(:response_body) do
        <<-BODY
        Error has occurred during request processing (Not Found).
        Error: jetbrains.buildServer.server.rest.errors.NotFoundException: No build type nor template is found by id "#{build_name}".
        BODY
      end

      it "raises an error" do
        expect { subject }.to raise_error(/Not Found/)
      end

    end

  end

end
