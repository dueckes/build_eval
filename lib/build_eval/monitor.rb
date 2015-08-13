module BuildEval

  class Monitor

    def initialize(args)
      @server      = args[:server]
      @build_names = args[:build_names]
    end

    def evaluate
      BuildEval::BuildResults.new(@build_names.map { |build_name| @server.build_result(build_name) })
    end

  end
end
