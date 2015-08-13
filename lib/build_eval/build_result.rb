module BuildEval

  class BuildResult

    class << self

      def create(args)
        self.new(build_name: args[:build_name], status: BuildEval::Status.find(args[:status_name]))
      end

      def unknown(build_name)
        self.new(build_name: build_name, status: BuildEval::Status::UNKNOWN)
      end

    end

    attr_reader :build_name
    attr_reader :status

    private

    def initialize(args)
      @build_name = args[:build_name]
      @status     = args[:status]
    end

    public

    def unsuccessful?
      @status.unsuccessful?
    end

    def to_s
      "#{@build_name}: #{@status}"
    end

  end

end
