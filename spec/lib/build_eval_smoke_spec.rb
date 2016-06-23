describe BuildEval, "integrating with a real CI server", smoke: true do

  let(:builds)  { BuildEval::Examples::Travis.builds }

  let(:monitor) { BuildEval::Examples::Travis.monitor }

  describe "the evaluated results from a build monitor for the server" do

    let(:tolerated_statuses) do
      [
        BuildEval::Result::Status::SUCCESS,
        BuildEval::Result::Status::UNKNOWN,
        BuildEval::Result::Status::FAILURE,
        BuildEval::Result::Status::ERROR
      ]
    end

    subject { monitor.evaluate }

    it "indicates the combined status of all builds" do
      expect(tolerated_statuses).to include(subject.status)
    end

    it "describes the builds and their individual status" do
      builds.each do |build|
        expect(subject.to_s).to match(/#{build}: (#{tolerated_statuses.map(&:to_s).join("|")})/)
      end
    end

  end

end
