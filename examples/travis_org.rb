module BuildEval
  module Examples

    class TravisOrg

      class << self

        def build_configurations
          %w{ build_eval build_eval:v0.0.1 http_stub_producer_example }
        end

        def monitor
          BuildEval.server(
            type:     :TravisOrg,
            username: "MYOB-Technology"
          ).monitor(*build_configurations)
        end

        def display_statuses
          puts monitor.evaluate.to_s
        end

      end

    end

  end
end
