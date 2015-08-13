module BuildEval

  class BuildResults

    def initialize(build_results)
      @build_results = build_results
    end

    def status
      BuildEval::Status.effective_status(@build_results.map(&:status))
    end

    def unsuccessful
      @build_results.find_all(&:unsuccessful?)
    end

    def to_s
      @build_results.map(&:to_s).join(", ")
    end

  end

end
