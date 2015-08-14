module BuildEval

  class Status

    private

    def initialize(args)
      @severity    = args[:severity]
      @symbol      = args[:symbol]
      @description = args[:description]
    end

    public

    SUCCESS = self.new(severity: 0, symbol: :success!, description: "succeeded")
    FAILURE = self.new(severity: 2, symbol: :failed!,  description: "failed")
    UNKNOWN = self.new(severity: 1, symbol: :warning!, description: "unknown")

    class << self

      def find(name)
        begin
          self.const_get(name.upcase)
        rescue NameError
          raise "Build status '#{name}' is invalid"
        end
      end

      def effective_status(statuses)
        statuses.sort_by { |status| status.severity }.last
      end

    end

    attr_reader :severity

    def unsuccessful?
      self != SUCCESS
    end

    def to_sym
      @symbol
    end

    def to_s
      @description
    end

  end

end
