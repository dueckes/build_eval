module BuildEval
  module Examples

    class Travis

      class << self

        def builds
          %w{ build_eval http_stub http_stub_producer_example }
        end

        def monitor
          BuildEval.server(
            type:     :Travis,
            username: "MYOB-Technology"
          ).monitor(*builds)
        end

        def display_statuses
          puts monitor.evaluate.to_s
        end

      end

    end

  end
end
