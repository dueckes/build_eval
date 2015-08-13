describe BuildEval::CIServer::TeamCity do

  let(:scheme)   { "http" }
  let(:host)     { "some.teamcity.server" }
  let(:uri)      { "#{scheme}://#{host}" }
  let(:username) { "some_username" }
  let(:password) { "some_password" }

  let(:team_city) { described_class.new(uri: uri, username: username, password: password) }

  describe "#build_result" do

    let(:build_name)  { "some_build_name" }
    let(:last_status) { "FAILED" }

    let(:expected_uri) do
      "#{scheme}://#{username}:#{password}@#{host}/httpAuth/app/rest/buildTypes/id:#{build_name}/builds"
    end

    subject { team_city.build_result(build_name) }

    before(:example) { FakeWeb.register_uri(:get, expected_uri, body: response_body, status: response_status) }

    context "when the server responds with build results" do

      let(:response_body) do
        <<-RESPONSE
          <builds count="3" href="/httpAuth/app/rest/buildTypes/#{build_name}/builds/" nextHref="/httpAuth/app/rest/buildTypes/#{build_name}/builds/?count=3&start=3">
          <build id="87735" buildTypeId="#{build_name}" number="2062" status="#{last_status}" state="finished" href="/httpAuth/app/rest/builds/id:87735" webUrl="#{uri}/viewLog.html?buildId=87735&buildTypeId=#{build_name}"/>
          <build id="87723" buildTypeId="#{build_name}" number="2061" status="SUCCESS" state="finished" href="/httpAuth/app/rest/builds/id:87723" webUrl="#{uri}/viewLog.html?buildId=87723&buildTypeId=#{build_name}"/>
          <build id="87658" buildTypeId="#{build_name}" number="2060" status="SUCCESS" state="finished" href="/httpAuth/app/rest/builds/id:87658" webUrl="#{uri}/viewLog.html?buildId=87658&buildTypeId=#{build_name}"/>
          </builds>
        RESPONSE
      end
      let(:response_status) { [ "200", "OK" ] }

      it "creates a build result containing the build name" do
        expect(BuildEval::BuildResult).to receive(:create).with(hash_including(build_name: build_name))

        subject
      end

      it "creates a build result containing the latest build status" do
        expect(BuildEval::BuildResult).to receive(:create).with(hash_including(status_name: last_status))

        subject
      end

      it "returns the created result" do
        build_result = instance_double(BuildEval::BuildResult)
        allow(BuildEval::BuildResult).to receive(:create).and_return(build_result)

        expect(subject).to eql(build_result)
      end

      context "and the uri has a https scheme" do

        let(:scheme) { "https" }

        it "creates a build result from the response" do
          expect(BuildEval::BuildResult).to receive(:create).with(hash_including(status_name: last_status))

          subject
        end

      end

    end

    context "when the server authentication request fails" do

      let(:response_body)   { "Incorrect username or password" }
      let(:response_status) { [ "401", "Unauthorized" ] }

      it "raises an error" do
        expect { subject }.to raise_error(/Unauthorized/)
      end

    end

    context "when the build is not found" do

      let(:response_body) do
        <<-BODY
        Error has occurred during request processing (Not Found).
        Error: jetbrains.buildServer.server.rest.errors.NotFoundException: No build type nor template is found by id '#{build_name}'.
        BODY
      end
      let(:response_status) { [ "404", "Not Found" ] }

      it "raises an error" do
        expect { subject }.to raise_error(/Not Found/)
      end

    end

    context "when the server cannot be reached" do

      let(:expected_uri)    { "http://some.invalid.uri" }
      let(:response_body)   { nil }
      let(:response_status) { nil }

      it "raises an error" do
        expect { subject }.to raise_error(/Not Found/)
      end

    end

  end

end
