describe BuildEval::Server::TeamCity do

  let(:uri)      { "https://some.teamcity.server" }
  let(:username) { "some_username" }
  let(:password) { "some_password" }

  let(:team_city) { described_class.new(uri: uri, username: username, password: password) }

  describe "#build_result" do

    let(:build_name)       { "some_build_name" }
    let(:response_code)    { nil }
    let(:response_message) { nil }
    let(:response_body)    { nil }
    let(:response)         do
      instance_double(Net::HTTPResponse, code: response_code, message: response_message, body: response_body)
    end

    subject { team_city.build_result(build_name) }

    before(:example) { allow(BuildEval::Http).to receive(:get).and_return(response) }

    it "issues a get request for the build" do
      expected_uri = "#{uri}/httpAuth/app/rest/buildTypes/id:#{build_name}/builds"
      expect(BuildEval::Http).to receive(:get).with(expected_uri, anything)

      subject rescue Exception
    end

    it "issues a get request with the provided basic authentication credentials" do
      expect(BuildEval::Http).to receive(:get).with(anything, username: username, password: password)

      subject rescue Exception
    end

    context "when the server responds with build results" do

      let(:response_code)       { "200" }
      let(:response_message)    { "OK" }
      let(:latest_build_status) { "FAILED" }
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

      let(:response_code)  { "401" }
      let(:response_message) { "Unauthorized" }
      let(:response_body)    { "Incorrect username or password" }

      it "raises an error" do
        expect { subject }.to raise_error(/Unauthorized/)
      end

    end

    context "when the build is not found" do

      let(:response_code)    { "404" }
      let(:response_message) { "Not Found"  }
      let(:response_body) do
        <<-BODY
        Error has occurred during request processing (Not Found).
        Error: jetbrains.buildServer.server.rest.errors.NotFoundException: No build type nor template is found by id '#{build_name}'.
        BODY
      end

      it "raises an error" do
        expect { subject }.to raise_error(/Not Found/)
      end

    end

  end

  describe "#to_s" do

    subject { team_city.to_s }

    it "returns a string indicating it is a TeamCity server" do
      expect(subject).to include("TeamCity")
    end

    it "returns a string containing the uri to the server" do
      expect(subject).to include(uri)
    end

  end

end
