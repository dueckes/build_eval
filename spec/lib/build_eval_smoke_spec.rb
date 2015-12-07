describe BuildEval, "integrating with a real CI server", smoke: true do

  let(:server) { BuildEval.server(type: :Travis, username: "MYOB-Technology") }

  let(:monitor) { server.monitor("build_eval") }

  describe "the evaluated results from a build monitor for the server" do

    let(:tolerated_statuses) { [ BuildEval::Result::Status::SUCCESS, BuildEval::Result::Status::FAILURE ] }

    subject { monitor.evaluate }

    it "indicate the builds status" do
      expect(tolerated_statuses).to include(subject.status)
    end

    it "describe the build and it's status" do
      expect(subject.to_s).to match(/build_eval: (#{tolerated_statuses.map(&:to_s).join("|")})/)
    end

  end

end
