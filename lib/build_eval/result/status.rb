module BuildEval
  module Result

    class Status

      private

      def initialize(args)
        @severity    = args[:severity]
        @symbol      = args[:symbol]
        @description = args[:description]
      end

      public

      SUCCESS       = new(severity: 0, symbol: :success!,  description: "succeeded")
      BUILDING      = new(severity: 1, symbol: :building!, description: "building")
      UNKNOWN       = new(severity: 2, symbol: :warning!,  description: "unknown")
      INDETERMINATE = new(severity: 3, symbol: :warning!,  description: "indeterminate")
      FAILURE       = new(severity: 4, symbol: :failure!,  description: "failed")
      ERROR         = new(severity: 5, symbol: :failure!,  description: "errored")

      class << self

        def find(name)
          const_get(name.upcase)
        rescue NameError
          raise "Build status '#{name}' is invalid"
        end

        def effective_status(statuses)
          statuses.sort_by(&:severity).last
        end

      end

      attr_reader :severity

      def unsuccessful?
        ![ SUCCESS, BUILDING ].include?(self)
      end

      def to_sym
        @symbol
      end

      def to_s
        @description
      end

    end

  end
end
